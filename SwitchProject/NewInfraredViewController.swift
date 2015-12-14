//
//  NewInfraredViewController.swift
//  apiTest
//
//  Created by Naoya Kurahashi on 2015/12/10.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class NewInfraredViewController: UIViewController , UITextFieldDelegate {

//    var nameTextField = UITextField(frame:CGRectMake(0,0,200,40))
//    nameTextField.text = "ここに名前を入力してね"
//    nameTextField.delegate = self
//    nameTextField.borderStyle = UITextBorderStyle.RoundedRect
//    
    let localdata = NSUserDefaults.standardUserDefaults()
    var timer : NSTimer!
    var irName:String?
    var ir_id:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.13, target: self, selector: "update", userInfo: nil, repeats: true)
        
        postInfraredData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeBar: MBCircularProgressBarView!
    
    func update(){
        if(timeBar.value < 100){
            timeBar.value++
        }else{
            timer.invalidate()
            timeBar.value = 0
            timeBar.emptyLineColor = UIColor.redColor()
            messageLabel.text = "取得できませんでした"
        }
    }
    
    func inputAlert() {
        var inputTextField: UITextField?
//        var passwordField: UITextField?
        
        let alertController: UIAlertController = UIAlertController(title: "名前をつけてね", message: "Input infrared name", preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            print("Cancel")
        }
        alertController.addAction(cancelAction)
        
        let logintAction: UIAlertAction = UIAlertAction(title: "Done", style: .Default) { action -> Void in
//            print("Done")
//            print(inputTextField?.text)
//            print(passwordField?.text)
            self.putInfraredData(self.irName!)
        }
        alertController.addAction(logintAction)
        
        alertController.addTextFieldWithConfigurationHandler { textField -> Void in
            inputTextField = textField
            textField.placeholder = "赤外線の名前"
            self.irName = inputTextField!.text
        }
        alertController.addTextFieldWithConfigurationHandler{textField -> Void in
            inputTextField = textField
            textField.placeholder = "グループID(任意)"
        }
//        alertController.addTextFieldWithConfigurationHandler { textField -> Void in
//            passwordField = textField
//            textField.secureTextEntry = true
//            textField.placeholder = "password"
//        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func postInfraredData(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        // apiで取得するためのURLを指定
        let auth_token = String(self.localdata.objectForKey("auth_token")!)
        let URL = NSURL(string: "\(urlHead):80/api/v1/ir/receive.json")
        let req = NSMutableURLRequest(URL:URL!)
        
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
        
        req.HTTPMethod = "POST"
        req.HTTPBody = "auth_token=\(auth_token)".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, response, error) -> Void in
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
                
                let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
                let resResponse:NSDictionary = json.objectForKey("response") as! NSDictionary
                let infrared:NSDictionary = resResponse.objectForKey("infrared") as! NSDictionary
                if String(res["status"]!) == "201"{
                    self.messageLabel.text = "成功！名前をつけてください！"
                    self.ir_id = infrared["id"] as? Int
                    self.inputAlert()
                }else{
                    print("取得できませんでした")
                }
            }catch{
                print("Error")
            }
            
        })
        print(ir_id)
        task.resume()
    }

    func putInfraredData(irName:String){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        // apiで取得するためのURLを指定
        let auth_token = String(self.localdata.objectForKey("auth_token")!)
        let URL = NSURL(string: "\(urlHead):80/api/v1/ir/rename.json")
        let req = NSMutableURLRequest(URL:URL!)
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
//        let name:String = self.irName
        
        req.HTTPMethod = "PUT"
        req.HTTPBody = "auth_token=\(auth_token)&name=\(irName)&ir_id\(ir_id)".dataUsingEncoding(NSUTF8StringEncoding)
//        req.setValue(auth_token, forHTTPHeaderField: "auth_token")
//        req.setValue(irName, forHTTPHeaderField: "name")
//        req.setValue(ir_id, forHTTPHeaderField:"ir_id")

        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, response, error) -> Void in
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
                let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
//                let resResponse:NSDictionary = json.objectForKey("response") as! NSDictionary
//                let infrared:NSDictionary = resResponse.objectForKey("infrared") as! NSDictionary

                if String(res["status"]!) == "201"{
//                    let name:String = infrared["name"] as! String
                    self.messageLabel.text = "成功！名前は\(irName)です"
                    // self.inputAlert()
                }else{
                    print("取得できませんでした")
                }
            }catch{
                print("Error")
            }
            
        })
        
        task.resume()
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
