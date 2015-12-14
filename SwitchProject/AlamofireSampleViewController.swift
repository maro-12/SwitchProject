//
//  AlamofireSampleViewController.swift
//  SwitchProject
//
//  Created by Naoya Kurahashi on 2015/12/14.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireSampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getAuthToken()
        // postSingUp()
        // deleteToken()
        putIr()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var getStatus:Int?
    var getAuth_token:String?

    func getAuthToken(){
        Alamofire.request(.GET,"http://db588d45.ngrok.io:80/api/v1/auth/token.json").response{(request , response , data , error) in
            do{
                
                
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    if let status = meta["status"] as? Int{
                        self.getStatus = status
                    }
                }
                if let response = obj!["response"] as? [String : AnyObject]{
                    if let auth_token = response["auth_token"] as? String{
                        self.getAuth_token = auth_token
                    }
                }
                if(self.getStatus! == 200){
//                    print(self.getAuth_token!)
                }
            }catch{
                print("Error")
            }
        }
    }

    func postSingUp(){
        
        Alamofire.request(.POST , "http://db588d45.ngrok.io:80/api/v1/auth/signup.json" , 
                        parameters:["screen_name":"kurahashi",
                                    "email"      :"kurahashi@gmail.com",
                                    "password"   :"kurahashi",
                                    "auth_token" :"eK-9Wi-Qyy36SKzccizGxQ"] ).response{(request , response , data , error) in
            do{
                print("hogeeee")
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
                if let response = obj!["response"] as? [String : AnyObject]{
                    print("gege")
                    if let auth_token = response["auth_token"] as? String{
                        // self.getAuth_token = auth_token
                        print(auth_token)
                    }
                }

            }catch{
                print("Error")
            }

        }
    }

    func deleteToken(){
        Alamofire.request(.DELETE , "http://db588d45.ngrok.io:80/api/v1/auth/logout.json" , parameters:["auth_token":"RI9djme5k5yRQL__bSQHrg"]).response{(request , response , data , error) in
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
            }catch{
                print("削除できませんでした")
            }
        }
    }

    func putIr(){
        Alamofire.request(.PUT , "http://db588d45.ngrok.io:80/api/v1/ir/rename.json" , 
                        parameters:["auth_token":"FjPOkvnRK5ppSOR--10uWQ",
                                    "name"      :"りもこん",
                                    "ir_id"     :16
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
                if let response = obj!["response"] as? [String : AnyObject]{
                    if let infrared = response["infrared"] as? [String : AnyObject]{
                        if let name = infrared["name"] as? String{
                            print(name)
                        }
                        if let id = infrared["id"] as? Int{
                            print(id)
                        }
                    }
                }
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
