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
   
    let localdata = NSUserDefaults.standardUserDefaults()

    var cron:String?

    @IBOutlet weak var day_of_the_week: UITextField!
    @IBOutlet weak var month: UITextField!
    @IBOutlet weak var day: UITextField!
    @IBOutlet weak var hour: UITextField!
    @IBOutlet weak var minute: UITextField!
    
    @IBOutlet weak var scheduleList: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func button(sender: UIButton) {
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
        // var week_value:String?
        // var month_value:String?
        // var day_value:String?
        // var hour_value:String?
        // var minute_value:String?
        nilCheck(day_of_the_week)
        nilCheck(month)
        nilCheck(day)
        nilCheck(hour)
        nilCheck(minute)
        // week_value = day_of_the_week.text
        // month_value = month.text
        // day_value = day.text
        // hour_value = hour.text
        // minute_value = minute.text   
        self.cron = "\(minute.text!) \(hour.text!) \(day.text!) \(month.text!) \(day_of_the_week.text!)"
        print(self.cron)
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
                         print("getGroupのステータスは\(status)")
                    }
                }
                if let response = obj!["response"] as? [String:AnyObject]{
                    if let translation = response["translation"] as? String{
                        print(translation)
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
        
        Alamofire.request(.POST , "\(urlHead):80/api/v1/schedule.json",
            parameters:["auth_token":auth_token]).response{(request , response , data , error ) in
                
                do{
                    var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                }catch{
                    
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
                        print("postCreateSchedule\(status)")
                    }
                    if let message = meta["message"] as? String{
                        print(message)
                    }
                }
                if let response = obj!["response"] as? [String:AnyObject]{
                    if let schedule = response["schedule"] as? [String:AnyObject]{
                        if let name = schedule["name"] as? String{
                            print(name)
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
