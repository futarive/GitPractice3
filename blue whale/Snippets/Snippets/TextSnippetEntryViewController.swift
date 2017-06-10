//
//  TextSnippetEntryViewController.swift
//  Snippets
//
//  Created by 王家永 on 2017/6/10.
//  Copyright © 2017年 王家永. All rights reserved.
//

import Foundation
import UIKit

class TextSnippetEntryViewController:UIViewController{
    
    @IBOutlet weak var textView: UITextView!
    
    var saveText:(_ text:String) ->Void = {
        (text:String) in )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.inputAccessoryView = createKeyboardToolbar()
        
        textView.becomeFirstResponder()
    }
    
        func createKeyboardToolbar() ->UIView{
            
            let keyboardToolbar = UIToolbar(frame:CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:44))
            
            let flexspace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace,target:nil,action:nil)
            
            let doneButton = UIBarButtonItem(barButtonSystemItem:.done,target:self,action:#selector(doneButtonPressed))
            
            keyboardToolbar.setItems([flexspace,doneButton], animated: false)
            
            return keyboardToolbar
        }
        
        func doneButtonPressed() {
            textView.resignFirstResponder()
        }
   }

extension TextSnippetEntryViewController: UITextViewDelegate{
    
        func textViewDidEndEditing (_ textView:UITextView){
           saveText(textView.text)
           dismiss(animated: true,completion: nil)
        }
   }
