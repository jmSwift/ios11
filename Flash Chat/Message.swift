//
//  Message.swift
//  Flash Chat
//
//  This is the model class that represents the blueprint for a message
import Foundation

class Message {
    private var _content: String
    private var _senderId: String
    
    //added for posts with pics
   // private var _likes: Int!
   // private var _imageUrl: String
    
    private var _imageUrl: String
    
    var content: String{
        return _content
    }
    
    var senderId:String {
        return _senderId
    }
    
    /*var likes:Int {
        return _likes
    }
 
    var imageUrl: String{
        return _imageUrl
    }
       */
    //old init
    
    var imageUrl: String{
        return _imageUrl
    }
   
    
    init(content:String, senderId:String){
        self._content = content
        self._senderId = senderId
        self._imageUrl = content
    }
    
    init(senderId:String){
        self._content = ""
        self._senderId = senderId
        self._imageUrl = ""
    }
 
    init(content:String, senderId:String, imageUrl:String){
        self._content = content
        self._senderId = senderId
        self._imageUrl = imageUrl
    }
    
    //TODO: Messages need a messageBody and a sender variable
    
    
    
}
