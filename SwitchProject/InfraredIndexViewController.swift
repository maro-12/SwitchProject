//
//  InfraredIndexViewController.swift
//  SwitchProject
//
//  Created by Naoya Kurahashi on 2015/12/11.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit
import Alamofire

class InfraredIndexViewController: UIViewController {
    private var myButton: UIButton!
    let localdata = NSUserDefaults.standardUserDefaults()
    var infraredList = [String:Int]()
    var infraredCountList = [String:Int]()
    var firstButtonPosition = 30
    var apiURL:String?
    var groupID:Int?
    
    @IBOutlet weak var scrollView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
//
//        if let infrared:[String:Int] = localdata.dictionaryForKey("infraredList") as? [String:Int]{
//            for name in infrared.keys{
//                buttonSet(name , yPosition:firstButtonPosition)
//                firstButtonPosition += 5
////                print(name)
//            }
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated:Bool){
        self.viewDidDisappear(animated)
        // self.localdata.removeObjectForKey("infraredList")
         groupID = localdata.integerForKey("groupID")
        if(groupID == 0){
            getInfrared()
            // apiURL = "\(urlHead):80/api/v1/ir.json?auth_token=\(auth_token)"
        }else{
            getGroupInfrared()
            // apiURL =  "\(urlHead):80/api/v1/group/ir.json?auth_token=\(auth_token)&group_id=\(groupID)"
        }
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        for name in self.infraredList.keys{
//            buttonSet(name , yPosition : firstButtonPosition)
//            firstButtonPosition += 5
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func infraredButton(){
        for name in self.infraredList.keys{
            buttonSet(name , yPosition : firstButtonPosition)
            firstButtonPosition += 40
        }
    }
    
    func buttonSet(buttonName : String , yPosition : Int){
        myButton = UIButton()
        myButton.frame = CGRectMake(0,0,300,30)
        myButton.setTitle(buttonName , forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.whiteColor() , forState: UIControlState.Normal)
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y:CGFloat(yPosition))
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(myButton)
        self.buttonLayout(myButton)
    }
    
    func buttonLayout (button : UIButton){
        button.backgroundColor = UIColor.mcTeal100()
        button.layer.cornerRadius = 3
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(3.0 , 3.0)
    }
    
    func roundButtonLayout(button :UIButton){
        button.backgroundColor = UIColor.mcTeal100()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(2.0 , 2.0)
    }

    func onClickMyButton(sender : UIButton) {
        // if let infrared:[String:Int] = localdata.dictionaryForKey("infraredList") as? [String:Int]{
        //     let name:String = sender.currentTitle!
        //     let id:Int = infrared[name]!
        //     sendInfrared(id)
        // }
        let name:String = sender.currentTitle!
        let id:Int = infraredList[name]!
        postInfrared(id)
//        print(infraredCountList)
    }
    
//     func getInfrared(){
// //        infraredList = [:]
//         let urlHead:String = self.localdata.objectForKey("siteURL") as! String
//         // apiで取得するためのURLを指定
//         var groupIs = false
//         let auth_token = String(localdata.objectForKey("auth_token")!)
//         var str:String = ""
//         let groupID:Int
//         if(self.localdata.objectForKey("groupID") != nil){
//             groupID = self.localdata.objectForKey("groupID") as! Int
//             print(groupID)
//             print("hogehoge")
//             str =
//             groupIs = true
//         }else{
//             print("fugafuga")
//         }
//         let URL = NSURL(string: str)
//         let req = NSMutableURLRequest(URL:URL!)
        
        
//         let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//         let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
        
//         let task = session.dataTaskWithRequest(req, completionHandler: {
//             (data, response, error) -> Void in
//             do{
//                 let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
//                 let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
//                 let resResponse:NSDictionary = json.objectForKey("response") as! NSDictionary
// //                let resGroup:NSDictionary = resResponse.objectForKey("group") as! NSDictionary
//                 let list:NSDictionary
//                 if(groupIs){
//                     list = resResponse.objectForKey("group") as! NSDictionary
//                 }else{
//                     list = resResponse
//                 }
//                 if String(res["status"]!) == "200"{
//                         for item in list["infrareds"] as! NSArray{
//                             let infraredName:String = item["name"] as! String
//                             let infraredId:Int = item["id"] as! Int
//                             let count:Int = item["count"] as! Int
//                             self.localdata.setInteger(count, forKey: "ir_id")
//                             self.infraredList[infraredName] = infraredId
//                             self.localdata.setObject(self.infraredList , forKey: "infraredList")
//                             self.localdata.synchronize()
                            
//                             self.buttonSet(infraredName , yPosition : self.firstButtonPosition)
//                             self.firstButtonPosition += 5
//                         }
//                 }else{
//                     print("取得できませんでした")
//                 }
                
//             }catch{
//                 print("Error")
//             }
            
//         })
        
//         task.resume()
//     }


    func getInfrared(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token = String(localdata.objectForKey("auth_token")!)
        var getStatus:Int?
        var infrared_name:String?
        var infrared_id:Int?
        
        Alamofire.request(.GET , "\(urlHead):80/api/v1/ir.json?auth_token=\(auth_token)").response{(request , response , data , error) in 
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    if let status = meta["status"] as? Int{
                        getStatus = status
                    }
                }
                if let response = obj!["response"] as? [String:AnyObject]{
                    if let infraredAllay = response["infrareds"] as? [AnyObject]{
                        for(var i=0 ; i < infraredAllay.count ; i++){
                            if let infrared = infraredAllay[i] as? [String:AnyObject]{
                                if let name = infrared["name"] as? String{
                                    infrared_name = name
                                }
                                if let id = infrared["id"] as? Int{
                                    infrared_id = id
                                }
                                self.infraredList[infrared_name!] = infrared_id!
                            }
                        }
                    }
                }
               self.infraredButton()
            }catch{
                print("取得できませんでした")
            }
        }
    }

    func getGroupInfrared(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token = String(localdata.objectForKey("auth_token")!)
        var getStatus:Int?
        var infrared_name:String?
        var infrared_id:Int?
        
        Alamofire.request(.GET , "\(urlHead):80/api/v1/group/ir.json?auth_token=\(auth_token)&group_id=\(self.groupID)" ).response{(request , response , data , error) in
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    if let status = meta["status"] as? Int{
                        getStatus = status
                    }
                }
                if let response = obj!["response"] as? [String:AnyObject]{
                    if let group = response["group"] as? [String:AnyObject]{
                        if let infraredAllay = group["infrareds"] as? [AnyObject]{
                            for(var i=0 ; i < infraredAllay.count ; i++){
                                if let infrared = infraredAllay[i] as? [String:AnyObject]{
                                    if let name = infrared["name"] as? String{
                                        infrared_name = name
                                    }
                                    if let id = group["id"] as? Int{
                                        infrared_id = id
                                    }
                                    self.infraredList[infrared_name!] = infrared_id!
                                }
                            }
                        }
                    }
                }
                
                self.infraredButton()
            }catch{
                print("取得できませんでした")
            }
        }
    }

    
    // func sendInfrared(ir_id : Int){
    //     let urlHead:String = self.localdata.objectForKey("siteURL") as! String
    //     // apiで取得するためのURLを指定
    //     let URL = NSURL(string: "\(urlHead):80/api/v1/ir/send.json")
    //     let req = NSMutableURLRequest(URL:URL!)
    //     let auth_token = String(localdata.objectForKey("auth_token")!)
    //     let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    //     let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
    //     req.HTTPMethod = "POST"
    //     req.HTTPBody = "auth_token=\(auth_token)&ir_id=\(ir_id)".dataUsingEncoding(NSUTF8StringEncoding)
    //     let task = session.dataTaskWithRequest(req, completionHandler: {
    //         (data, response, error) -> Void in
    //         do{
    //             let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
    //             let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
    //             let resResponse:NSDictionary = json.objectForKey("response") as! NSDictionary
                
    //             if String(res["status"]!) == "201"{
    //                 let name = resResponse["infrared"]!["name"] as! String
    //                 let count = resResponse["infrared"]!["count"] as! Int
    //                 self.infraredCountList[name] = count
    //                 self.localdata.setObject(self.infraredCountList , forKey: "count")
    //                 self.localdata.synchronize()
    //                 print("success!")
    //             }else{
    //                 print("赤外線の照射に失敗しました")
    //             }
                
    //         }catch{
    //             //                self.performSegueWithIdentifier("errorSegue", sender: self)
    //             print("Error")
    //         }
            
    //     })
        
    //     task.resume()
    // }

    func postInfrared(ir_id:Int){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token = String(localdata.objectForKey("auth_token")!)
        var infrared_name:String?
        var infrared_count:Int?
    
        Alamofire.request(.POST , "\(urlHead):80/api/v1/ir/send.json" , 
                        parameters:["auth_token":"\(auth_token)",
                                    "ir_id"     :"\(ir_id)"
                        ]).response{(request , response , data , error ) in 
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    print("fuga")
                    if let status = meta["status"] as? Int{
                        print(status)
                    }
                    if let message = meta["message"] as? String{
                        print(message)
                    }
                }
                if let response = obj!["response"] as? [String:AnyObject]{
                    if let infrared = response["infrared"] as? [String:AnyObject]{
                        if let name = infrared["name"] as? String{
                            infrared_name = name
                        }
                        if let count = infrared["count"] as? Int{
                            infrared_count = count
                        }
                    }
                    self.infraredCountList[infrared_name!] = infrared_count!
                }
            }catch{
                print("照射できませんでした")
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
