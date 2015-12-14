//
//  AddViewController.swift
//  SwitchProject
//
//  Created by Naoya Kurahashi on 2015/12/14.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit

class AddViewController: UIViewController ,UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        groupName.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var groupName: UITextField!
    @IBAction func groupAdd(sender: UIButton) {
        newGroupAdd()
    }
    let localdata = NSUserDefaults.standardUserDefaults()
    

    func inputAlert() {
        // var inputTextField: UITextField?
//        var passwordField: UITextField?
        let name = self.groupName.text!
        let alertController: UIAlertController = UIAlertController(title: "グループを作成しました", message: "group name is \(name)", preferredStyle: .Alert)
        
        // let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
        //     print("Cancel")
        // }
        // alertController.addAction(cancelAction)
        
        let doneAction: UIAlertAction = UIAlertAction(title: "Done", style: .Default) { action -> Void in
            print("Done")
            // print(inputTextField?.text)
//            print(passwordField?.text)
        }
        alertController.addAction(doneAction)
        
        // alertController.addTextFieldWithConfigurationHandler { textField -> Void in
        //     inputTextField = textField
        //     textField.placeholder = "赤外線の名前"
        // }
        // alertController.addTextFieldWithConfigurationHandler{textField -> Void in
        //     inputTextField = textField
        //     textField.placeholder = "グループID(任意)"
        // }
//        alertController.addTextFieldWithConfigurationHandler { textField -> Void in
//            passwordField = textField
//            textField.secureTextEntry = true
//            textField.placeholder = "password"
//        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func newGroupAdd(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        // apiで取得するためのURLを指定
        let auth_token = String(self.localdata.objectForKey("auth_token")!)
        let URL = NSURL(string: "\(urlHead):80/api/v1/group.json")
        let req = NSMutableURLRequest(URL:URL!)
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        let name = self.groupName.text!
        
        req.HTTPMethod = "POST"
        req.HTTPBody = "auth_token=\(auth_token)&name=\(name)".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, response, error) -> Void in
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
                
                let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
                
                if String(res["status"]!) == "201"{
                    self.inputAlert()
                }else{
                    print("作成できませんでした")
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
