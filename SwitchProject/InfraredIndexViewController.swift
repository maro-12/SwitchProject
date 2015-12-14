//
//  InfraredIndexViewController.swift
//  SwitchProject
//
//  Created by Naoya Kurahashi on 2015/12/11.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit

class InfraredIndexViewController: UIViewController {
    private var myButton: UIButton!
    let localdata = NSUserDefaults.standardUserDefaults()
    var infraredList = [String:Int]()
    var infraredCountList = [String:Int]()
    var firstButtonPosition = 0
    
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
    
//    override func viewWillDisappear(animated: Bool) {

//        if let viewControllers = self.navigationController?.viewControllers {
//            var existsSelfInViewControllers = true
//            for viewController in viewControllers {
//                // viewWillDisappearが呼ばれる時に、
//                // 戻る処理を行っていれば、NavigationControllerのviewControllersの中にselfは存在していない
//                if viewController == self {
//                    existsSelfInViewControllers = false
//                    // selfが存在した時点で処理を終える
//                    break
//                }
//            }
//            
//            if existsSelfInViewControllers {
//                self.localdata.removeObjectForKey("infraredList")
//            }
//        }
//        super.viewWillDisappear(animated)
//    }
    
    override func viewWillAppear(animated:Bool){
        self.viewDidDisappear(animated)
        self.localdata.removeObjectForKey("infraredList")
        getInfrared()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if let infrared:[String:Int] = localdata.dictionaryForKey("infraredList") as? [String:Int]{
            let name:String = sender.currentTitle!
            let id:Int = infrared[name]!
            sendInfrared(id)
        }
//        print(infraredCountList)
    }
    
    func getInfrared(){
//        infraredList = [:]
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        // apiで取得するためのURLを指定
        var groupIs = false
        let auth_token = String(localdata.objectForKey("auth_token")!)
        var str:String = ""
        let groupID:Int
        if(self.localdata.objectForKey("groupID") != nil){
            groupID = self.localdata.objectForKey("groupID") as! Int
            print(groupID)
            print("hogehoge")
            str = "\(urlHead):80/api/v1/group/ir.json?auth_token=\(auth_token)&group_id=\(groupID)"
            groupIs = true
        }else{
            print("fugafuga")
            str = "\(urlHead):80/api/v1/ir.json?auth_token=\(auth_token)"
        }
        let URL = NSURL(string: str)
        let req = NSMutableURLRequest(URL:URL!)
        
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
        
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, response, error) -> Void in
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
                let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
                let resResponse:NSDictionary = json.objectForKey("response") as! NSDictionary
//                let resGroup:NSDictionary = resResponse.objectForKey("group") as! NSDictionary
                let list:NSDictionary
                if(groupIs){
                    list = resResponse.objectForKey("group") as! NSDictionary
                }else{
                    list = resResponse
                }
                if String(res["status"]!) == "200"{
                        for item in list["infrareds"] as! NSArray{
                            let infraredName:String = item["name"] as! String
                            let infraredId:Int = item["id"] as! Int
                            let count:Int = item["count"] as! Int
                            self.localdata.setInteger(count, forKey: "ir_id")
                            self.infraredList[infraredName] = infraredId
                            self.localdata.setObject(self.infraredList , forKey: "infraredList")
                            self.localdata.synchronize()
                            
                            self.buttonSet(infraredName , yPosition : self.firstButtonPosition)
                            self.firstButtonPosition += 5
                        }
                }else{
                    print("取得できませんでした")
                }
                
            }catch{
                print("Error")
            }
            
        })
        
        task.resume()
    }
    
    func sendInfrared(ir_id : Int){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        // apiで取得するためのURLを指定
        let URL = NSURL(string: "\(urlHead):80/api/v1/ir/send.json")
        let req = NSMutableURLRequest(URL:URL!)
        let auth_token = String(localdata.objectForKey("auth_token")!)
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
        req.HTTPMethod = "POST"
        req.HTTPBody = "auth_token=\(auth_token)&ir_id=\(ir_id)".dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, response, error) -> Void in
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
                let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
                let resResponse:NSDictionary = json.objectForKey("response") as! NSDictionary
                
                if String(res["status"]!) == "201"{
                    let name = resResponse["infrared"]!["name"] as! String
                    let count = resResponse["infrared"]!["count"] as! Int
                    self.infraredCountList[name] = count
                    self.localdata.setObject(self.infraredCountList , forKey: "count")
                    self.localdata.synchronize()
                    print("success!")
                }else{
                    print("赤外線の照射に失敗しました")
                }
                
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
