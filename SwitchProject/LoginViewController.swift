//
//  LoginViewController.swift
//  apiTest
//
//  Created by Naoya Kurahashi on 2015/12/07.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate {
    
    let localdata = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

        user_name.delegate = self
        user_passwd.delegate = self
        user_passwd.secureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var user_name: UITextField!
    @IBOutlet weak var user_passwd: UITextField!
    
    
    @IBAction func login(sender: UIButton) {
        
        postData()
        //        self.performSegueWithIdentifier("homeViewSegue", sender: self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

    
//    func getData(){
//        let URL = NSURL(string: "http://b917fc44.ngrok.io:80/api/v1/auth/login.json")
//        let req = NSMutableURLRequest(URL:URL!)
//        
//        
//        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
//        
//        let task = session.dataTaskWithRequest(req ,completionHandler:{
//            (data , response, error) -> Void in
//            do{
//                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
//                
//                let resMeta:NSDictionary = json.objectForKey("meta") as! NSDictionary
//                let resResponse:NSDictionary = json.objectForKey("response") as! NSDictionary
//                
//                //                let auth_token:String = String(resResponse["auth_token"]!)
//                
//                if String(resMeta["status"]!) == "200"{
//                    self.localdata.setObject(resResponse["auth_token"]! , forKey:"Interim_auth_token")
//                    self.localdata.synchronize()
//                }else{
//                    print("auth_token取得失敗")
//                }
//                
//            }catch{
//                
//            }
//        })
//        task.resume()
//    }
    
    func postData(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        // apiで取得するためのURLを指定
        let URL = NSURL(string: "\(urlHead):80/api/v1/auth/login.json")
        let req = NSMutableURLRequest(URL:URL!)
        
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
        
        req.HTTPMethod = "POST"
        req.HTTPBody = "email_or_screen_name=\(self.user_name.text!)&password=\(self.user_passwd.text!)".dataUsingEncoding(NSUTF8StringEncoding)
        
//        print(self.user_name.text!)
//        print(self.user_passwd.text!)
//        
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, response, error) -> Void in
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
                
                let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
//                let resResponse:NSDictionary = json.objectForKey("response") as! NSDictionary
                
//                print(String(res["status"]!))
                
                if String(res["status"]!) == "201"{
//                    self.localdata.setObject(String(resResponse["auth_token"]!) , forKey: "auth_token")
//                    self.localdata.synchronize()
                    self.performSegueWithIdentifier("loginHomeSegue", sender: self)
                }else{
                    print("Loginできませんでした")
                }
                //                print(String(res["status"]!))
                //                self.localdata.setObject(res["status"] , forKey: "status")
                //                self.localdata.synchronize()
                //              msg = res["message"] as! String
                //              print(msg)
                
            }catch{
//                self.performSegueWithIdentifier("errorSegue", sender: self)
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
