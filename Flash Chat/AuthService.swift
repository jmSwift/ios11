//
//  AuthService.swift
//  Flash Chat
//
//  Created by Jose on 9/24/17.



import Foundation
import Firebase

class AuthService{
    static let instance = AuthService()
    
    //withEmail andPassword are internal parameters
    func registerUser(withEmail email:String, andPassword password:String, userCreationComplete:@escaping(_ status:Bool, _ error:Error?)-> ()){
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
           guard let user = user else{
            userCreationComplete(false,error)
           
                return
            }
            
            let userData = ["provider": user.providerID, "email": user.email]
            
            Data.instance.createDBUser(uid: user.uid, userData: userData)
            userCreationComplete(true,nil)
            
            
            
           
        }
    }
    
    func loginUser(withEmail email:String, andPassword password:String, loginComplete:@escaping(_ status:Bool, _ error:Error?)-> ()){
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let user = user else{
                loginComplete(false,error)
                return
            }
            
            loginComplete(true,nil)
        }
    }
    
    
}
