//
//  Message.swift
//  Flash Chat
//
//  This is the model class that represents the blueprint for a message
import Foundation

class Message {
    private var _content: String
    private var _senderId: String
    
    var content: String{
        return _content
    }
    
    var senderId:String {
        return _senderId
    }
    
    init(content:String, senderId:String){
        self._content = content
        self._senderId = senderId
    }
    //TODO: Messages need a messageBody and a sender variable
    
    
    
}
