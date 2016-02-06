//
//  ProfileViewController.swift
//  Emiu
//
//  Created by Triomphe on 2016/01/30.
//  Copyright © 2016年 noguchikaito. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class ProfileViewController : UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var scrollSize = NSInteger()
    var nameArray = NSMutableArray()
    var phoneArray = NSMutableArray()
    var emailArray = NSMutableArray()
    
    let tfFrame = CGRectMake(50, 10, 200, 30)
    
    // textField
    var tfFamityName = UITextField()
    var tfGivenName = UITextField()
    var tfPhoneticFamilyName = UITextField()
    var tfPhoneticGivenName = UITextField()
    var tfOrigation = UITextField()
    var tfOrganization = UITextField()
    var tfPhoneNumber = UITextField()
    var tfEmailAddress = UITextField()
    var tfBirthday = UITextField()
    // 編集中のTextFieldを受け取ってキーボードを閉じる
    var tfEditing = UITextField()

    // label
    var addPhoneLabel = UILabel()
    var addEmailLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.setEditing(true, animated: true)
        profileTableView.allowsSelectionDuringEditing = true
        
        profileImageView.backgroundColor = UIColor.lightGrayColor()
        profileImageView.layer.cornerRadius = 60.0
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        // textField
        // 姓
        tfFamityName = self.createTextField(tfFrame,text:"",placeholder: "姓")
        tfFamityName.tag = 1
        nameArray.addObject(tfFamityName)
        // 名
        tfGivenName = self.createTextField(tfFrame,text:"",placeholder: "名")
        tfGivenName.tag = 2
        nameArray.addObject(tfGivenName)
        // 姓よみ
        tfPhoneticFamilyName = self.createTextField(tfFrame,text:"",placeholder: "姓よみ")
        tfPhoneticFamilyName.tag = 3
        nameArray.addObject(tfPhoneticFamilyName)
        // 名よみ
        tfPhoneticGivenName = self.createTextField(tfFrame,text:"",placeholder: "名よみ")
        tfPhoneticGivenName.tag = 4

        nameArray.addObject(tfPhoneticGivenName)
         // 職業
        tfOrganization = self.createTextField(tfFrame,text:"",placeholder: "会社")
        // 誕生日
        tfBirthday = self.createTextField(tfFrame,text:"",placeholder: "誕生日")
        // UILabel
        // 電話番号を追加
        addPhoneLabel = UILabel.init(frame: CGRectMake(50, 10, self.view.layer.frame.size.width - 60, 30))
        addPhoneLabel.text = "電話番号を追加"
        
        // メールを追加
        addEmailLabel = UILabel.init(frame: CGRectMake(50, 10, self.view.layer.frame.size.width - 60, 30))
        addEmailLabel.text = "メールを追加"
        
        ServerMessage.selectUserData({(dataArray) in
            dispatch_async(dispatch_get_main_queue(), {
                self.setUserDataBySql(dataArray)
                self.profileTableView.reloadData()
            })
        })
    }
    
    func setUserDataBySql(dataArray:NSArray){
        print(dataArray)
        var cutArray = NSArray()
        var typeStr = String()
        var typeInt = Int()
        var text = String()
        print(dataArray);
        for var data in dataArray{
            cutArray = StrUtil.transformStrByKeyword(data as! String, key: "_")
            if(cutArray.count > 1){
                typeStr = cutArray.objectAtIndex(0) as! String
                typeInt = Int(typeStr)!
                text = cutArray.objectAtIndex(1) as! String
                switch(typeInt){
                case 1:
                    tfFamityName.text = text
                    break;
                case 2:
                    tfGivenName.text = text
                    break;
                case 3:
                    tfPhoneticFamilyName.text = text
                    break;
                case 4:
                    tfPhoneticGivenName.text = text
                    break;
                case 5:
                    tfOrganization.text = text
                    break;
                case 6:
                    tfBirthday.text = text
                    break;
                case 7:
                    phoneArray.addObject(createTextField(tfFrame,text:text,placeholder:"電話番号"))
                    break;
                case 8:
                    emailArray.addObject(createTextField(tfFrame,text:text,placeholder: "メール"))
                    break;
                default:
                        break;
                }
            }
            print(data)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        
        var row = 0;
        switch section {
        case 0:
            row = 4
        case 1:
            row = 1
        case 2:
            row = 1
        case 3:
            row = phoneArray.count + 1
        case 4:
            row = emailArray.count + 1
        default:
            break
            
        }
        return row;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        if(indexPath.section == 0){
            // 名前情報
            cell.addSubview(nameArray.objectAtIndex(indexPath.row) as! UITextField)
        }else if(indexPath.section == 1){
            // 会社
            cell.addSubview(tfOrganization)
        }else if(indexPath.section == 2){
            // 誕生日
            cell.addSubview(tfBirthday)
        }else if(indexPath.section == 3){
            // 電話番号
            if(indexPath.row < phoneArray.count){
                tfPhoneNumber = phoneArray.objectAtIndex(indexPath.row) as! UITextField
                tfPhoneNumber.keyboardType = UIKeyboardType.NumberPad
                cell.addSubview(tfPhoneNumber)
            }else{
                cell.addSubview(addPhoneLabel)
            }
        }else if(indexPath.section == 4){
            // Email
            if(indexPath.row < emailArray.count){
                tfEmailAddress = emailArray.objectAtIndex(indexPath.row) as! UITextField
                cell.addSubview(tfEmailAddress)
            }else{
                cell.addSubview(addEmailLabel)
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // cellの追加
        if(editingStyle == UITableViewCellEditingStyle.Insert){
            self.insertCell(indexPath)
        }else if(editingStyle == UITableViewCellEditingStyle.Delete){
            self.deleteCell(indexPath)
        }
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        let isInsertPhone = indexPath.section == 3 && indexPath.row == phoneArray.count
        let isInsertEmail = indexPath.section == 4 && indexPath.row == emailArray.count
        if(indexPath.section == 3 || indexPath.section == 4){
            if(isInsertPhone || isInsertEmail){
                return UITableViewCellEditingStyle.Insert
            }else{
                return UITableViewCellEditingStyle.Delete
            }
        }
        return UITableViewCellEditingStyle.None
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        tfEditing = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        tfEditing.resignFirstResponder()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        tfEditing.resignFirstResponder()
    }
    
    
    func insertCell(indexPath:NSIndexPath){
        if(indexPath.section == 3){
            tfPhoneNumber = createTextField(tfFrame,text:"",placeholder: "電話番号")
            phoneArray.addObject(tfPhoneNumber)
            profileTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Top)
        }else if(indexPath.section == 4){
            emailArray.addObject(createTextField(tfFrame,text:"",placeholder: "メール"))
            profileTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Top)
        }
    }
    
    func deleteCell(indexPath:NSIndexPath){
        if(indexPath.section == 3){
            phoneArray.removeObjectAtIndex(indexPath.row)
            profileTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
        }else if(indexPath.section == 4){
            emailArray.removeObjectAtIndex(indexPath.row)
            profileTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
        }
    }
    
    @IBAction func saveBtnClick(sender: AnyObject) {

        var tf = UITextField()
        for(var i=0; i<nameArray.count; i++){
            tf = nameArray.objectAtIndex(i) as! UITextField
            if((tf.text) != nil){
                ServerMessage.insertUserData(tf.tag, data: tf.text!)
            }
        }
        
        if(tfOrganization.text != nil){
            ServerMessage.insertUserData(5, data: tfOrganization.text!)
        }
        
        if(tfBirthday.text != nil){
            ServerMessage.insertUserData(6, data: tfBirthday.text!)
        }
        
        for(var j=0; j<phoneArray.count; j++){
            tf = phoneArray.objectAtIndex(j) as! UITextField
            if((tf.text) != nil){
                ServerMessage.insertUserData(7, data: tf.text!)
            }
        }
        
        for(var k=0; k<emailArray.count; k++){
            tf = emailArray.objectAtIndex(k) as! UITextField
            if((tf.text) != nil){
                ServerMessage.insertUserData(8, data: tf.text!)
            }
        }
    }
    
    func createTextField(frame:CGRect,text:String,placeholder:String) -> UITextField{
        let textField = UITextField.init(frame: frame)
        textField.delegate = self;
        textField.placeholder = placeholder
        textField.text = text
        return textField
    }
}
