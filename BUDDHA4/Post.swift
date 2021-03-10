//
//  Post.wift.swift
//  abseil
//
//  Created by 片山義仁 on 2019/12/11.
//


import Foundation
import Firebase

struct Post {
    let content: String
    let postID: String
    let createdAt: Date?
    let updatedAt: Date?
    let imageURL: String
    let feelingType: FeelingType
    let userID: String
    
    
    
    
    
    init(data: [String: Any]) {
        content = data["content"] as! String
        postID = data["postID"] as! String
       
        createdAt = Date(timeIntervalSince1970: data["createdAt"] as! Double)
        updatedAt = Date(timeIntervalSince1970: -(data["updatedAt"] as! Double))
        
        imageURL = data["ImageURL"] as! String
        feelingType = FeelingType(rawValue: data["FeelingType"] as! Int)!
        userID = data["userID"] as! String
    }
}

enum FeelingType: Int{
    case happy    //0
    case love     //1
    case angry    //2
    case funny    //3
    case sad      //4
    case envy     //5
    case surprise //6
    case nothing  //7
}


