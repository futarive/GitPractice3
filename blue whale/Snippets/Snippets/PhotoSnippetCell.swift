//
//  PhotoSnippetCell.swift
//  Snippets
//
//  Created by 王家永 on 2017/6/10.
//  Copyright © 2017年 王家永. All rights reserved.
//

import UIKit

class PhotoSnippetCell:UITableViewCell {
    
    var shareButton:(() -> Void)?
    
    @IBOutlet var photo:UIImageView!
    
    @IBOutlet var date:UILabel!
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        if let callback = shareButton{
               callback()
        }
    }
}
