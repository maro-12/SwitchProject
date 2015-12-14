//
//  InitialTabBarViewController.swift
//  apiTest
//
//  Created by Naoya Kurahashi on 2015/12/07.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit

class InitialTabBarViewController: UITabBarController {
    let defaultSet = NSUserDefaults.standardUserDefaults()
    let localdata = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if defaultSet.boolForKey("firstLunch"){
//            localdata.setObject("http://3be4b217.ngrok.io" , forKey : "siteURL")
//            localdata.synchronize()
//            defaultSet.setBool(false, forKey: "firstLaunch")
//        }
    
//        if(getData()){
//            if(localdata.objectForKey("auth_token") == nil){
//                self.performSegueWithIdentifier("loginViewSegue", sender: self)
//            }
//        }
//        getData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getData(){
////        var urlCollect:Bool = true
//        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
//        let siteURL = NSURL(string: "\(urlHead):80/api/v1/auth/token.json")
////        let auth_token : String = self.localdata.objectForKey("auth") as! String
////        let status:String = localdata.objectForKey("status") as! String
//        let req = NSMutableURLRequest(URL:siteURL!)
//        
//        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
//        
//        let task = session.dataTaskWithRequest(req, completionHandler: {
//            (data, response, error) -> Void in
//            do{
//                _ = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
//            }catch{
////                urlCollect = false
////                self.performSegueWithIdentifier("siteURLErrorSegue", sender: self)
////                print(auth_token)
//            }
//        })
//        task.resume()
//        print("hello")
////        return urlCollect
//    }


}
