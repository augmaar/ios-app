//
//  ProfileController.swift
//  Augma
//
//  Created by Chase Carnaroli on 3/3/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var numPiecesLabel: UILabel!

    var artwork = [Piece]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let user = PFUser.current()!
        var name: String
        if let first = user["first_name"] {
            name = first as! String
            if let last = user["last_name"] {
                name += " "
                name += last as! String
            }
        } else {
            name = user["username"] as! String
        }
        usernameLabel.text = name
        
        if user["profilePic"] != nil {
            let imageFile = user["profilePic"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            profilePicView.af_setImage(withURL: url)
        }
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 4 // Space in between ROWS
        layout.minimumInteritemSpacing = 4
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 2
        layout.itemSize.width = width
        
        let query = PFQuery(className: "Picture")
        // ToDo: set query to only get results for user
        query.whereKey("seller", contains: PFUser.current()?.objectId)
        query.includeKeys(["seller"])
        
        query.findObjectsInBackground { (pics, error) in
            if let pieces = pics {
                for pieceDict in pieces {
                    let imageFile = pieceDict["image"] as! PFFileObject
                    let url = URL(string: imageFile.url!)!
                    let data = try? Data(contentsOf: url)
                    let pic = UIImage(data: data!)
                    let piece = Piece(id: pieceDict.objectId!,
                                      title: pieceDict["title"] as! String,
                                      tags: pieceDict["tags"] as! [String],
                                      price: pieceDict["price"] as! String,
                                      image: pic!,
                                      seller: pieceDict["seller"] as! PFUser)
                    self.artwork.append(piece)
                    self.collectionView.reloadData()
                }
                self.numPiecesLabel.text = "\(self.artwork.count) pieces listed for sale"
            }
            print(self.artwork)
        }
        
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artwork.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.PictureGridCell.rawValue, for: indexPath) as! PictureGridCell
        
        let piece = artwork[indexPath.item]

        cell.pictureView.image = piece.image
        cell.artTitleLabel.text = piece.title
        cell.priceLabel.text = "$" + piece.price
        cell.sellerLabel.text = piece.seller.object(forKey: "first_name") as! String
        
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        
        let piece = artwork[indexPath.row]
        
        let pictureVC = segue.destination as! PictureViewController
        
        pictureVC.piece = piece
    }
    
    @IBAction func onChangeProfilePicButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        // If camera available, use camera, else use the photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 190, height: 190)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        profilePicView.image = scaledImage
        
        let imageData = scaledImage.pngData()
        let file = PFFileObject(data: imageData!)
        let user = PFUser.current()!
        user["profilePic"] = file
        
        user.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Profile picture saved!")
            } else {
                print("Error saving profile picture")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }

}
