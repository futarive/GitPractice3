//
//  SnippetData.swift
//  Snippets
//
//  Created by 王家永 on 2017/6/8.
//  Copyright © 2017年 王家永. All rights reserved.
//

import Foundation
import UIKit

enum SnippetType:String {
    case text = "Text"
    case photo = "Photo"
}

class SnippetData{
    
    let type:SnippetType
    let date:Date
    
    init (snippetType:SnippetType,creationDate:Date) {
        
        type = snippetType
        date = creationDate
        print("\(type.rawValue) snippet created at \(date)")
    }
}

class TextData:SnippetData {
    let textData:String
    
    init(text:String,creationDate:Date) {
        textData = text
        super.init(snippetType: .text,creationDate: creationDate)
        print("Text snippet data:\(textData)")
    }
}

class PhotoData:SnippetData{
    
    let photoData:UIImage
    
    init(photo:UIImage,creationDate:Date) {
        
        photoData = photo
        super.init(snippetType: .photo,creationDate: creationDate)
        
        print("Photo snippet data:\(photoData)")
    }
}

