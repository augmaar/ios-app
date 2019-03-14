//
//  PurchaseController.swift
//  Augma
//
//  Created by Chase Carnaroli on 3/6/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit

class PurchaseController: UIViewController {

    var piece: Piece?
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadPiece()
    }
    
    func loadPiece() {
        titleLabel.text = piece!.title
        titleLabel.sizeToFit()
        
        pictureView.image = piece!.image
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
