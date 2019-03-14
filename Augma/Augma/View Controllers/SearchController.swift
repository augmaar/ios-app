//
//  SearchController.swift
//  Augma
//
//  Created by Chase Carnaroli on 3/3/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import AlamofireImage

class SearchController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var artwork = [Piece]()
    var filteredArtwork = [Piece]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        
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
                    self.filteredArtwork = self.artwork
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredArtwork.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.PictureGridCell.rawValue, for: indexPath) as! PictureGridCell
        
        let piece = filteredArtwork[indexPath.item]
        cell.pictureView.image = piece.image
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredArtwork = searchText.isEmpty ? artwork : artwork.filter { (piece: Piece) -> Bool in
            // If dataItem matches the searchText, return true to include it
            let title = piece.title
            return title.lowercased().contains(searchText.lowercased())
        }
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(filteredArtwork[indexPath.item].title)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        
        let piece = filteredArtwork[indexPath.row]
        
        let pictureVC = segue.destination as! PictureViewController
        
        pictureVC.piece = piece
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
    }
}
