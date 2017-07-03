//
//  ConfirmationInterfaceController.swift
//  Snippets
//
//  Created by 王家永 on 2017/7/3.
//  Copyright © 2017年 王家永. All rights reserved.
//

import WatchKit
import Foundation

class ConfirmationContext{
    
    let textString:String
    let confirmAction:(String) -> Void
    let tryAgainAction:() -> Void
    
    init (textString:String,confirmAction:@escaping(String) -> Void,tryAgainAction:@escaping() -> Void) {
        self.textString = textString
        self.confirmAction = confirmAction
        self.tryAgainAction  = tryAgainAction
    }
}

class ConfirmationInterfaceController: WKInterfaceController {

    @IBOutlet var resultsLabel: WKInterfaceLabel!
    
    var currentContext:confirmationContext?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let c = context as? confirmationContext {
            currentContext = c
            resultsLabel.setText(c.textString)
        }

    }

    @IBAction func confirmText() {
        popToRootController()
        if let context = currentContext{
            context.confirmAction(context.textString)
        }
    }
    @IBAction func tryAgain() {
        popToRootController()
        if let context = currentContext{
            context.tryAgainAction()
        }
    }
    @IBAction func cancel() {
        popToRootController()
    }
    
}
