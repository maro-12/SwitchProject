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
    var firstButtonPosition:Int = 120
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSet("全て" , yPosition:50)
        roundButtonLayout(addButton)
//        localdata.setObject(nil , forKey: "infraredGroupList")
//        localdata.setObject([:], forKey: "infraredList")
//        print(new!["テレビ"])
//        buttonLayout(all)
//        buttonLayout(televi)
//        buttonLayout(eacon)
//        buttonSet(denki)
//        buttonSet(add)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
//        print("SecondViewControllerのviewWillAppearが呼ばれた")
        print("呼ばれたよ!")
//        localdata.setObject(nil , forKey:"infraredGroupList")
        getGroup()
        print(localdata.dictionaryForKey("infraredGroupList"))
        if let new:[String:Int] = localdata.dictionaryForKey("infraredGroupList") as? [String:Int]{
            print("jack")
            for name in new.keys{
                print(name)
                buttonSet(name , yPosition: firstButtonPosition)
                firstButtonPosition += 70
            }
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        print("HomeViewControllerのviewDidAppearが呼ばれた")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        localdata.setObject(nil , forKey:"infraredGroupList")
        localdata.synchronize()
//        print("HomeViewControllerのviewDidDisappearが呼ばれた")
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
    
    func onClickMyButton(sender : UIButton){
//        let nextView:UIViewController = InfraredIndexViewController()
//        nextView.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
//        let iS = false
//        
//        let targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "InfraredsView" )
//        
//        for name in infraredGroupList.keys{
//            if(name == sender.currentTitle){
//                self.localdata.setObject(infraredGroupList[name] , forKey: "GroupID")
//                self.localdata.synchronize()
////                self.presentViewController(nextView, animated: true, completion: nil)
//            }
//        }
//        if(!iS){
//            self.localdata.setObject(nil, forKey: "GroupId")
//            self.localdata.synchronize()
//        }
//        self.presentViewController( targetView as! UIViewController, animated: true, completion: nil)
            //        self.presentViewController(nextView, animated: true, completion: nil)
//        self.performSegueWithIdentifier("InfraredSegue", sender: self
        if(sender.currentTitle! == "全て"){
            self.localdata.setObject(nil, forKey: "groupID")
            self.localdata.synchronize()
            print("遷移前だよ")
            self.performSegueWithIdentifier("InfraredIndexViewSegue", sender: self)
        }else{
            if let group:[String:Int] = localdata.dictionaryForKey("InfraredGroupList") as? [String:Int]{
                let groupName = sender.currentTitle!
                let id:Int = group[groupName]!
                print(id)
                self.localdata.setObject(id , forKey: "groupID")
                self.localdata.synchronize()
            }
            self.performSegueWithIdentifier("InfraredIndexViewSegue", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getGroup(){
//        localdata.setObject(nil , forKey:"infraredGroupList")
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        // apiで取得するためのURLを指定
        let auth_token:String = String(localdata.objectForKey("auth_token")!)
        print(auth_token)
        let URL = NSURL(string: "\(urlHead):80/api/v1/group.json?auth_token=\(auth_token)")
        let req = NSMutableURLRequest(URL:URL!)
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
//       infraredGroupList = [:]
        
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
    
                if String(res["status"]!) == "200"{
                    for item in resResponse["groups"] as! NSArray{
                        let groupName:String = item["name"] as! String
                        let groupId:Int = item["id"] as! Int
                        self.infraredGroupList[groupName] = groupId
                        self.localdata.setObject(self.infraredGroupList , forKey: "infraredGroupList")
                        self.localdata.synchronize()
//                        print(self.infraredGroupList)
//                        print(groupName)
                        print(self.localdata.dictionaryForKey("infraredGroupList"))
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
