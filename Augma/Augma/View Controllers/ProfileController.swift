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

class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var artwork = [Piece]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 4 // Space in between ROWS
        layout.minimumInteritemSpacing = 4
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 2
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        let query = PFQuery(className: "Picture")
        //query.includeKeys(["author", "comments", "comments.author"])
        
        query.findObjectsInBackground { (pics, error) in
            if let pieces = pics {
                for pieceDict in pieces {
                    let imageFile = pieceDict["image"] as! PFFileObject
                    let url = URL(string: imageFile.url!)!
                    let data = try? Data(contentsOf: url)
                    let pic = UIImage(data: data!)
                    let piece = Piece(title: pieceDict["title"] as! String,
                                      tags: pieceDict["tags"] as! [String],
                                      price: pieceDict["price"] as! String,
                                      image: pic!)
                    self.artwork.append(piece)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artwork.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.PictureGridCell.rawValue, for: indexPath) as! PictureGridCell
        
        let piece = artwork[indexPath.item]
        cell.pictureView.image = piece.image
        
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

}
