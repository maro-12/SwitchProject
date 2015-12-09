//
//  UrlErrorViewController.swift
//  apiTest
//
//  Created by Naoya Kurahashi on 2015/12/10.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit

class UrlErrorViewController: UIViewController , UITextFieldDelegate {
    
    let localdata = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newSiteUrl.delegate = self
        newSiteUrl.placeholder = "http://example.ngroc.io"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var newSiteUrl: UITextField!
    @IBAction func setURL(sender: UIButton) {
        setURL()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func setURL() {
        let newUrlHead:String = self.newSiteUrl.text!
        
        let siteURL = NSURL(string: "\(newUrlHead):80/api/v1/auth/token.json")
//        let auth_token : String = self.localdata.objectForKey("auth") as! String
        //        let status:String = localdata.objectForKey("status") as! String
        let req = NSMutableURLRequest(URL:siteURL!)
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
        
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, response, error) -> Void in
            do{
                _ = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
                self.localdata.setObject(self.newSiteUrl.text , forKey:"siteURL")
                self.performSegueWithIdentifier("setURLSegue", sender: self)
            }catch{
//                self.performSegueWithIdentifier("siteURLErrorSegue", sender: self)
//                print(auth_token)
                self.newSiteUrl.text = "もう一度入力してください"
            }
        })
        task.resume()
//        print("hello")
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
