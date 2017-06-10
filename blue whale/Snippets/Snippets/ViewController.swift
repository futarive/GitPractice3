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
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    @IBAction func creatNewSnippet(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Select a snippet type!",message:nil,preferredStyle:.actionSheet)
        
        let textAction =  UIAlertAction(title:"Text",style:.default) {
            (alert:UIAlertAction!)->Void in self.creatNewTextSnippet()
        }
        
        let photoAction =  UIAlertAction(title:"Photo",style:.default) {
            (alert:UIAlertAction!)->Void in self.creatNewPhotoSnippet()
        }
        
        let cancelAction = UIAlertAction(title:"Cancel",style:.cancel,handler:nil)
        alert.addAction(textAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil)
    }
    
    func creatNewTextSnippet() {
        guard let textEntryVC = storyboard?.instantiateViewController(withIdentifier:"textSnippetEntry") as? TextSnippetEntryViewController
            else {
                print("TextSnippetEntryViewController could not be instantiated from storyborad")
                return
           }
    
    textEntryVC.modalTransitionStyle = .coverVertical
    
    textEntryVC.saveText = { (text:String ) in
      let newTextSnippet = TextData(text:text)
        
      self.data.append(newTextSnippet)
    }
    
    present(textEntryVC,animated:true,completion:nil)
  }
    
    func creatNewPhotoSnippet() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera is not available")
            return
        }
    imagePicker.allowsEditing = true
    imagePicker.sourceType = .camera
    present(imagePicker,animated: true,completion: nil)
    }
}
extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePicekerController(_ picker:UIImagePickerController,didFinishPickingMediaWithInfo info:[String:Any]) {
        guard let image = info [UIImagePickerControllerEditedImage] as? UIImage else {
            print("Image could not be found")
            return
        }
    let newPhotoSnippet = PhotoData(photo:image)
    self.data.append(newPhotoSnippet)
    dismiss(animated:true,completion:nil)
    }
}

