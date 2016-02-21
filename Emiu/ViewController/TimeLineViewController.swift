//
//  TimeLineViewController.swift
//  Emiu
//
//  Created by Triomphe on 2016/02/21.
//  Copyright © 2016年 noguchikaito. All rights reserved.
//

import Foundation
import UIKit

class TimeLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var timeLineTableView: UITableView!
    var timeLineRecords = [TimeLineRecordAccessor]()
    var appDelegate  = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        timeLineRecords = appDelegate.timeLineRecords
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return timeLineRecords.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        let contactData = timeLineRecords[indexPath.row] as TimeLineRecordAccessor
        let date = StrUtil.getJpTimeByYMD(contactData.dateTime)
        cell.textLabel?.text = "[更新]" + date + " " + contactData.fullName;
        
        print(cell.textLabel?.text)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
    }
}