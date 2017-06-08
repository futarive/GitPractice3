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
        let newSnippet = SnippetData()
        data.append(newSnippet)
    }

}

