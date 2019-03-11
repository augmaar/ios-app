//
//  PictureViewController.swift
//  Augma
//
//  Created by Chase Carnaroli on 3/3/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController {
    
    var piece: [String:Any]!
    
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
        
        
        titleLabel.text = piece["title"] as? String
        titleLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = piece["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        pictureView.af_setImage(withURL: posterUrl!)
        
        descriptionLabel.text = piece["overview"] as? String
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
