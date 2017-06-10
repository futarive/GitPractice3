//
//  SnippetData.swift
//  Snippets
//
//  Created by 王家永 on 2017/6/8.
//  Copyright © 2017年 王家永. All rights reserved.
//

import Foundation

enum SnippetType:String {
    case text = "Text"
    case photo = "Photo"
}

 class SnippetData{
    
    let type:SnippetType
    
    init (snippetType:SnippetType) {
        
        type = snippetType
        print("\(type.rawValue) snippet created")
    }
}
class TextData:SnippetData {
    let textData:String
    
    init(text:String) {
        textData = text
        super.init(snippetType: .text)
        print("Text snippet data:\(textData)")
    }
}
