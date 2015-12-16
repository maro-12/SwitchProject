//
//  UserInfoViewController.swift
//  SwitchProject
//
//  Created by Naoya Kurahashi on 2015/12/15.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit
import Alamofire

class UserInfoViewController: UIViewController {
    let localdata = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        userName.enabled = false
        textDesign(userName)
        userEmail.enabled = false
        textDesign(userEmail)
        buttonDesign(logoutButton)
        getUserInfo()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var logoutButton: UIButton!

    @IBAction func LogoutButton(sender: UIButton) {
        delete_Logout()
    }
    
    func buttonDesign(button : UIButton){
//        let borderWidth :CGFloat = 1.0
        button.backgroundColor = UIColor.mcOrange300()
        button.layer.cornerRadius = 9
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(1.0 , 3.0)
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
    
    func getUserInfo(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token = String(self.localdata.objectForKey("auth_token")!)
//        var getStatus:Int?

        Alamofire.request(.GET , "\(urlHead):80/api/v1/user/info.json?auth_token=\(auth_token)").response{(request , response , data , error) in
            do{
                let obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let response = obj!["response"] as? [String:AnyObject]{
                    if let user = response["user"] as? [String:AnyObject]{
                        if let name = user["screen_name"] as? String{
                            self.userName.text = name
                        }
                       if let email = user["email"] as? String{
                            self.userEmail.text = email
                        }
                    }
                }
            }catch{
                print("Error")
            }
        }

    }

    func delete_Logout(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token = String(self.localdata.objectForKey("auth_token")!)
        var getStatus:Int?

        Alamofire.request(.DELETE , "\(urlHead):80/api/v1/auth/logout.json" , 
                        parameters:["auth_token":auth_token]
                        ).response{(request , response , data , error)in 
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    if let status = meta["status"] as? Int{
                        // print(status)
                        getStatus = status
                    }
                    if let message = meta["message"] as? String{
                        print(message)
                    }
                }
                if(getStatus! == 200){
                    let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier( "LoginView" ) as! UIViewController
                    self.presentViewController( targetViewController, animated: true, completion: nil)
                }
            }catch{
                print("Error")
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
