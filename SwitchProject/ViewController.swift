//
//  ViewController.swift
//  apiTest
//
//  Created by Naoya Kurahashi on 2015/12/03.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        screen_name.delegate = self
        email.delegate = self
        confirmation.delegate = self
        password.delegate = self
        password.secureTextEntry = true
        
        getData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var screen_name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmation: UITextField!
    @IBOutlet weak var errorMessage: UITextView!
    
    
    let localdata = NSUserDefaults.standardUserDefaults()
    
    
    @IBAction func login(sender: UIButton) {
        print(self.screen_name.text!)
        print(self.email.text!)
        print(self.password.text!)
        
        let interim_auth_token:String = self.localdata.objectForKey("Interim_auth_token") as! String
        post1Data(interim_auth_token)
//      print(self.localdata.objectForKey("auth"))

    }
    //    func textField(screen_name: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//
//        let str = screen_name.text
//
//        if 0 < str?.characters.count {
//            return true
//        }
//        print("入力がありません")
//        return false
//    }
    
    func textFieldShouldReturn(screen_name: UITextField) -> Bool{
        screen_name.resignFirstResponder()
        return true
    }
    
    func getData(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        
        let URL = NSURL(string: "\(urlHead):80/api/v1/auth/token.json")
        let req = NSMutableURLRequest(URL:URL!)
        
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
        let task = session.dataTaskWithRequest(req ,completionHandler:{
            (data , response, error) -> Void in
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
                
                let resMeta:NSDictionary = json.objectForKey("meta") as! NSDictionary
                let resResponse:NSDictionary = json.objectForKey("response") as! NSDictionary
                
//                let auth_token:String = String(resResponse["auth_token"]!)
                
                if String(resMeta["status"]!) == "200"{
                    self.localdata.setObject(resResponse["auth_token"]! , forKey:"Interim_auth_token")
                    self.localdata.synchronize()
                }else{
                    print("auth_token取得失敗")
                }
                
            }catch{
                
            }
        })
        task.resume()
    }
    
    func post1Data(token : String){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        // apiで取得するためのURLを指定
        let URL = NSURL(string: "\(urlHead):80/api/v1/auth/signup.json")
        let req = NSMutableURLRequest(URL:URL!)
        
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())

        
        req.HTTPMethod = "POST"
        req.HTTPBody = "screen_name=\(self.screen_name.text!)&email=\(self.email.text!)&password=\(self.password.text!)&auth_token=\(token)".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, response, error) -> Void in
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
                
                let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
//                let err:NSDictionary = json.objectForKey("response") as! NSDictionary
                
                if String(res["status"]!) == "201"{
                    self.localdata.setObject(token , forKey: "auth_token")
                    self.localdata.synchronize()
                    self.performSegueWithIdentifier("homeViewSegue", sender: self)
                    print("hoge")
                }else{
                    print("sign upできませんでした")
                }
//                print(String(res["status"]!))
//                self.localdata.setObject(res["status"] , forKey: "status")
//                self.localdata.synchronize()
//              msg = res["message"] as! String
//              print(msg)

            }catch{
               self.performSegueWithIdentifier("errorSegue", sender: self)
            }
            
        })
        
        task.resume()
    }

}

