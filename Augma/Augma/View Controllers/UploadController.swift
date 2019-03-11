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

class UploadController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func onUploadButton(_ sender: Any) {
        print("image tapped")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        // If camera available, use camera, else use the photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
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
    

}
