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
    @IBOutlet weak var userLabel: UILabel!
    @IBAction func backHome(sender: UIBarButtonItem) {
        let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier( "TabBarView" ) 
        self.presentViewController( targetViewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated:Bool){
        self.viewDidDisappear(animated)
        let username = String(localdata.objectForKey("userName")!)
        userLabel.text = username
        // self.localdata.removeObjectForKey("infraredList")
        groupID = localdata.integerForKey("groupID")
        if(groupID == 0){
            print("hogehoge")
            getInfrared()
        }else{
            print("fugafuga")
            getGroupInfrared()
            var button = UIButton()
            button.frame = CGRectMake(0,0,40,40)
            button.setTitle("+" , forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor() , forState: UIControlState.Normal)
            button.layer.position = CGPoint(x: 260, y:400)
            button.addTarget(self, action: "addInfraredToGroup:", forControlEvents: .TouchUpInside)
            self.roundButtonLayout(button)
            self.scrollView.addSubview(button)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addInfraredToGroup(sender:UIButton){
        self.performSegueWithIdentifier("toInfraredAddGroupSegue" , sender: self)
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
        self.editButtonSet(buttonName , yPosition: yPosition)
        self.trashButtonSet(buttonName , yPosition: yPosition)
    }

    func editButtonSet(name:String , yPosition:Int){
        let image = UIImage(named: "edit.png")
        let imageButton = UIButton()
        imageButton.frame = CGRectMake(0, 0, 20, 20)
        imageButton.layer.position = CGPoint(x: (self.view.frame.width - 60 ) , y:CGFloat(yPosition+2))
        imageButton.setImage(image, forState: .Normal)
        imageButton.setTitle(name , forState: UIControlState.Normal)
        imageButton.addTarget(self, action: "inputEditAlert:", forControlEvents:.TouchUpInside)
         
        self.scrollView.addSubview(imageButton)
    }

    func trashButtonSet(name:String , yPosition : Int){
        let image = UIImage(named: "trash.png")
        let imageButton   = UIButton()
        imageButton.frame = CGRectMake(0, 0, 20, 20)
        imageButton.layer.position = CGPoint(x: (self.view.frame.width - 35 ) , y:CGFloat(yPosition+2))
        imageButton.setImage(image, forState: .Normal)
        imageButton.setTitle(name , forState: UIControlState.Normal)
        imageButton.addTarget(self, action: "deleteInfrared:", forControlEvents:.TouchUpInside)
         
        self.scrollView.addSubview(imageButton)
    }
    
    func buttonLayout (button : UIButton){
        button.backgroundColor = UIColor.mcOrange300()
        button.layer.cornerRadius = 3
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(3.0 , 3.0)
    }
    
    func roundButtonLayout(button :UIButton){
        button.backgroundColor = UIColor.mcOrange300()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(2.0 , 2.0)
    }

    func onClickMyButton(sender : UIButton) {
        let name:String = sender.currentTitle!
        let id:Int = infraredList[name]!
        postInfrared(id)
    }


    
    func inputEditAlert(sender:UIButton) {
        var infraredNameTextField: UITextField?
        let old_Ir_name = sender.currentTitle!
        var new_Ir_name:String?
        var ir_id:Int?

        let alertController: UIAlertController = UIAlertController(title: "名前をつけてね", message: "Input infrared name", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { textField -> Void in
            infraredNameTextField = textField
            textField.placeholder = old_Ir_name
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
        }
        let logintAction: UIAlertAction = UIAlertAction(title: "Done", style: .Default) { action ->  Void in
            ir_id = self.infraredList[old_Ir_name]
            new_Ir_name = infraredNameTextField!.text
            self.putInfraredRename(old_Ir_name , infrared_name: new_Ir_name! , infrared_id: ir_id!)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(logintAction)
        
 
        presentViewController(alertController, animated: true, completion: nil)
    }


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
        
        Alamofire.request(.GET , "\(urlHead):80/api/v1/group/ir.json" ,
                    parameters:["auth_token":auth_token ,
                                "group_id"   :self.groupID!
                                ]).response{(request , response , data , error) in
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    if let status = meta["status"] as? Int{
                        print(status)
                    }
                }
                if let response = obj!["response"] as? [String:AnyObject]{
                    if let group = response["group"] as? [String:AnyObject]{
                        if let infraredAllay = group["infrareds"] as? [AnyObject]{
                            for(var i=0 ; i < infraredAllay.count ; i++){
                                if let infrared = infraredAllay[i] as? [String:AnyObject]{
                                    if let name = infrared["name"] as? String{
                                        print("きてます")
                                        infrared_name = name
                                    }
                                    if let id = infrared["id"] as? Int{
                                        print("けつべん")
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

    func putInfraredRename(old_infrared_name:String?, infrared_name:String? , infrared_id:Int?){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token = String(self.localdata.objectForKey("auth_token")!)
        var getStatus:Int?
        Alamofire.request(.PUT , "\(urlHead):80/api/v1/ir/rename.json" ,
                        parameters:["auth_token":"\(auth_token)" ,
                                    "name"      :"\(infrared_name!)",
                                    "ir_id"      :"\(infrared_id!)"
                                    ]).response{(request , response , data , error ) in
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String:AnyObject]{
                    print("fuga")
                    if let status = meta["status"] as? Int{
                        getStatus = status
                    }
                }
                if(getStatus! == 200){
                    print("りねいむ完了")
                    self.infraredList[old_infrared_name!] = nil
                    self.infraredList[infrared_name!] = infrared_id
                }else{
                    print("りねいむ失敗")
                }
            }catch{
                print("Error putInfraredRename")
            }
        }
    }    

    func deleteInfrared(sender:UIButton){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token = String(localdata.objectForKey("auth_token")!)
        var infrared_name = sender.currentTitle!
        var infrared_id = self.infraredList[infrared_name]
        var getStatus:Int?

        Alamofire.request(.DELETE , "\(urlHead):80/api/v1/ir.json" , parameters:["auth_token":auth_token , "ir_id":infrared_id!]).response{(request , response , data , error) in
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    print("fuga")
                    if let status = meta["status"] as? Int{
                        // print(status)
                        getStatus = status
                    }
                    if let message = meta["message"] as? String{
                        print(message)
                    }
                }
                if(getStatus! == 200){
                    self.infraredList[infrared_name] = nil
                }
            }catch{
                print("削除できませんでした")
            }
        }
    }
}
