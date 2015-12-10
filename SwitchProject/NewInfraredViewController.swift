//
//  NewInfraredViewController.swift
//  apiTest
//
//  Created by Naoya Kurahashi on 2015/12/10.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit

class NewInfraredViewController: UIViewController , UITextFieldDelegate {

//    var nameTextField = UITextField(frame:CGRectMake(0,0,200,40))
//    nameTextField.text = "ここに名前を入力してね"
//    nameTextField.delegate = self
//    nameTextField.borderStyle = UITextBorderStyle.RoundedRect
//    
    let localdata = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postInfraredData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var messageLabel: UILabel!
    
    
    func inputAlert() {
        var inputTextField: UITextField?
//        var passwordField: UITextField?
        
        let alertController: UIAlertController = UIAlertController(title: "名前をつけてね", message: "Input infrared name", preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            print("Cancel")
        }
        alertController.addAction(cancelAction)
        
        let logintAction: UIAlertAction = UIAlertAction(title: "Done", style: .Default) { action -> Void in
            print("Done")
            print(inputTextField?.text)
//            print(passwordField?.text)
        }
        alertController.addAction(logintAction)
        
        alertController.addTextFieldWithConfigurationHandler { textField -> Void in
            inputTextField = textField
            textField.placeholder = "赤外線の名前"
        }
        alertController.addTextFieldWithConfigurationHandler{textField -> Void in
            inputTextField = textField
            textField.placeholder = "グループID"
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
        let URL = NSURL(string: "\(urlHead):80/api/v1/ir/recieve.json")
        let req = NSMutableURLRequest(URL:URL!)
        
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
        
        req.HTTPMethod = "POST"
        req.HTTPBody = "auth_token=dQNRj_AzUjTtKqOm8FN9kA".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, response, error) -> Void in
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
                
                let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
                
                if String(res["status"]!) == "201"{
                    self.messageLabel.text = "成功！名前をつけてください！"
                    self.inputAlert()
                }else{
                    print("Loginできませんでした")
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
