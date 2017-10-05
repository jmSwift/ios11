//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        

        
        //TODO: Set up a new user on our Firbase database
        
        AuthService.instance.registerUser(withEmail: emailTextfield.text!, andPassword: passwordTextfield.text!, userCreationComplete: ({ (user, error) in
            
            if(error != nil){
                print(error)
            }
            else{
                print("account created")
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }))
        
        
        
    } 
    
    
}
