//
//  SettingViewController.swift
//  apiTest
//
//  Created by Naoya Kurahashi on 2015/12/07.
//  Copyright © 2015年 Naoya Kurahashi. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    let cellNum = 10
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView : UITableView , numberOfRowsInSection section :Int) -> Int{
        return self.cellNum
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "settingCell")
        cell.textLabel?.text = "設定\(indexPath.row))"
        return cell
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
