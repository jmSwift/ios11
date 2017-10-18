//
//  Post.swift
//  Flash Chat
//
//  Created by Jose on 10/15/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Post {
    private var _caption: String!
    private var _imageUrl: String!
    private var _postKey: String!
    private var _postRef = Database.database().reference()
    private var _senderId: String!
    
    var senderId: String{
        return _senderId
    }
    var caption: String {
        return _caption
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
  
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String) {
        self._caption = caption
        self._imageUrl = caption
        //10/17
        self._senderId = "jose"
        //
       
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let senderId = postData["senderId"] as? String{
            self._senderId = senderId
        }
        _postRef = Data.instance.REF_POSTS.child(_postKey)
        
        
    }
    
   
    
}
