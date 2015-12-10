//
//  HomeViewController.swift
//  apiTest
//
//  Created by Naoya Kurahashi on 2015/12/07.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    private var myButton: UIButton!
    let localdata = NSUserDefaults.standardUserDefaults()
    var infraredGroupList = [String:Int]()
    var firstButtonPosition:Int = 70
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSet("全て" , yPosition:0)
        roundButtonLayout(addButton)
        getGroup()
        
        
        if let new = localdata.dictionaryForKey("infraredGroupList"){
            for name in new.keys{
                buttonSet(name , yPosition: firstButtonPosition)
                firstButtonPosition += 70
            }
        }else{
            print("ser Error")
        }
//        print(new!["テレビ"])
        
//        buttonLayout(all)
//        buttonLayout(televi)
//        buttonLayout(eacon)
//        buttonSet(denki)
//        buttonSet(add)
        // Do any additional setup after loading the view.
    }
    
    func buttonSet(buttonName : String , yPosition : Int){
        myButton = UIButton()
        myButton.frame = CGRectMake(0,0,200,50)
        myButton.setTitle(buttonName , forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.whiteColor() , forState: UIControlState.Normal)
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y:CGFloat(yPosition))
//        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        self.secondView.addSubview(myButton)
        self.buttonLayout(myButton)
    }
    
    func buttonLayout (button : UIButton){
        button.backgroundColor = UIColor.mcIndigo300()
        button.layer.cornerRadius = 3
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(3.0 , 3.0)
    }
    
    func roundButtonLayout(button :UIButton){
        button.backgroundColor = UIColor.mcIndigo300()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(2.0 , 2.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getGroup(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        // apiで取得するためのURLを指定
//        let auth_token = localdata.objectForKey("auth_token")
        let URL = NSURL(string: "\(urlHead):80/api/v1/group.json?auth_token=TBT-O1GYRoi2ust40mAbnA")
        let req = NSMutableURLRequest(URL:URL!)
        
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
        
//        req.HTTPMethod = "POST"
//        req.HTTPBody = "".dataUsingEncoding(NSUTF8StringEncoding)
        
        //        print(self.user_name.text!)
        //        print(self.user_passwd.text!)
        //
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, response, error) -> Void in
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
                
                let res:NSDictionary = json.objectForKey("meta") as! NSDictionary
                let resResponse:NSDictionary = json.objectForKey("response") as! NSDictionary
                
                //                print(String(res["status"]!))
                if String(res["status"]!) == "200"{
//                    print(resResponse["groups"]![0]!["id"])
//                    self.localdata.setObject(String(resResponse["auth_token"]!) , forKey: "auth_token")
//                    self.localdata.synchronize()
//                    self.performSegueWithIdentifier("loginHomeSegue", sender: self)
                    for item in resResponse["groups"] as! NSArray{
                        let groupName:String = item["name"] as! String
                        let groupId:Int = item["id"] as! Int
                
                        self.infraredGroupList[groupName] = groupId
                        self.localdata.setObject(self.infraredGroupList , forKey: "infraredGroupList")
                        self.localdata.synchronize()
                        print(self.infraredGroupList)
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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
