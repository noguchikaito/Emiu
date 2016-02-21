//
//  ContactDetailTable.swift
//  Emiu
//
//  Created by Triomphe on 2016/02/21.
//  Copyright © 2016年 noguchikaito. All rights reserved.
//

import Foundation
import UIKit

class ContactDetailTable: UITableViewController {
    
    var contactTableView = UITableView()
    
    var record = ContactRecordAccessor()
    
    var famityName = String()
    var givenName = String()
    var phoneticFamilyName = String()
    var phoneticGivenName = String()
    var origation = String()
    var organization = String()
    var phoneNumber = String()
    var emailAddress = String()
    var birthday = String()
    
    let titleLbFrame = CGRect(x: 20, y: 0, width: 200, height: 44)
    let dataLbFrame = CGRect(x: 100, y: 0, width: 200, height: 44)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        if(section == 4){
            return record.phoneNumber.count > 0 ? record.phoneNumber.count : 1;
        }else if(section == 5){
            return record.emailAddress.count > 0 ? record.emailAddress.count : 1;
        }
        return 1;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        if(indexPath.section == 0){
            cell.contentView.addSubview(createLabel(titleLbFrame, text: "名前"))
            cell.contentView.addSubview(createLabel(dataLbFrame, text: record.familyName + record.givenName))
        }else if(indexPath.section == 1){
            cell.contentView.addSubview(createLabel(titleLbFrame, text: "よみ"))
            cell.contentView.addSubview(createLabel(dataLbFrame, text: record.phoneticFamilyName + record.phoneticGivenName));
        }else if(indexPath.section == 2){
            cell.contentView.addSubview(createLabel(titleLbFrame, text: "仕事"))
            cell.contentView.addSubview(createLabel(dataLbFrame, text: record.origiation));
        }else if(indexPath.section == 3){
            cell.contentView.addSubview(createLabel(titleLbFrame, text: "誕生日"))
            cell.contentView.addSubview(createLabel(dataLbFrame, text: record.birthday));
        }else if(indexPath.section == 4){
            cell.contentView.addSubview(createLabel(titleLbFrame, text: "電話番号"))
            if(indexPath.row < record.phoneNumber.count){
                cell.contentView.addSubview(createLabel(dataLbFrame, text: record.phoneNumber[indexPath.row]));
            }
        }else if(indexPath.section == 5){
            cell.contentView.addSubview(createLabel(titleLbFrame, text: "Email"))
            if(indexPath.row < record.emailAddress.count){
                cell.contentView.addSubview(createLabel(dataLbFrame, text: record.emailAddress[indexPath.row]));
            }
        }else if(indexPath.section == 6){
            let title = record.contactId.isEmpty ? "連絡先をリンクする" : "連絡先のリンク済み";
            let label = createLabel(titleLbFrame, text: title)
            label.textColor = UIColor.redColor()
            cell.contentView.addSubview(label)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        if(indexPath.section == 6){
            let ac = UIAlertController(title: "連絡帳", message: "", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                print("Cancel button tapped.")
            }
            
            let linkAction = UIAlertAction(title: "連絡先をリンクする", style: .Default) { (action) -> Void in
                let contactController = self.storyboard!.instantiateViewControllerWithIdentifier("ContactViewController") as! ContactViewController
                contactController.userId = self.record.userId;
                self.presentViewController(contactController, animated: true, completion: nil)
            }
            ac.addAction(cancelAction)
            ac.addAction(linkAction)
            presentViewController(ac, animated: true, completion: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
