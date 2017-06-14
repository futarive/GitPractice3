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
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
       }
    override func viewWillAppear(_ animated:Bool) {
        tableView.reloadData()
       }

    @IBAction func creatNewSnippet(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "请选择创建项目类型",message:nil,preferredStyle:.actionSheet)
        
        let textAction =  UIAlertAction(title:"文本",style:.default) {
            (alert:UIAlertAction!)->Void in self.creatNewTextSnippet()
        }
        
        let photoAction =  UIAlertAction(title:"图像",style:.default) {
            (alert:UIAlertAction!)->Void in self.creatNewPhotoSnippet()
        }
        
        let cancelAction = UIAlertAction(title:"取消",style:.cancel,handler:nil)
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
        let newTextSnippet = TextData(text:text,creationDate:Date())
        
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
    
    func imagePickerController(_ picker:UIImagePickerController,didFinishPickingMediaWithInfo info: [String:Any]) {
        guard let image = info [UIImagePickerControllerEditedImage] as? UIImage else {
            print("Image could not be found")
            return
        }
        let newPhotoSnippet = PhotoData(photo:image,creationDate:Date())
        
    self.data.append(newPhotoSnippet)
        
    dismiss(animated:true,completion:nil)
    }
}

extension ViewController:UITableViewDataSource {
    
    func numberOfSections(in tableView:UITableView) ->Int {
        return 1
        }
    func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int) ->Int{
       return data.count
    }
    
    func tableView(_ tableView:UITableView,cellForRowAt indexPath:IndexPath) ->UITableViewCell {
        let cell:UITableViewCell
        
        let sortedData = data.reversed() as [SnippetData]
        let snippetData = sortedData[indexPath.row]
        
        let formatter =  DateFormatter()
        formatter.dateFormat = "MMM d,yyy hh:mm a"
        let dateString = formatter.string(from: snippetData.date)
        
        switch snippetData.type {
        case .text:
            cell = tableView.dequeueReusableCell(withIdentifier:"textSnippetCell",for:indexPath)
            (cell as! TextSnippetCell).label.text = (snippetData as! TextData).textData
            (cell as! TextSnippetCell).date.text = dateString
        case .photo:
            cell = tableView.dequeueReusableCell(withIdentifier: "photoSnippetCell",for:indexPath)
            (cell as! PhotoSnippetCell).photo.image = (snippetData as! PhotoData).photoData
            (cell as! PhotoSnippetCell).date.text = dateString
        }
        return cell
    }
}
