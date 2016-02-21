//
//  ContactViewController.swift
//  Emiu
//
//  Created by Triomphe on 2016/01/30.
//  Copyright © 2016年 noguchikaito. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class ContactViewController : UIViewController,UITableViewDelegate,UITableViewDataSource {

    var userId = String()
    var allContacts = [ContactRecordAccessor]()
    @IBOutlet weak var contactTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTableView.delegate = self;
        contactTableView.dataSource = self;
        allContacts = ContactUtil.getAllContactRecord()
        print(allContacts)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return allContacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        let contactData = allContacts[indexPath.row] as ContactRecordAccessor

        cell.textLabel?.text = contactData.familyName + contactData.givenName;
        
        print(cell.textLabel?.text)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let contactData = allContacts[indexPath.row] as ContactRecordAccessor
        print("userID = " + userId)
        print("contactId = " + contactData.contactId)
        ServerMessage.updateFriendData(userId, contactId: contactData.contactId)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
        
    @IBAction func backBtnAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}