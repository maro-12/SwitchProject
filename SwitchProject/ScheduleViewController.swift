//
//  ScheduleViewController.swift
//  SwitchProject
//
//  Created by Naoya Kurahashi on 2015/12/15.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit
import Alamofire

class ScheduleViewController: UIViewController {
    private var myButton: UIButton!
    let localdata = NSUserDefaults.standardUserDefaults()
    var schedule_List = [String:Int]()
    var cron:String?
    var firstButtonPosition = 90

    @IBOutlet weak var day_of_the_week: UITextField!
    @IBOutlet weak var month: UITextField!
    @IBOutlet weak var day: UITextField!
    @IBOutlet weak var hour: UITextField!
    @IBOutlet weak var minute: UITextField!
    @IBOutlet weak var cronText: UITextField!
    
    @IBOutlet weak var scheduleList: UIView!
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        getScheduleList()
        
        day_of_the_week.placeholder = "曜日"
        month.placeholder = "月"
        day.placeholder = "日"
        hour.placeholder = "時間"
        minute.placeholder = "分"
        cronText.placeholder = "翻訳されたcron"
        
        textDesign(day_of_the_week)
        textDesign(month)
        textDesign(day)
        textDesign(hour)
        textDesign(minute)
        textDesign(cronText)
        
        roundButtonLayout(getButton)
        roundButtonLayout(addButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        scheduleButton()
    }
    
    @IBAction func getCronButton(sender: UIButton) {
        getCron()
    }
    @IBAction func postButton(sender: UIButton) {
        postCreateSchedule()
    }

    func nilCheck(textField : UITextField!){
        if(textField.text == ""){
            textField.text = "*"
        }
    }

    func setCron(){
        nilCheck(day_of_the_week)
        nilCheck(month)
        nilCheck(day)
        nilCheck(hour)
        nilCheck(minute)
        self.cron = "\(minute.text!) \(hour.text!) \(day.text!) \(month.text!) \(day_of_the_week.text!)"
        print(self.cron)
    }

    func scheduleButton(){
        for name in self.schedule_List.keys{
            buttonSet(name , yPosition : firstButtonPosition)
            firstButtonPosition += 40
        }
    }

    func buttonSet(buttonName : String , yPosition : Int){
        myButton = UIButton()
        myButton.frame = CGRectMake(0,0,200,20)
        myButton.setTitle(buttonName , forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.blackColor() , forState: UIControlState.Normal)
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y:CGFloat(yPosition))
        myButton.tag = 1
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        self.scheduleList.addSubview(myButton)
        self.buttonLayout(myButton)
    }
    
    func buttonLayout (button : UIButton){
        button.backgroundColor = UIColor.mcGrey50()
        button.layer.cornerRadius = 3
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(3.0 , 3.0)
    }

    func roundButtonLayout(button :UIButton){
        button.backgroundColor = UIColor.mcOrange300()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(2.0 , 2.0)
    }

    func textDesign(textField :UITextField!){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.mcGrey200().CGColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func getCron(){
        setCron()
        let urlHead:String = localdata.objectForKey("siteURL") as! String

        Alamofire.request(.GET , "\(urlHead):80/api/v1/schedule/cron_translator.json" ,
            parameters:["cron":self.cron!]).response{
            (request , response , data , error) in
            do{
                let obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    if let status = meta["status"] as? Int{
                         // print("getGroupのステータスは\(status)")
                    }
                }
                if let response = obj!["response"] as? [String:AnyObject]{
                    if let translation = response["translation"] as? String{
                        self.cronText.text = translation
                    }
                }
            }catch{
                print("getCron Error")
            }
        }
    }
    
    func getScheduleList(){
        let urlHead:String = localdata.objectForKey("siteURL") as! String
        let auth_token:String = String(localdata.objectForKey("auth_token")!)
        var schedule_name:String?
        var schedule_id:Int?
        
        Alamofire.request(.GET , "\(urlHead):80/api/v1/schedule.json",
            parameters:["auth_token":auth_token]).response{(request , response , data , error) in
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let response = obj!["response"] as? [String:AnyObject]{
                    if let scheduleAllay = response["schedules"] as? [AnyObject]{
                        for(var i=0 ; i < scheduleAllay.count ; i++){
                            if let schedule = scheduleAllay[i] as? [String:AnyObject]{
                                if let name = schedule["name"] as? String{
                                    schedule_name = name
                                    
                                }
                                if let id = schedule["id"] as? Int{
                                    schedule_id = id
                                }
                            }
                            self.schedule_List[schedule_name!] = schedule_id!
                        }
                    }
                }
                print(self.schedule_List)
            }catch{
                print("getScheduleList Error")                    
            }
        }
    }
    
    func postCreateSchedule(){
        let urlHead:String = localdata.objectForKey("siteURL") as! String
        let auth_token:String = String(localdata.objectForKey("auth_token")!)
        
        Alamofire.request(.POST , "\(urlHead):80/api/v1/schedule.json",
                        parameters:["auth_token":auth_token,
                                    "ir_id"     :11,
                                    "name"      :"sample schedule",
                                    "cron"      :self.cron!
                                    ]).response{(request , response , data , error) in
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    if let status = meta["status"] as? Int{
                        // print("postCreateSchedule\(status)")
                    }
                    if let message = meta["message"] as? String{
                        print(message)
                    }
                }
                if let response = obj!["response"] as? [String:AnyObject]{
                    if let schedule = response["schedule"] as? [String:AnyObject]{
                        if let name = schedule["name"] as? String{
                            // print(name)
                        }
                        if let description = schedule["description"] as? String{
                            print(description)
                        }
                    }
                }
            }catch{
                print("postCreateSchedule Error")
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
