//
//  InterfaceController.swift
//  Snippets-Watch Extension
//
//  Created by 王家永 on 2017/7/1.
//  Copyright © 2017年 王家永. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController,WCSessionDelegate {

    var session:WCSession?
    
    func session( _ session:WCSession,activationDidCompleteWith activationState:WCSessionActivationState,error:Error?){
            return
    }
    
       override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        session = WCSession.default()
        session?.delegate = self
        session?.activate()
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
        let processText = {
            (text:String) in let info = ["textData":text]
            self.session?.sendMessage(info,replyHandler:nil,errorHandler:nil)
        }
        let confirmContext = ConfirmationContext(textString:string,confirmAction:processText,tryAgainAction:tryToGetText)
        
        pushController(withName:"confirmation",context:confirmContext)
    }
}
