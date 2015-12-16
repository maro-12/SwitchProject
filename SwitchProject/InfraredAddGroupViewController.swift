//
//  InfraredAddGroupViewController.swift
//  SwitchProject
//
//  Created by Naoya Kurahashi on 2015/12/16.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit
import Alamofire

class InfraredAddGroupViewController: UIViewController {
    private var myButton: UIButton!
    let localdata = NSUserDefaults.standardUserDefaults()
    var infraredList = [String:Int]()
    var infraredList_in_group = [String:Int]()
    var forAddInfraredList:[String] = []
    var firstButtonPosition = 30
    var groupID:Int?
    var id_Allay:[String] = []
//    var ir_id:String?


    @IBOutlet weak var scrollView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated:Bool){
        self.viewDidDisappear(animated)
        getGroupInfrared()
        getInfraredList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backView(sender: UIBarButtonItem) {
    }

    @IBAction func infraredAdd(sender: UIButton) {
        postInfraredAddToGroup()
    }
    

    func infraredButton(){
        for name in self.forAddInfraredList{
            buttonSet(name , yPosition : firstButtonPosition)
            firstButtonPosition += 40
        }
    }
    
    func buttonSet(buttonName : String , yPosition : Int){
        myButton = UIButton()
        myButton.tag = 0 //押されてない
        myButton.frame = CGRectMake(0,0,250,30)
        myButton.setTitle(buttonName , forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.whiteColor() , forState: UIControlState.Normal)
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y:CGFloat(yPosition))
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(myButton)
        self.buttonLayout(myButton)
    }

    func buttonLayout (button : UIButton){
        button.backgroundColor = UIColor.mcOrange300()
        button.layer.cornerRadius = 3
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(3.0 , 3.0)
    }

    func onClickMyButton(sender:UIButton){
        var name = sender.currentTitle!
        var id = self.infraredList[name]!
        var index:Int?
        if(sender.tag == 0){
            sender.backgroundColor = UIColor.mcRed500()
            sender.tag = 1
//            if(id_Allay.indexOf(id) == nil){
//                id_Allay.append(id)
//            }
            id_Allay.append("\(id)")
        }else{
            sender.backgroundColor = UIColor.mcOrange300()
            sender.tag = 0
            index = id_Allay.indexOf("\(id)")
            id_Allay.removeAtIndex(index!)
        }
    }

    func getInfraredList(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token = String(localdata.objectForKey("auth_token")!)
        var getStatus:Int?
        var infrared_id:Int?
        var infrared_name:String?

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
                for name in self.infraredList.keys{
                    var flag = true
                    for name_in_group in self.infraredList_in_group.keys{
                        if(name == name_in_group){
                            print("\(name) と \(name_in_group)")
                            flag = false
                        }
                    }
                    if(flag == true){
                        self.forAddInfraredList.append(name)
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
        self.groupID = localdata.integerForKey("groupID")
        var getStatus:Int?
        var infrared_name:String?
        var infrared_id:Int?
        
        Alamofire.request(.GET , "\(urlHead):80/api/v1/group/ir.json?auth_token=\(auth_token)&group_id=\(self.groupID!)" ).response{(request , response , data , error) in
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
                                    if let id = infrared["id"] as? Int{
                                        infrared_id = id
                                    }
                                    self.infraredList_in_group[infrared_name!] = infrared_id!
                                }
                            }
                        }
                    }
                }
                // self.infraredButton()
            }catch{
                print("取得できませんでした")
            }
        }
    }

    func postInfraredAddToGroup(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token = String(localdata.objectForKey("auth_token")!)
        let ir_id = self.id_Allay.joinWithSeparator(",")

        Alamofire.request(.POST , "\(urlHead):80/api/v1/group/ir.json" , 
                        parameters:["auth_token"  :auth_token,
                                    "group_id"    :self.groupID!,
                                    "ir_id"       :ir_id ] ).response{(request , response , data , error) in
            do{
                // print("hogeeee")
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    if let status = meta["status"] as? Int{
                        print(status)
                    }
                    if let message = meta["message"] as? String{
                        print(message)
                    }
                }
                // if let response = obj!["response"] as? [String : AnyObject]{
                //     print("gege")
                //     if let auth_token = response["auth_token"] as? String{
                //         // self.getAuth_token = auth_token
                //         print(auth_token)
                //     }
                // }

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
