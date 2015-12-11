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
    var firstButtonPosition = 0
    
    @IBOutlet weak var scrollView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInfrared()
        
        if let infrared = localdata.dictionaryForKey("infraredList"){
            for name in infrared.keys{
                buttonSet(name , yPosition:firstButtonPosition)
                firstButtonPosition += 5
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonSet(buttonName : String , yPosition : Int){
        myButton = UIButton()
        myButton.frame = CGRectMake(0,0,320,30)
        myButton.setTitle(buttonName , forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.whiteColor() , forState: UIControlState.Normal)
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y:CGFloat(yPosition))
        //        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(myButton)
        self.buttonLayout(myButton)
    }
    
    func buttonLayout (button : UIButton){
        button.backgroundColor = UIColor.mcIndigo300()
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

    
    func getInfrared(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        // apiで取得するためのURLを指定
        let auth_token = localdata.objectForKey("auth_token")
        let URL = NSURL(string: "\(urlHead):80/api/v1/ir.json?auth_token=\(auth_token)")
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
                    for item in resResponse["infrareds"] as! NSArray{
                        let infraredName:String = item["name"] as! String
                        let infraredId:Int = item["id"] as! Int
                        
                        self.infraredList[infraredName] = infraredId
                        self.localdata.setObject(self.infraredList , forKey: "infraredList")
                        self.localdata.synchronize()
//                        print(self.infraredList)
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
