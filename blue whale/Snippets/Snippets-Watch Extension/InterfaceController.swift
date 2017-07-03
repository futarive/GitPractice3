//
//  InterfaceController.swift
//  Snippets-Watch Extension
//
//  Created by 王家永 on 2017/7/1.
//  Copyright © 2017年 王家永. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

       override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    
    @IBAction func createNewTextSnippet() {
        tryToGetText()
    }
    
    func tryToGetText() {
        presentTextInputController(withSuggestions:nil,allowedInputMode:.plain,completion:processResults)
    }
    
    func processResults(results:[Any]?) {
        guard let r = results?[0],let string = r as? String else{
        return
        }
        pushController(withName:"confirmation",context:nil)
    }
}
