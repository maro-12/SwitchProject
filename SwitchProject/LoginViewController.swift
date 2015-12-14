//
//  LoginViewController.swift
//  apiTest
//
//  Created by Naoya Kurahashi on 2015/12/07.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController , UITextFieldDelegate {
    
    let localdata = NSUserDefaults.standardUserDefaults()
    var loginStatus:Int?
    var auth_token:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        user_name.delegate = self
        user_passwd.delegate = self
        user_passwd.secureTextEntry = true

        textDesign(user_name)
        textDesign(user_passwd)

        buttonDesign(loginButton)
        buttonDesign(newAccountButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var user_name: UITextField!
    @IBOutlet weak var user_passwd: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var newAccountButton: UIButton!
    
    @IBAction func login(sender: UIButton) {
        if(self.user_name == nil || self.user_passwd == nil){
            sender.enabled = false
        }
        postLogin()
        //        self.performSegueWithIdentifier("homeViewSegue", sender: self)
    }

    func buttonDesign(button : UIButton){
        let borderWidth :CGFloat = 1.0
        button.backgroundColor = UIColor.mcOrange500()
        // button.layer.borderColor = UIColor.mcOrange500().CGColor
        // button.layer.borderWidth = borderWidth
        button.layer.cornerRadius = 9
        // button.layer.shadowOpacity = 0.4
        // button.layer.shadowOffset = CGSizeMake(3.0 , 3.0)
     }

    func textDesign(textField :UITextField!){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.mcGrey200().CGColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

//     func postData(){
//         let urlHead:String = self.localdata.objectForKey("siteURL") as! String
//         // apiで取得するためのURLを指定
//         let URL = NSURL(string: "\(urlHead):80/api/v1/auth/login.json")
//         let req = NSMutableURLRequest(URL:URL!)
        
        
//         let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//         let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
        
//         req.HTTPMethod = "POST"
//         req.HTTPBody = "email_or_screen_name=\(self.user_name.text!)&password=\(self.user_passwd.text!)".dataUsingEncoding(NSUTF8StringEncoding)
        
// //        print(self.user_name.text!)
// //        print(self.user_passwd.text!)
// //        
//         let task = session.dataTaskWithRequest(req, completionHandler: {
//             (data, response, error) -> Void in
//             do{
//                 let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
                
//                 let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
//                 let resResponse:NSDictionary = json.objectForKey("response") as! NSDictionary
                
// //                print(String(res["status"]!))
//                 if String(res["status"]!) == "201"{
//                     self.localdata.setObject(String(resResponse["auth_token"]!) , forKey: "auth_token")
//                     self.localdata.synchronize()
//                     self.performSegueWithIdentifier("loginHomeSegue", sender: self)
//                 }else{
//                     print("Loginできませんでした")
//                 }
//                 //                print(String(res["status"]!))
//                 //                self.localdata.setObject(res["status"] , forKey: "status")
//                 //                self.localdata.synchronize()
//                 //              msg = res["message"] as! String
//                 //              print(msg)
                
//             }catch{
// //                self.performSegueWithIdentifier("errorSegue", sender: self)
//                 print("Error")
//             }
            
//         })
        
//         task.resume()
//     }

    func postLogin(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        print(self.user_name.text!)
        print(self.user_passwd.text!)
        Alamofire.request(.POST , "\(urlHead):80/api/v1/auth/login.json" ,
                parameters:["email_or_screen_name":"\(self.user_name.text!)",
                           "password"             :"\(self.user_passwd.text!)" ]).response{(requset , response , data , error) in 
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String:AnyObject]{
                    if let status = meta["status"] as? Int{
                        print(status)
                        self.loginStatus = status
                    }
                }
                if let response = obj!["response"] as? [String:AnyObject]{
                    print("fuga")
                    if let token = response["auth_token"] as? String{
                        print("fugaaaa")
                        self.auth_token = token
                    }
                }
                if(self.loginStatus! == 201){
                    print("gaga")
                    self.localdata.setObject(self.auth_token! , forKey:"auth_token")
                    self.localdata.synchronize()
                    self.performSegueWithIdentifier("loginHomeSegue", sender: self)
                }
            }catch{
                print("Loginできませんでした")
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
