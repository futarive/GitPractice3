//
//  ViewController.swift
//  Snippets
//
//  Created by 王家永 on 2017/6/8.
//  Copyright © 2017年 王家永. All rights reserved.
//

import UIKit
import CoreLocation
import Social
import CoreData

class ViewController: UIViewController {

    var data = [NSManagedObject] ()
    let imagePicker = UIImagePickerController()
    let locationManager = CLLocationManager()
    var currentCoordinate:CLLocationCoordinate2D?
    
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.distanceFilter = 50.0
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        askForLocationPermissions()
          }
    
    override func viewWillAppear(_ animated:Bool) {
        reloadSnippetData()
        tableView.reloadData()
       }
    
    func reloadSnippetData() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = delegate.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Snippet")
        let sortDescriptor = NSSortDescriptor(key:"date",ascending:false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchResults = try managedContext.fetch(request)
            self.data = fetchResults as! [NSManagedObject]
        } catch {
            let e = error as NSError
            print("Unresolved error \(e),\(e.userInfo)")
        }
    }
    
    func askForLocationPermissions(){
        if CLLocationManager.authorizationStatus() == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
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
        self.saveTextSnippet(text: text)        }
    
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
    
    func saveTextSnippet(text:String) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = delegate.managedObjectContext
        let desc = NSEntityDescription.entity(forEntityName: "TextSnippet",in: managedContext)
        let textSnippet = NSManagedObject(entity:desc!,insertInto:managedContext)
        textSnippet.setValue(SnippetType.text.rawValue,forKey:"type")
        textSnippet.setValue(text,forKey:"text")
        textSnippet.setValue(NSDate(),forKey: "date")
        if let coord = self.currentCoordinate{
            textSnippet.setValue(coord.latitude,forKey:"latitude")
            textSnippet.setValue(coord.longitude,forKey:"longitude")
          }
        delegate.saveContext()
    }
    
    func savePhotoSnippet(photo:UIImage) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = delegate.managedObjectContext
        let desc = NSEntityDescription.entity(forEntityName: "PhotoSnippet",in:managedContext)
        let photoSnippet = NSManagedObject(entity:desc!,insertInto:managedContext)
        let photoData = UIImagePNGRepresentation(photo)
        photoSnippet.setValue(SnippetType.photo.rawValue,forKey:"type")
        photoSnippet.setValue(photoData,forKey:"photo")
        photoSnippet.setValue(Date(),forKey:"date")
        if let coord = self.currentCoordinate{
            photoSnippet.setValue(coord.latitude,forKey:"latitude")
            photoSnippet.setValue(coord.longitude,forKey:"longitude")
        }
        delegate.saveContext()
    }
    
}

extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker:UIImagePickerController,didFinishPickingMediaWithInfo info: [String:Any]) {
        guard let image = info [UIImagePickerControllerEditedImage] as? UIImage else {
            print("Image could not be found")
            return
        }
        savePhotoSnippet(photo:image)
        
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
    
    func tableView(_ tableView:UITableView,commit editingStyle:UITableViewCellEditingStyle,forRowAt indexPath: IndexPath) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = delegate.managedObjectContext
        
        let currentObject = data[indexPath.row]
        managedContext.delete(currentObject)
        delegate.saveContext()
        reloadSnippetData()
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView:UITableView,cellForRowAt indexPath:IndexPath) ->UITableViewCell {
        let cell:UITableViewCell
        
        let snippetData = data[indexPath.row]
        let snippetDate = snippetData.value(forKey:"date") as! Date
        let snippetType = SnippetType(rawValue:snippetData.value(forKey:"type") as! String)!
        
        let formatter =  DateFormatter()
        formatter.dateFormat = "MMM d,yyy hh:mm a"
        let dateString = formatter.string(from: snippetDate)
        
        switch snippetType {
        case .text:
            let snippetText = snippetData.value(forKey:"text") as! String
            cell = tableView.dequeueReusableCell(withIdentifier:"textSnippetCell",for:indexPath) as! TextSnippetCell
            
            (cell as! TextSnippetCell).label.text = snippetText
            (cell as! TextSnippetCell).date.text = dateString
            (cell as! TextSnippetCell).shareButton = {
                if SLComposeViewController.isAvailable(forServiceType:SLServiceTypeSinaWeibo) {
                    let text = snippetText
                    guard let twVC = SLComposeViewController(forServiceType:SLServiceTypeSinaWeibo)
                           else {
                        print("Couldn't create weibo compose controller")
                           return
                                }
                    if text.characters.count <= 140 {
                       twVC.setInitialText("\(text)")
                        } else {
                          let weiboLengthIndex = text.index(text.startIndex,offsetBy:140)
                          let weiboChars = text.substring(to: weiboLengthIndex)
                          twVC.setInitialText("\(weiboChars)")
                        }
                          self.present(twVC,animated:true,completion:nil)
                     }
                else {
                    let alert = UIAlertController(title:"You are not logged into weixin",message:"Please log into weixin from the ios settings app.",preferredStyle:.alert)
                    let dismissAction = UIAlertAction(title:"OK",style:.default,handler:nil)
                    alert.addAction(dismissAction)
                    self.present(alert,animated: true,completion:nil)
                     }
            }
        case .photo:
            let snippetPhoto = UIImage(data:snippetData.value(forKey:"photo") as! Data )
            cell = tableView.dequeueReusableCell(withIdentifier: "photoSnippetCell",for:indexPath)
            
            (cell as! PhotoSnippetCell).photo.image = snippetPhoto
            (cell as! PhotoSnippetCell).date.text = dateString
            (cell as! PhotoSnippetCell).shareButton = {
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeSinaWeibo) {
                    let photo = snippetPhoto
                    guard let twVC = SLComposeViewController(forServiceType:SLServiceTypeSinaWeibo)
                        else {
                            print("Couldn't create weibo compose controller")
                            return
                    }
                    twVC.setInitialText("sent from SnippetsTM")
                    twVC.add(photo)
                    self.present(twVC,animated: true,completion:nil)
                }
                else{
                    let alert = UIAlertController(title:"You are not logged into weixin",message:"Please log into weixin from the ios settings app.",preferredStyle:.alert)
                    let dismissAction = UIAlertAction(title:"OK",style:.default,handler:nil)
                    alert.addAction(dismissAction)
                    self.present(alert,animated: true,completion:nil)
                }
            }
        }
        return cell
    }
}
extension ViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager:CLLocationManager,didChangeAuthorization status:CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
               }
          }
    func locationManager(_ manager:CLLocationManager,didFailWithError error:Error) {
        print("Location manager could not get location. Error:\(error.localizedDescription)")
    }
    
    func locationManger(_ manager:CLLocationManager,didUpdateLocation locations:[CLLocation]) {
        if let currentLocation = locations.last {
            currentCoordinate = currentLocation.coordinate
            print("\(currentCoordinate!.latitude),\(currentCoordinate!.longitude)")
        }
    }
}
