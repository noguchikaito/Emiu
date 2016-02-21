//
//  FriendDetailViewController.swift
//  Emiu
//
//  Created by Triomphe on 2016/02/14.
//  Copyright © 2016年 noguchikaito. All rights reserved.
//

import Foundation
import UIKit

class FriendDetailViewController : UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    @IBOutlet weak var pageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    var emiuDataTable = UITableView()
    var nativeDataTable = UITableView()
    
    var friendRecord = ContactRecordAccessor()
    var nativeRecord = ContactRecordAccessor()
    
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
    
    var scrollX = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageScrollView.pagingEnabled = true
        pageScrollView.contentSize = CGSizeMake(pageScrollView.frame.width * 2,0);
        pageScrollView.showsHorizontalScrollIndicator = false
        pageScrollView.showsVerticalScrollIndicator = false
        pageScrollView.scrollEnabled = true

        nativeDataTable.delegate = self
        nativeDataTable.dataSource = self
        nativeDataTable.frame = CGRectMake(pageScrollView.frame.size.width, 0, pageScrollView.frame.size.width, pageScrollView.frame.size.height)
        nativeDataTable.tag = 2
        
        emiuDataTable.delegate = self
        emiuDataTable.dataSource = self
        emiuDataTable.frame = pageScrollView.frame
        emiuDataTable.tag = 1
        
        nativeRecord = ContactUtil.getContactAccessorByID(friendRecord.contactId)
        pageScrollView.addSubview(emiuDataTable)
        pageScrollView.addSubview(nativeDataTable)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        if(tableView.tag == 1){
            if(section == 4){
                return friendRecord.phoneNumber.count;
            }else if(section == 5){
                return friendRecord.emailAddress.count;
            }
        }else{
            if(section == 4){
                return nativeRecord.phoneNumber.count;
            }else if(section == 5){
                return nativeRecord.emailAddress.count;
            }
        }
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        if(tableView.tag == 1){
            if(indexPath.section == 0){
                cell.contentView.addSubview(createLabel(titleLbFrame, text: "名前"))
                cell.contentView.addSubview(createLabel(dataLbFrame, text: friendRecord.familyName + friendRecord.givenName))
            }else if(indexPath.section == 1){
                cell.contentView.addSubview(createLabel(titleLbFrame, text: "よみ"))
                cell.contentView.addSubview(createLabel(dataLbFrame, text: friendRecord.phoneticFamilyName + friendRecord.phoneticGivenName));
            }else if(indexPath.section == 2){
                cell.contentView.addSubview(createLabel(titleLbFrame, text: "仕事"))
                cell.contentView.addSubview(createLabel(dataLbFrame, text: friendRecord.origiation));
            }else if(indexPath.section == 3){
                cell.contentView.addSubview(createLabel(titleLbFrame, text: "誕生日"))
                cell.contentView.addSubview(createLabel(dataLbFrame, text: friendRecord.birthday));
            }else if(indexPath.section == 4){
                cell.contentView.addSubview(createLabel(titleLbFrame, text: "電話番号"))
                cell.contentView.addSubview(createLabel(dataLbFrame, text: friendRecord.phoneNumber[indexPath.row]));
            }else if(indexPath.section == 5){
                cell.contentView.addSubview(createLabel(titleLbFrame, text: "Email"))
                cell.contentView.addSubview(createLabel(dataLbFrame, text: friendRecord.emailAddress[indexPath.row]));
            }else if(indexPath.section == 6){
                let title = friendRecord.contactId.isEmpty ? "連絡先をリンクする" : "連絡先のリンク済み";
                let label = createLabel(titleLbFrame, text: title)
                label.textColor = UIColor.redColor()
                cell.contentView.addSubview(label)
            }
        }else{
            if(indexPath.section == 0){
                cell.contentView.addSubview(createLabel(titleLbFrame, text: "名前"))
                cell.contentView.addSubview(createLabel(dataLbFrame, text: nativeRecord.familyName + nativeRecord.givenName))
            }else if(indexPath.section == 1){
                cell.contentView.addSubview(createLabel(titleLbFrame, text: "よみ"))
                cell.contentView.addSubview(createLabel(dataLbFrame, text: nativeRecord.phoneticFamilyName + nativeRecord.phoneticGivenName));
            }else if(indexPath.section == 2){
                cell.contentView.addSubview(createLabel(titleLbFrame, text: "仕事"))
                cell.contentView.addSubview(createLabel(dataLbFrame, text: nativeRecord.origiation));
            }else if(indexPath.section == 3){
                cell.contentView.addSubview(createLabel(titleLbFrame, text: "誕生日"))
                cell.contentView.addSubview(createLabel(dataLbFrame, text: nativeRecord.birthday));
            }else if(indexPath.section == 4){
                cell.contentView.addSubview(createLabel(titleLbFrame, text: "電話番号"))
                cell.contentView.addSubview(createLabel(dataLbFrame, text: nativeRecord.phoneNumber[indexPath.row]));
            }else if(indexPath.section == 5){
                cell.contentView.addSubview(createLabel(titleLbFrame, text: "Email"))
                cell.contentView.addSubview(createLabel(dataLbFrame, text: nativeRecord.emailAddress[indexPath.row]));
            }else if(indexPath.section == 6){
                let title = nativeRecord.contactId.isEmpty ? "連絡先をリンクする" : "連絡先のリンク済み";
                let label = createLabel(titleLbFrame, text: title)
                label.textColor = UIColor.redColor()
                cell.contentView.addSubview(label)
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        if(indexPath.section == 6){
            
            let ac = UIAlertController(title: "連絡帳", message: "", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                print("Cancel button tapped.")
            }
            
            let linkAction = UIAlertAction(title: "連絡先をリンクする", style: .Default) { (action) -> Void in
                let contactController = self.storyboard!.instantiateViewControllerWithIdentifier("ContactViewController") as! ContactViewController
                contactController.userId = self.friendRecord.userId;
                self.presentViewController(contactController, animated: true, completion: nil)
            }
            ac.addAction(cancelAction)
            ac.addAction(linkAction)
            presentViewController(ac, animated: true, completion: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if(scrollX != scrollView.contentOffset.x){
            print(scrollView.contentOffset.x / pageScrollView.frame.size.width)
            if(scrollView.contentOffset.x / pageScrollView.frame.size.width < 0.9){
                self.title = "Emiu データ"
                pageControl.currentPage = 0
            }else{
                self.title = "連絡帳データ"
                pageControl.currentPage = 1
            }
        }
    }
    
    /**
     * Label作成
     */
    func createLabel(frame:CGRect,text:String) -> UILabel{
        let label = UILabel.init(frame: frame)
        label.text = text
        return label
    }
    
    @IBAction func synchroBtnAction(sender: AnyObject) {
        let resultText = ContactUtil.saveContactByContact(friendRecord)
        nativeRecord = ContactUtil.getContactAccessorByID(friendRecord.contactId)
        nativeDataTable.reloadData()
        print(resultText)
    }
    
    @IBAction func pageChangeAction(sender: AnyObject) {
        
    }
}