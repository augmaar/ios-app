//
//  PurchaseController.swift
//  Augma
//
//  Created by Chase Carnaroli on 3/6/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit

class PurchaseController: UIViewController {

    var piece: [String:Any]!
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadPiece()
    }
    
    func loadPiece() {
        titleLabel.text = piece["title"] as? String
        titleLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = piece["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        pictureView.af_setImage(withURL: posterUrl!)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
