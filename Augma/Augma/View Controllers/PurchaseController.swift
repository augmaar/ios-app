//
//  PurchaseController.swift
//  Augma
//
//  Created by Chase Carnaroli on 3/6/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit
import Parse

class PurchaseController: UIViewController {

    var piece: Piece?
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var creditCardNameLabel: UITextField!
    @IBOutlet weak var creditCardNumberLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        var swipeDown = UISwipeGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        loadPiece()
    }
    
    func loadPiece() {
        titleLabel.text = piece!.title
        priceLabel.text = "$" + piece!.price
        titleLabel.sizeToFit()
        
        pictureView.image = piece!.image
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func purchaseTapped(_ sender: Any) {
        if creditCardNameLabel.text == "" || creditCardNumberLabel.text == "" {
            let alert = UIAlertController(title: "Missing Required Field", message: "You must enter both your Full Name and Credit Card to purchase a painting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
        
            let post = PFObject(className: "Order")
            
            post["artwork_id"] = piece?.id
            post["credit_card_name"] = creditCardNameLabel.text
            post["credit_card_number"] = creditCardNumberLabel.text
            post["buyer"] = PFUser.current()
            
            post.saveInBackground { (success, error) in
                if success {
                    print("Saved!")
                } else {
                    print("Error saving post, \(error?.localizedDescription)")
                }
            }
            
            let purchaseAlert = UIAlertController(title: "Purchased!", message: "You have successfully purchased \"\(piece!.title)\"", preferredStyle: .alert)
            purchaseAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(purchaseAlert, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // Keyboard show/hide functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height - 100)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

}
