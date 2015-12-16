//
//  LaunchViewController.swift
//  SwitchProject
//
//  Created by Naoya Kurahashi on 2015/12/11.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import Alamofire

class LaunchViewController: UIViewController {

    let localdata = NSUserDefaults.standardUserDefaults()
    var timer : NSTimer!
    var collectURL:Bool = true
    @IBOutlet weak var loginBar: MBCircularProgressBarView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // localdata.setObject(true , forKey: "collectURL")
        tryAPI()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: "update", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func update(){
        if(loginBar.value < 100){
            loginBar.value += 1
        }else{
            timer.invalidate()
            // let collectURL = self.localdata.objectForKey("collectURL")! as? Bool
            if(self.collectURL == true){
                if(localdata.objectForKey("auth_token") != nil){
                    //initialに飛ばす
                    self.performSegueWithIdentifier("InitialViewSegue", sender: self)
                }else{
                    //login画面に飛ばす
                    self.performSegueWithIdentifier("LoginViewSegue", sender: self)
                }
            }else{
                //URLError画面に飛ばす
                self.performSegueWithIdentifier("UrlErrorSegue", sender: self)
//                print("hoge")
            }
        }
    }
    
    func tryAPI(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        Alamofire.request(.GET , "\(urlHead):80/api/v1/auth/token.json").response{(request , response , data , error) in 
            do{
                let obj:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            }catch{
                self.collectURL = false
            }
        }
    }
}
