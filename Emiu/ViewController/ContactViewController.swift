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
    
    @IBOutlet weak var contactTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTableView.delegate = self;
        contactTableView.dataSource = self;
        if(ServerMessage.loginAccount("123", pass: "123")){
            print("OK")
        }else{
            print("NO")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {

        var row = 0;
        switch section {
            case 0:
                // name
                row = 4
            case 1:
                // tel
                row = 4
            case 2:
                // email
                row = 4
            case 3:
                // etc
                row = 4
            default:
                break
            
        }
        return row;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = "";
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
       
    }
    
}