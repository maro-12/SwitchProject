//
//  ViewController.swift
//  apiTest
//
//  Created by Naoya Kurahashi on 2015/12/03.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController , UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        screen_name.delegate = self
        screen_name.placeholder = "name"
        email.delegate = self
        email.placeholder = "polunga.example@gmail.com"
        confirmation.delegate = self
        confirmation.placeholder = "polunga.example@gmail.com"
        password.delegate = self
        password.secureTextEntry = true
        password.placeholder = "password"
        
//        UIGraphicsBeginImageContext(frontView.frame.size);
//        [[UIImage imageNamed:"backgroundImg.png"] drawInRect:self.view.bounds];
//        var backgroundImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
////        self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
//        let backgroundImage = UIImage(named: "backgroundImg")!
//        let myImageView = UIImageView()
//        myImageView.image = backgroundImage
//        myImageView.frame = CGRectMake(0, 0, frontView.frame.width, frontView.frame.height)
//        myScrollView.addSubview(myImageView)
//        myScrollView.contentSize = CGSizeMake(myImageView.frame.size.width, myImageView.frame.size.height)
//        frontView.backgroundColor = UIColor(patternImage: backgroundImage)
        textDesign(screen_name)
        textDesign(email)
        textDesign(confirmation)
        textDesign(password)
        
        buttonDesign(signUpButton)
        buttonDesign(loginViewButton)
        

        
        getData()
        
    }

    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginViewButton: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var screen_name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmation: UITextField!
    @IBOutlet weak var errorMessage: UITextView!
    
    func buttonDesign(button : UIButton){
        let borderWidth :CGFloat = 1.0
        button.backgroundColor = UIColor.mcOrange500()
        // button.layer.borderColor = UIColor.mcOrange500().CGColor
        // button.layer.borderWidth = borderWidth
        button.layer.cornerRadius = 5
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
    
    let localdata = NSUserDefaults.standardUserDefaults()
    
    
    @IBAction func login(sender: UIButton) {
//        print(self.screen_name.text!)
//        print(self.email.text!)
//        print(self.password.text!)
        if(self.screen_name == nil || self.email == nil || self.confirmation == nil || self.password == nil){
            sender.enabled = false
        }
        
        let interim_auth_token:String = self.localdata.objectForKey("Interim_auth_token") as! String
        postData(interim_auth_token)
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
    
    func postData(token : String){
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

