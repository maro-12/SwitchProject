//
//  HomeViewController.swift
//  apiTest
//
//  Created by Naoya Kurahashi on 2015/12/07.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var all: UIButton!
    @IBOutlet weak var televi: UIButton!
    @IBOutlet weak var eacon: UIButton!
    @IBOutlet weak var denki: UIButton!
//    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var addNew: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        all.backgroundColor = UIColor.mcIndigo100()
//        all.layer.cornerRadius = 3
//        all.layer.shadowOpacity = 0.4
//        all.layer.shadowOffset = CGSizeMake(5.0 , 5.0)
        addNew.backgroundColor = UIColor.mcIndigo300()
        addNew.layer.masksToBounds = true
        addNew.layer.cornerRadius = 20
        addNew.layer.shadowOpacity = 0.4
        addNew.layer.shadowOffset = CGSizeMake(2.0 , 2.0)
        
        buttonSet(all)
        buttonSet(televi)
        buttonSet(eacon)
        buttonSet(denki)
//        buttonSet(add)
        // Do any additional setup after loading the view.
    }
    
    func buttonSet (button : UIButton){
        button.backgroundColor = UIColor.mcIndigo300()
        button.layer.cornerRadius = 3
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSizeMake(3.0 , 3.0)
    }

    @IBAction func all(sender: UIButton){
//        self.performSegueWithIdentifier("InfraredIndexSegue", sender: self)
    }
    @IBAction func televi(sender: UIButton) {
//        self.performSegueWithIdentifier("InfraredIndexSegue", sender: self)
    }
    @IBAction func eacon(sender: UIButton) {
//        self.performSegueWithIdentifier("InfraredIndexSegue", sender: self)
    }
    @IBAction func denki(sender: UIButton) {
//        self.performSegueWithIdentifier("InfraredIndexSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
