//
//  NewInfraredViewController.swift
//  apiTest
//
//  Created by Naoya Kurahashi on 2015/12/10.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import Alamofire

class NewInfraredViewController: UIViewController , UITextFieldDelegate {

//    var nameTextField = UITextField(frame:CGRectMake(0,0,200,40))
//    nameTextField.text = "ここに名前を入力してね"
//    nameTextField.delegate = self
//    nameTextField.borderStyle = UITextBorderStyle.RoundedRect
//    
    let localdata = NSUserDefaults.standardUserDefaults()
    var timer:NSTimer!
    var irName:String?
    var groupID:Int?
    var ir_id:Int?
    var newIrName:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.12, target: self, selector: "update", userInfo: nil, repeats: true)
        
        postInfrared()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeBar: MBCircularProgressBarView!
    
    func update(){
        if(timeBar.value > 0.08){
            timeBar.value += -0.08
        }else{
            timeBar.value = 0
            timer.invalidate()
            timeBar.emptyLineColor = UIColor.mcOrange200()
            messageLabel.text = "取得できませんでした"
        }
    }
    
    func inputAlert() {
        var infraredNameTextField: UITextField?
        var new_Ir_name:String?
//        var groupNameTextField: UITextField?

        let alertController: UIAlertController = UIAlertController(title: "名前をつけてね", message: "Input infrared name", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { textField -> Void in
            infraredNameTextField = textField
            textField.placeholder = "赤外線の名前"
        }
//        alertController.addTextFieldWithConfigurationHandler{textField -> Void in
//            groupNamrTextField = textField
//            textField.placeholder = "グループID(任意)"
//        }       

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
        }
        let logintAction: UIAlertAction = UIAlertAction(title: "Done", style: .Default) { action ->  Void in
            new_Ir_name = infraredNameTextField!.text
            self.putInfraredRename(new_Ir_name!)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(logintAction)
        
 
        presentViewController(alertController, animated: true, completion: nil)
    }

    func successAlert(){
        let successAlertController: UIAlertController = UIAlertController(title: "Success!!", message: "New infrared name is \(self.newIrName!)", preferredStyle: .Alert)
    
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
        }
        successAlertController.addAction(okAction)

        presentViewController(successAlertController, animated: true, completion: nil)
    }

    func failedAlert(){
        let failedAlertController: UIAlertController = UIAlertController(title: "Error", message: "Infrared rename is failed..", preferredStyle: .Alert)
    
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
        }
        failedAlertController.addAction(okAction)

        presentViewController(failedAlertController, animated: true, completion: nil)
    }
    
    // func postInfraredData(){
    //     let urlHead:String = self.localdata.objectForKey("siteURL") as! String
    //     // apiで取得するためのURLを指定
    //     let auth_token = String(self.localdata.objectForKey("auth_token")!)
    //     let URL = NSURL(string: "\(urlHead):80/api/v1/ir/receive.json")
    //     let req = NSMutableURLRequest(URL:URL!)
        
        
    //     let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    //     let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
        
    //     req.HTTPMethod = "POST"
    //     req.HTTPBody = "auth_token=\(auth_token)".dataUsingEncoding(NSUTF8StringEncoding)
        
    //     let task = session.dataTaskWithRequest(req, completionHandler: {
    //         (data, response, error) -> Void in
    //         do{
    //             let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
                
    //             let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
    //             let resResponse:NSDictionary = json.objectForKey("response") as! NSDictionary
    //             let infrared:NSDictionary = resResponse.objectForKey("infrared") as! NSDictionary
    //             if String(res["status"]!) == "201"{
    //                 self.messageLabel.text = "成功！名前をつけてください！"
    //                 self.ir_id = infrared["id"] as? Int
    //                 self.inputAlert()
    //             }else{
    //                 print("取得できませんでした")
    //             }
    //         }catch{
    //             print("Error")
    //         }
            
    //     })
    //     print(ir_id)
    //     task.resume()
    // }

    func postInfrared(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token = String(self.localdata.objectForKey("auth_token")!)
        var getStatus:Int?
        var interimID:Int?

        Alamofire.request(.POST , "\(urlHead):80/api/v1/ir/receive.json" ,
                        parameters:["auth_token":"\(auth_token)"]).response{(request , response , data , error) in 
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    if let status = meta["status"] as? Int{
                        getStatus = status
                    }
                }
                if let response = obj!["response"] as? [String:AnyObject]{
                    if let infrared = response["infrared"] as? [String:AnyObject]{
                        if let id = infrared["id"] as? Int{
                            interimID = id
                        }
                    }
                }
                if(getStatus! == 201){
                    self.messageLabel.text = "成功！名前をつけてください！"
                    self.ir_id = interimID
                    self.timer.invalidate()
                    self.inputAlert()
                }else{
                    print("取得できませんでした")
                }
            }catch{
                print("Error")
            }
        }
    }   

//     func putInfraredData(irName:String){
//         let urlHead:String = self.localdata.objectForKey("siteURL") as! String
//         // apiで取得するためのURLを指定
//         let auth_token = String(self.localdata.objectForKey("auth_token")!)
//         let URL = NSURL(string: "\(urlHead):80/api/v1/ir/rename.json")
//         let req = NSMutableURLRequest(URL:URL!)
//         let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//         let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
// //        let name:String = self.irName
        
//         req.HTTPMethod = "PUT"
//         req.HTTPBody = "auth_token=\(auth_token)&name=\(irName)&ir_id\(ir_id)".dataUsingEncoding(NSUTF8StringEncoding)
// //        req.setValue(auth_token, forHTTPHeaderField: "auth_token")
// //        req.setValue(irName, forHTTPHeaderField: "name")
// //        req.setValue(ir_id, forHTTPHeaderField:"ir_id")

//         let task = session.dataTaskWithRequest(req, completionHandler: {
//             (data, response, error) -> Void in
//             do{
//                 let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
//                 let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
// //                let resResponse:NSDictionary = json.objectForKey("response") as! NSDictionary
// //                let infrared:NSDictionary = resResponse.objectForKey("infrared") as! NSDictionary

//                 if String(res["status"]!) == "201"{
// //                    let name:String = infrared["name"] as! String
//                     self.messageLabel.text = "成功！名前は\(irName)です"
//                     // self.inputAlert()
//                 }else{
//                     print("取得できませんでした")
//                 }
//             }catch{
//                 print("Error")
//             }
            
//         })
        
//         task.resume()
//     }

    func putInfraredRename(infrared_name:String?){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token = String(self.localdata.objectForKey("auth_token")!)
        var getStatus:Int?
        self.newIrName = infrared_name
        Alamofire.request(.PUT , "\(urlHead):80/api/v1/ir/rename.json" , 
                        parameters:["auth_token":"\(auth_token)" ,
                                    "name"      :"\(infrared_name!)",
                                    "ir_id"     :"\(self.ir_id!)"
                                    ]).response{(request , response , data , error ) in
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String:AnyObject]{
                    print("fuga")
                    if let status = meta["status"] as? Int{
                        getStatus = status
                    }
//                    if let message = meta["message"] as? String{
//                        // print(message)
//                    }
                }
                if(getStatus! == 200){
                    print("りねいむ完了")
                    self.successAlert()
                }else{
                    print("りねいむ失敗")
                    self.failedAlert()
                }
            }catch{
                print("Error putInfraredRename")
            }
        }
    }    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
