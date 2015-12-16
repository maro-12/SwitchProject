//
//  ScheduleViewController.swift
//  SwitchProject
//
//  Created by Naoya Kurahashi on 2015/12/15.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit
import Alamofire

class ScheduleViewController: UIViewController , UITextFieldDelegate{
    private var myButton: UIButton!
    let localdata = NSUserDefaults.standardUserDefaults()
    var schedule_List = [String:Int]()
    var infraredList = [String:Int]()
    var cron:String?
    var firstButtonPosition = 90
    var selectedName:String?

    @IBOutlet weak var day_of_the_week: UITextField!
    @IBOutlet weak var month: UITextField!
    @IBOutlet weak var day: UITextField!
    @IBOutlet weak var hour: UITextField!
    @IBOutlet weak var minute: UITextField!
    @IBOutlet weak var cronText: UITextField!
    @IBOutlet weak var infrared: UITextField!
    @IBOutlet weak var scheduleName: UITextField!
    
    @IBOutlet weak var scheduleList: UIView!
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        day_of_the_week.delegate = self
        month.delegate = self
        day.delegate = self
        hour.delegate = self
        minute.delegate = self
        cronText.delegate = self
        cronText.enabled = false
        infrared.delegate = self
        infrared.enabled = false
        scheduleName.delegate = self

        day_of_the_week.placeholder = "曜日"
        month.placeholder = "月"
        day.placeholder = "日"
        hour.placeholder = "時間"
        minute.placeholder = "分"
        cronText.placeholder = "翻訳されたcron"
        infrared.placeholder = "赤外線を選んでね"
        scheduleName.placeholder = "スケジュール名"
        
        textDesign(day_of_the_week)
        textDesign(month)
        textDesign(day)
        textDesign(hour)
        textDesign(minute)
        textDesign(cronText)
        textDesign(infrared)
        textDesign(scheduleName)

        roundButtonLayout(getButton)
        roundButtonLayout(addButton)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        if(localdata.integerForKey("done") == 1){
            self.selectedName = String(localdata.objectForKey("selectedName")!)
            infrared.text = selectedName!
        }
        schedule_List = [:]
        firstButtonPosition = 90
        getInfrared()
        getScheduleList()
        // print(localdata.objectForKey("selectedName"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let views = scheduleList.subviews
        for subview in views {
            if subview.isKindOfClass(UIButton) {
                subview.removeFromSuperview()
            }
        }
    }
    
    @IBAction func getCronButton(sender: UIButton) {
        getCron()
    }
    @IBAction func postButton(sender: UIButton) {
        postCreateSchedule()
        print("押されたよ")
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

    func switchSet(yPosition:Int){
        let mySwitch = UISwitch(frame:CGRectMake(0,0,10,5))
        mySwitch.transform = CGAffineTransformMakeScale(0.6, 0.6)
        mySwitch.layer.position = CGPoint(x: (self.view.frame.width-50), y:CGFloat(yPosition))
        mySwitch.tintColor = UIColor.mcGrey100()
        mySwitch.onTintColor = UIColor.mcOrange500()
        mySwitch.on = false
        // mySwitch.addTarget(self, action: "onClickmySwitch:", forControlEvents: UIControlEvents.ValueChanged) 
        // SwitchをViewに追加する.
        self.scheduleList.addSubview(mySwitch)
    }

    func buttonSet(buttonName : String , yPosition : Int){
        myButton = UIButton()
        myButton.frame = CGRectMake(0,0,200,20)
        myButton.setTitle(buttonName , forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.whiteColor() , forState: UIControlState.Normal)
        myButton.layer.position = CGPoint(x: (self.view.frame.width/2 - 20), y:CGFloat(yPosition))
        myButton.tag = 1
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        self.scheduleList.addSubview(myButton)
        self.buttonLayout(myButton)
        self.switchSet(yPosition)
    }
    
    func buttonLayout (button : UIButton){
        button.backgroundColor = UIColor.mcOrange100()
        button.layer.cornerRadius = 3
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(1.0 , 1.0)
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

    func successAlert(massage:String){
        let successAlertController: UIAlertController = UIAlertController(title: "Success!!", message: "Created schedule name is \(massage)", preferredStyle: .Alert)
    
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
        }
        successAlertController.addAction(okAction)

        presentViewController(successAlertController, animated: true, completion: nil)
    }
    
    func failedAlert(){
        let failedAlertController: UIAlertController = UIAlertController(title: "Error", message: "Schedule creating is failed..", preferredStyle: .Alert)
    
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
        }
        failedAlertController.addAction(okAction)

        presentViewController(failedAlertController, animated: true, completion: nil)
    }

    func getInfrared(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token = String(localdata.objectForKey("auth_token")!)
        var infrared_name:String?
        var infrared_id:Int?
        print("hogehoge")
        
        Alamofire.request(.GET , "\(urlHead):80/api/v1/ir.json?auth_token=\(auth_token)").response{(request , response , data , error) in 
            do{
                let obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
//                if let meta = obj!["meta"] as? [String : AnyObject]{
//                    if let _ = meta["status"] as? Int{
//                    }
//                }
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
            }catch{
                print("取得できませんでした")
            }
        }
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
                    if let _ = meta["status"] as? Int{
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
                let obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
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
                self.scheduleButton()
            }catch{
                print("getScheduleList Error")                    
            }
        }
    }

   
    func postCreateSchedule(){
        let urlHead:String = localdata.objectForKey("siteURL") as! String
        let auth_token:String = String(localdata.objectForKey("auth_token")!)
        let selectedId = self.infraredList[self.selectedName!]
        let scheduleName = self.scheduleName.text!
        // print(selectedName)
        // print(selectedId)
        var getStatus:Int?
        
        Alamofire.request(.POST , "\(urlHead):80/api/v1/schedule.json",
                        parameters:["auth_token":auth_token,
                                    "ir_id"     :selectedId!,
                                    "name"      :scheduleName,
                                    "cron"      :self.cron!
                                    ]).response{(request , response , data , error) in
            do{
                let obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    if let status = meta["status"] as? Int{
                         // print("postCreateSchedule\(status)")
                         getStatus = status
                    }
                    if let message = meta["message"] as? String{
                        print(message)
                    }
                }
                if let response = obj!["response"] as? [String:AnyObject]{
                    if let schedule = response["schedule"] as? [String:AnyObject]{
                        if let _ = schedule["name"] as? String{
                            // print(name)
                        }
                        if let description = schedule["description"] as? String{
                            print(description)
                        }
                    }
                }
                if(getStatus! == 201){
                    self.successAlert(scheduleName)
                }else{
                    self.failedAlert()
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
