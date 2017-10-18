//
//  PostsVC.swift
//  Flash Chat
//
//  Created by Jose on 10/2/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PostsVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var postsBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    
    @IBOutlet weak var postsTableView: UITableView!
   //@IBOutlet weak var tableView: UITableView!
    
    //
    var imagePicker: UIImagePickerController!
    
    var textviewEdited = false
    var messageArray = [Message]()
    
    var imageName = "\(NSUUID().uuidString).jpg"
    
    //new 10/17
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextView.delegate = self
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        //
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
 
        //10/17///
        Data.instance.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = [] // THIS IS THE NEW LINE
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            //reverse array
            self.posts = Array(self.posts.reversed())
            self.postsTableView.reloadData()
        })
        //end of new code
        
        
    }
    
    //
    
    func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            profileImage.image = image
            print("inside imagePickerController")
        }else{
            print("pic was not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        print("image tapped")
    }
 
 //
    @IBAction func postBtnPressed(_ sender: Any) {
       
        if messageTextView.text != nil && textviewEdited == true && messageTextView.text != "" {
            
            postsBtn.isEnabled = false
            //firebase---------------------

          //10/17 code
            var img = profileImage.image
            if let imgData = UIImageJPEGRepresentation(img!, 0.2) {
                
                let imgUid = NSUUID().uuidString
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                Data.instance.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print("jose Unable to upload image to Firebasee torage")
                    } else {
                        print("jose Successfully uploaded image to Firebase storage")
                        let downloadURL = metadata?.downloadURL()?.absoluteString
                        if let url = downloadURL {
                            self.postToFirebase(imgUrl: url)
                        }
                    }
                }
            }
            
            
            //end of 10/17 code
            
            
            /* OLD CODE
            Data.instance.uploadPost(withMessage: messageTextView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil
                , sendComplete: { (isComplete) in
                    if(isComplete){
                        
                        self.postsBtn.isEnabled = true
                        self.messageTextView.text = ""
                        print("post successful")
                        Data.instance.getAllFeedMessages { (returnedMessagesArray) in
                            //self.messageArray = returnedMessagesArray
                            self.messageArray = Array(returnedMessagesArray.reversed())
                            self.postsTableView.reloadData()
                        }
                    }else{
                        print("there was an error")
                        return
                    }
             
             //OLD CODE
               
            
            
            })//end of uploadPost
            
            //end of old CODE
             */
            
            
        }//end of if
 
                         
        
    }//end of postBtnPressed function
    
   

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Data.instance.getAllFeedMessages { (returnedMessagesArray) in
            self.messageArray = Array(returnedMessagesArray.reversed())
            self.postsTableView.reloadData()
        }
    }
    
    //new 10/17
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            "caption": messageTextView.text! as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "senderId": (Auth.auth().currentUser?.uid)! as AnyObject
            
        ]
        
        let firebasePost = Data.instance.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        messageTextView.text = ""
        imageSelected = false
        //imageAdd.image = UIImage(named: "add-image")
        
        postsTableView.reloadData()
    }
    //

}

extension PostsVC: UITextViewDelegate, UITableViewDelegate, UITableViewDataSource{
    func textViewDidBeginEditing(_ textView: UITextView) {
        messageTextView.text = ""
        textviewEdited = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //10/17
        return posts.count
        //end of 10/17
        
        
        //return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let post = posts[indexPath.row]
         if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostsCell {
            if let img = PostsVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        }else {
            return PostsCell()
        }
        
        /* OLD CODE
         
         guard let cell = postsTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostsCell else {return UITableViewCell()}
         
        let message = messageArray[indexPath.row]
        let image = UIImage(named: "defaultProfileImage")
        //
        Data.instance.getUsername(forUID: message.senderId) { (email) in
            
            cell.configureCell(profileImage: image!, email: email, content: message.content)
            
            
        }
      
        
        return cell
         
         ///OLD CODE
 */
    }
    
    
}

extension PostsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
}


