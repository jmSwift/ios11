//
//  PicMessageVC.swift
//  Flash Chat
//
//  Created by Jose on 10/4/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit
import FirebaseStorage

class PicMessageVC: UIViewController{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var imagePicker: UIImagePickerController!
    var imageAdded = false
    var imageName = "\(NSUUID().uuidString).jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }
    @IBAction func cameraBtnPressed(_ sender: Any) {
        if(imagePicker != nil){
            imagePicker.sourceType =  .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func folderBtnPressed(_ sender: Any) {
        if(imagePicker != nil){
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            imageAdded = true
        }
        
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func sendMessageBtn(_ sender: Any) {
        if imageAdded && messageTextField.text != "" {
            //upload the pic
            let imagesFolder = Storage.storage().reference().child("images");
            
            if let image = imageView.image{
                if let imageData = UIImageJPEGRepresentation(image, 0.1){
                    imagesFolder.child(imageName).putData(imageData, metadata: nil, completion: { (metadata, error) in
                        
                        if let error = error{
                            //display error message.
                            self.presentAlert(alert: error.localizedDescription)
                        }else{
                            //segue to next view controller
                            
                            if let downloadURL = metadata?.downloadURL()?.absoluteString{
                                self.performSegue(withIdentifier: "selectReceiverSegue", sender: downloadURL)
                            }
                        }
                    })
                }
            }
            
        }else{
            presentAlert(alert: "You must provide an image and text")
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let downloadURL = sender as? String{
            if let selectVC = segue.destination as? SelectRecepientTableViewController{
                selectVC.downloadURL = downloadURL
                selectVC.snapDescription = messageTextField.text!
                selectVC.imageName = imageName
            }
        }
    }
    func presentAlert(alert:String){
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {(action) in alertVC.dismiss(animated: true, completion:nil)
            
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
}

extension PicMessageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
}

