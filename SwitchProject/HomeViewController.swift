//
//  HomeViewController.swift
//  apiTest
//
//  Created by Naoya Kurahashi on 2015/12/07.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    private var myButton: UIButton!
    let localdata = NSUserDefaults.standardUserDefaults()
    var infraredGroupList = [String:Int]()
    var firstButtonPosition:Int = 120
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSet("全て" , yPosition:50)
        roundButtonLayout(addButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        getGroup()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func groupButton(){
        for name in self.infraredGroupList.keys{
            buttonSet(name , yPosition: firstButtonPosition)
            firstButtonPosition += 70
        }
    }
    
    func buttonSet(buttonName : String , yPosition : Int){
        myButton = UIButton()
        myButton.frame = CGRectMake(0,0,200,50)
        myButton.setTitle(buttonName , forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.whiteColor() , forState: UIControlState.Normal)
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y:CGFloat(yPosition))
        myButton.tag = 1
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        self.secondView.addSubview(myButton)
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
    
    func onClickMyButton(sender : UIButton){
        if(sender.currentTitle! == "全て"){
            self.localdata.setInteger(0, forKey: "groupID")
            self.localdata.synchronize()
            print("遷移前だよ")
            self.performSegueWithIdentifier("InfraredIndexViewSegue", sender: self)
        }else{
            // if let group:[String:Int] = localdata.dictionaryForKey("InfraredGroupList") as? [String:Int]{
            let groupName = sender.currentTitle!
            let id:Int = self.infraredGroupList[groupName]!
            self.localdata.setInteger(id , forKey: "groupID")
            self.localdata.synchronize()
            // }
            self.performSegueWithIdentifier("InfraredIndexViewSegue", sender: self)
        }
    }
    
//     func getGroup(){
// //        localdata.setObject(nil , forKey:"infraredGroupList")
//         let urlHead:String = self.localdata.objectForKey("siteURL") as! String
//         // apiで取得するためのURLを指定
//         let auth_token:String = String(localdata.objectForKey("auth_token")!)
//         print(auth_token)
//         let URL = NSURL(string: "\(urlHead):80/api/v1/group.json?auth_token=\(auth_token)")
//         let req = NSMutableURLRequest(URL:URL!)
//         let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//         let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
//         let task = session.dataTaskWithRequest(req, completionHandler: {
//             (data, response, error) -> Void in
//             do{
//                 let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
//                 let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
//                 let resResponse:NSDictionary = json.objectForKey("response") as! NSDictionary
    
//                 if String(res["status"]!) == "200"{
//                     for item in resResponse["groups"] as! NSArray{
//                         let groupName:String = item["name"] as! String
//                         let groupId:Int = item["id"] as! Int
//                         self.infraredGroupList[groupName] = groupId
//                         self.localdata.setObject(self.infraredGroupList , forKey: "infraredGroupList")
//                         self.localdata.synchronize()
// //                        print(self.infraredGroupList)
// //                        print(groupName)
//                         print(self.localdata.dictionaryForKey("infraredGroupList"))
//                     }
//                 }else{
//                     print("取得できませんでした")
//                 }
                
//             }catch{
//                 print("Error")
//             }
            
//         })
        
//         task.resume()
//     }

    func getGroup(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token:String = String(localdata.objectForKey("auth_token")!)
        var name_group:String?
        var group_id:Int?
        Alamofire.request(.GET , "\(urlHead):80/api/v1/group.json?auth_token=\(auth_token)" ).response{(request , response , data , error) in
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
//                    print("fuga")
                    if let status = meta["status"] as? Int{
                        print("getGroupのステータスは\(status)")
                    }
                }
                if let response = obj!["response"] as? [String:AnyObject]{
                    print("responseだよ")
                    if let groupAllay = response["groups"] as? [AnyObject]{
                        for(var i=0 ; i < groupAllay.count ; i++){
                            if let group = groupAllay[i] as? [String:AnyObject]{
                                if let name = group["name"] as? String{
                                    name_group = name
//                                    print(name_group)
                                }
                                if let id = group["id"] as? Int{
                                    group_id = id
//                                    print(group_id)
                                }
                                self.infraredGroupList[name_group!] = group_id!
                            }
                        }
                    }
                    // print(self.infraredGroupList)
                }
//                for name in self.infraredGroupList.keys{
//                    self.buttonSet(name , yPosition: self.firstButtonPosition)
//                    self.firstButtonPosition += 70
//                }
                // print(self.infraredGroupList)
                self.groupButton()
            }catch{

            }
        }
//        print(self.infraredGroupList)
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
