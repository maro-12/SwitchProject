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
    var firstButtonPosition:Int = 140
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundButtonLayout(addButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        infraredGroupList = [:]
        firstButtonPosition = 140
        let username = String(localdata.objectForKey("userName")!)
        userLabel.text = username
        getGroup()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // self.infraredGroupList = [:]

        // for subview in secondView.subviews {
        //     subview.removeFromSuperview()
        // }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let views = secondView.subviews
        for subview in views {
            if subview.isKindOfClass(UIButton) {
                subview.removeFromSuperview()
            }
        }
        // print("HomeViewControllerのviewDidDisappearが呼ばれた")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func groupButton(){
        buttonSet("全て" , yPosition:70)
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
        button.backgroundColor = UIColor.mcOrange300()
        button.layer.cornerRadius = 3
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(1.0 , 2.0)
    }
    
    func roundButtonLayout(button :UIButton){
        button.backgroundColor = UIColor.mcOrange300()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(2.0 , 2.0)
    }
    
    func onClickMyButton(sender : UIButton){
        if(sender.currentTitle! == "全て"){
            self.localdata.setInteger(0, forKey: "groupID")
            self.localdata.synchronize()
            self.performSegueWithIdentifier("InfraredIndexViewSegue", sender: self)
        }else{
            let groupName = sender.currentTitle!
            let id:Int = self.infraredGroupList[groupName]!
            print("Homeから遷移のときは\(id)")
            self.localdata.setInteger(id , forKey: "groupID")
            self.localdata.synchronize()
            self.performSegueWithIdentifier("InfraredIndexViewSegue", sender: self)
        }
    }
    
    func getGroup(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token:String = String(localdata.objectForKey("auth_token")!)
        var name_group:String?
        var group_id:Int?
        Alamofire.request(.GET , "\(urlHead):80/api/v1/group.json?auth_token=\(auth_token)" ).response{(request , response , data , error) in
            do{
                let obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
//                    print("fuga")
                    if let _ = meta["status"] as? Int{
                        // print("getGroupのステータスは\(status)")
                    }
                }
                if let response = obj!["response"] as? [String:AnyObject]{
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
                }
                self.groupButton()
            }catch{

            }
        }
//        print(self.infraredGroupList)
    }
}
