//
//  LoginViewController.swift
//  Augma
//
//  Created by Tam Nguyen on 3/7/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var forgotPWButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBAction func loginButton(_ sender: Any) {
        print("Email: \(emailField!)")
        print("Password: \(passwordField!)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "LoginBG")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        /*
        let image = UIImage(named: "LoginBG.png")
        if (image != nil) {
            self.view.backgroundColor = UIColor(patternImage: image!)
        } else {
            self.view.backgroundColor = UIColor.red
        }*/
        
        // Do any additional setup after loading the view.
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
