//
//  FriendListViewController.swift
//  Emiu
//
//  Created by Triomphe on 2016/02/07.
//  Copyright © 2016年 noguchikaito. All rights reserved.
//

import Foundation
import UIKit

class FriendListViewController : UIViewController,UITableViewDelegate,UITableViewDataSource {

    var friendRecords = [ContactRecordAccessor]()
    var selectRow = Int()
    var fevc = FriendDetailViewController()
    
    @IBOutlet weak var friendListTableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.friendListController = self;
        if(ServerMessage.loginAccount("123", pass: "123")){
            print("OK")
        }else{
            print("NO")
        }
    
        ServerMessage.selectFriendData({(friendArray) in
            dispatch_async(dispatch_get_main_queue(), {
                self.friendListTableView.reloadData()
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func setFriendRecords(records:[ContactRecordAccessor]){
        self.friendRecords = records
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return friendRecords.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        /*
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath);
        */
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath);
        //cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell");
        
        let friendData = friendRecords[indexPath.row] as ContactRecordAccessor
        print(friendData.userId)
        
        cell.textLabel?.text = friendData.familyName + friendData.givenName;
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        selectRow = indexPath.row;
        fevc = self.storyboard?.instantiateViewControllerWithIdentifier("FriendDetailViewController") as! FriendDetailViewController
        fevc.friendRecord = friendRecords[selectRow] as ContactRecordAccessor;
        self.navigationController?.pushViewController(fevc, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        ServerMessage.selectFriendData({(friendArray) in
            dispatch_async(dispatch_get_main_queue(), {
                self.friendListTableView.reloadData()
            })
        })
    }
}
