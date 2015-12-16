//
//  SelectInfraredViewController.swift
//  SwitchProject
//
//  Created by Naoya Kurahashi on 2015/12/16.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit
import Alamofire

class SelectInfraredViewController: UIViewController {
    private var myButton: UIButton!
    let localdata = NSUserDefaults.standardUserDefaults()
    var infraredList = [String:Int]()
    var infraredCountList = [String:Int]()
    var firstButtonPosition = 40
    var tagNumberDic = [String:Int]()
    var selectedName:String?
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var doneOutlet: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated:Bool){
        self.viewDidDisappear(animated)
        getInfrared()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doneButton(sender: UIBarButtonItem) {
        localdata.setInteger(1 , forKey:"done")
        localdata.setObject(self.selectedName! , forKey:"selectedName")
        localdata.synchronize()
        self.performSegueWithIdentifier("backScheduleSegue" , sender:self)
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
        myButton.tag = 0
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        tagNumberDic[buttonName] = myButton.tag
        
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
        var count = 0
        if(sender.tag == 0){
            sender.backgroundColor = UIColor.mcRed500()
            sender.tag = 1
            tagNumberDic[name] = 1
        }else{
            sender.backgroundColor = UIColor.mcOrange300()
            sender.tag = 0
            tagNumberDic[name] = 0
        }
        for tag in tagNumberDic.values{
            if(tag == 1){
                count += 1
            }
        }
        if(count > 1){
            self.doneOutlet.enabled = false
        }else{
            for name_tagDic in tagNumberDic.keys{
                if(tagNumberDic[name_tagDic] == 1){
                    name = name_tagDic
                }
            }
            self.doneOutlet.enabled = true
            self.selectedName = name
        }
    }

    func getInfrared(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token = String(localdata.objectForKey("auth_token")!)
//        var getStatus:Int?
        var infrared_name:String?
        var infrared_id:Int?
        
        Alamofire.request(.GET , "\(urlHead):80/api/v1/ir.json?auth_token=\(auth_token)").response{(request , response , data , error) in 
            do{
                let obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    if let _ = meta["status"] as? Int{
//                        getStatus = status
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
