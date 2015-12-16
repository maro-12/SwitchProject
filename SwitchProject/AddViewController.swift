//
//  AddViewController.swift
//  SwitchProject
//
//  Created by Naoya Kurahashi on 2015/12/14.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit
import Alamofire

class AddViewController: UIViewController ,UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        groupName.delegate = self
        groupName.placeholder = "new group name"

        buttonDesign(addInfrared)
        buttonDesign(addGroup)

        textDesign(groupName)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var addInfrared: UIButton!
    @IBOutlet weak var addGroup: UIButton!
    @IBAction func groupAdd(sender: UIButton) {
        postNewGroup()
    }
    @IBAction func back(sender: UIBarButtonItem) {
        let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier( "TabBarView" )
        self.presentViewController( targetViewController, animated: true, completion: nil)
    }
    let localdata = NSUserDefaults.standardUserDefaults()
    
    func buttonDesign(button : UIButton){
//        let borderWidth :CGFloat = 1.0
        button.backgroundColor = UIColor.mcOrange500()
        button.layer.cornerRadius = 9
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(1.0 , 3.0)
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

    func inputAlert() {
        // var inputTextField: UITextField?
        let name = self.groupName.text!
        let alertController: UIAlertController = UIAlertController(title: "グループを作成しました", message: "group name is \(name)", preferredStyle: .Alert)
        let doneAction: UIAlertAction = UIAlertAction(title: "Done", style: .Default) { action -> Void in
            print("Done")
        }
        alertController.addAction(doneAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func postNewGroup(){
        let urlHead:String = self.localdata.objectForKey("siteURL") as! String
        let auth_token = String(self.localdata.objectForKey("auth_token")!)
        var getStatus:Int?
        let name:String = groupName.text!
        
        Alamofire.request(.POST ,  "\(urlHead):80/api/v1/group.json" , 
                        parameters:["auth_token":"\(auth_token)",
                                    "name"      :"\(name)"
                        ]).response{( request , response , data , error) in
            do{
                var obj : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let meta = obj!["meta"] as? [String : AnyObject]{
                    if let status = meta["status"] as? Int{
                        // print(status)
                        getStatus = status
                    }
                    if let message = meta["message"] as? String{
                        // print(message)
                    }
                }
                if(getStatus! == 201){
                    self.inputAlert()
                    self.groupName.text = nil
                    self.groupName.placeholder = "new group name"
                }else{
                    print("作成できませんでした")
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
