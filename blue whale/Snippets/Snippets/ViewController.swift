//
//  ViewController.swift
//  Snippets
//
//  Created by 王家永 on 2017/6/8.
//  Copyright © 2017年 王家永. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var data:[SnippetData] = [SnippetData] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func creatNewSnippet(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Select a snippet type!",message:nil,preferredStyle:.actionSheet)
        
        let textAction =  UIAlertAction(title:"Text",style:.default) {
            (alert:UIAlertAction!)->Void in self.data.append(SnippetData(snippetType:.text))
        }
        
        let photoAction =  UIAlertAction(title:"Photo",style:.default) {
            (alert:UIAlertAction!)->Void in self.data.append(SnippetData(snippetType:.photo))
        }
        
        let cancelAction = UIAlertAction(title:"Cancel",style:.cancel,handler:nil)
        alert.addAction(textAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil)
    }
    
}

