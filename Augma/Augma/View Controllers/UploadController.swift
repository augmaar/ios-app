//
//  UploadController.swift
//  Augma
//
//  Created by Chase Carnaroli on 3/3/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import TagListView

class UploadController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, TagListViewDelegate {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    var tags = ["art", "painting"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagsTextField.delegate = self
        tagListView.delegate = self

        tagListView.addTags(tags)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        let swipeDown = UISwipeGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
   
    @IBAction func onUploadButton(_ sender: Any) {
        print("image tapped")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        // If camera available, use camera, else use the photo library
        // changed from just going straight to the library instead of camera
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.sourceType = .photoLibrary
        }

        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFit: size)
        photoView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    // Add tags from text input field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return key pressed")
        let input = tagsTextField.text?.components(separatedBy: CharacterSet.whitespaces)
        
        if input != nil {
            tags += input!
        }
        
        tagsTextField.text = nil
        tagListView.addTags(input!)
        
        return true
    }
    
    // Remove tag when tag is tapped
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tags.removeAll { $0 == title }
        tagListView.removeTag(title)
    }
    
    @IBAction func postButton(_ sender: Any) {
        let post = PFObject(className: "Picture")
        
        post["title"] = titleTextField.text
        post["price"] = priceTextField.text
        post["tags"] = tags
        post["seller"] = PFUser.current()
        
        let imageData = photoView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Saved!")
            } else {
                print("Error saving post, \(error?.localizedDescription)")
            }
        }
        
        self.tabBarController!.selectedIndex = 0
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//        super.touchesBegan(touches, with: event)
//    }
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
