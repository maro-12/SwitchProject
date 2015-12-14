//
//  ViewController.swift
//  apiTest
//
//  Created by Naoya Kurahashi on 2015/12/03.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController , UITextFieldDelegate {
    let localdata = NSUserDefaults.standardUserDefaults()
    var token:String?
    var getStatus:Int?
    var postStatus:Int?

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
        
        textDesign(screen_name)
        textDesign(email)
        textDesign(confirmation)
        textDesign(password)
        
        buttonDesign(signUpButton)
        buttonDesign(loginViewButton)
        
        getAuthToken()
        
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
    
    @IBAction func login(sender: UIButton) {
        if(self.screen_name == nil || self.email == nil || self.confirmation == nil || self.password == nil){
            sender.enabled = false
        }
        
        let interim_auth_token:String = self.localdata.objectForKey("Interim_auth_token") as! String
        postSingUp()
    }
    
    func textFieldShouldReturn(screen_name: UITextField) -> Bool{
        screen_name.resignFirstResponder()
        return true
    }
    
    func getAuthToken(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        Alamofire.request(.GET,"\(urlHead):80/api/v1/auth/token.json").response{(request , response , data , error) in
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    if let status = meta["status"] as? Int{
                        self.getStatus = status
                    }
                }
                if let response = obj!["response"] as? [String : AnyObject]{
                    if let auth_token = response["auth_token"] as? String{
                        self.token = auth_token
                    }
                }
                if(self.getStatus! != 200){
                    print("auth_token取得失敗")
                }
            }catch{
                print("Errorrrr")
            }
        }
    }
    
    func postSingUp(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        Alamofire.request(.POST , "\(urlHead):80/api/v1/auth/signup.json" , 
                        parameters:["screen_name":"\(self.screen_name.text!)",
                                    "email"      :"\(self.email.text!)",
                                    "password"   :"\(self.password.text!)",
                                    "auth_token" :"\(self.token!)"] ).response{(request , response , data , error) in
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    if let status = meta["status"] as? Int{
                        print(status)
                        self.postStatus = status
                    }
                    if let message = meta["message"] as? String{
                        print(message)
                    }
                }
                if(self.postStatus! == 201){
                    self.localdata.setObject(self.token , forKey:"auth_token")
                    self.localdata.setObject(self.screen_name.text! , forKey:"userName")
                    self.localdata.synchronize()
                    self.performSegueWithIdentifier("homeViewSegue", sender: self)
                }

            }catch{
                print("Error")
            }

        }
    }

}

