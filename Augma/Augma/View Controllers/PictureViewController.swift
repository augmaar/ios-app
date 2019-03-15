//
//  PictureViewController.swift
//  Augma
//
//  Created by Chase Carnaroli on 3/3/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController {
    
    var piece: Piece?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBOutlet weak var pictureView: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "PictureViewBG")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        loadPiece()
        
    }
    
    func loadPiece() {
        titleLabel.text = piece!.title
        titleLabel.sizeToFit()
        let user: String = piece!.seller.username as! String
        var first_name: String = piece!.seller.object(forKey: "first_name") as! String
        var last_name: String = piece!.seller.object(forKey: "last_name") as! String
        var name: String = first_name + " " + last_name + "\n" + user
        descriptionLabel.text = name
        priceLabel.text = "$" + (piece?.price)!
        
        pictureView.image = piece!.image
        
        
        //descriptionLabel.text = piece["overview"] as? String
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.Purchase.rawValue {
            let purchaseVC = segue.destination as! PurchaseController
            purchaseVC.piece = piece
        } else if segue.identifier == Segue.AR.rawValue {
            let arVC = segue.destination as! ARViewController
            arVC.piece = piece
        }
    }
    

}
