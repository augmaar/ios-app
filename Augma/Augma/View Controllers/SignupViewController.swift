//
//  SignupViewController.swift
//  Augma
//
//  Created by Tam Nguyen on 3/12/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController {

    let screenSize = UIScreen.main.bounds
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    
    
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    
    @IBOutlet weak var noMatchLabel: UILabel!
    @IBOutlet weak var incompleteLabel: UILabel!
    @IBOutlet weak var emailExistsLabel: UILabel!
    
    @IBAction func signUpButton(_ sender: Any) {
        let user = PFUser()
        
        if (passwordField.text != confirmField.text) {
            noMatchLabel.isHidden = false
            incompleteLabel.isHidden = true
            emailExistsLabel.isHidden = true
            scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
            return
        } else if (firstNameField.text == "" || lastNameField.text == "" || emailField.text == "" || passwordField.text == "" || addressField.text == "" || cityField.text == "" || stateField.text == "" || zipField.text == "") {
            incompleteLabel.isHidden = false
            noMatchLabel.isHidden = true
            emailExistsLabel.isHidden = true
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            return
        } else {
            user.username = emailField.text
            user.password = passwordField.text
            user["first_name"] = firstNameField.text!
            user["last_name"] = lastNameField.text!
            user["address"] = addressField.text!
            user["city"] = cityField.text!
            user["state"] = stateField.text!
            user["zip"] = zipField.text!
            
            user.signUpInBackground { (success, error) in
                if success {
                    print("Successfully signed up")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.emailExistsLabel.isHidden = false
                    self.noMatchLabel.isHidden = true
                    self.incompleteLabel.isHidden = true
                    print("Error: \(error?.localizedDescription)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noMatchLabel.isHidden = true
        incompleteLabel.isHidden = true
        emailExistsLabel.isHidden = true;
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        var swipeDown = UISwipeGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
