//
//  ContactRecordAccessor.swift
//  Emiu
//
//  Created by Triomphe on 2016/02/14.
//  Copyright © 2016年 noguchikaito. All rights reserved.
//

import Foundation
import Contacts

class ContactRecordAccessor {
    
    var userId = String();
    var contactId = String();
    var dateTime = String();
    var familyName = String();
    var givenName = String();
    var phoneticFamilyName = String();
    var phoneticGivenName = String();
    var phoneNumber = [String]();
    var emailAddress = [String]();
    var origiation = String();
    var birthday = String();
    
    func initWithData(userId:String,contactId:String,dateTime:String,familyName:String,givenName:String,phoneticFamilyName:String,phoneticGivenName:String,phoneNumber:[String],emailAddress:[String],origiation:String,birthday:String){
        self.userId = userId;
        self.contactId = contactId;
        self.dateTime = dateTime;
        self.familyName = familyName;
        self.givenName = givenName;
        self.phoneticFamilyName = phoneticFamilyName;
        self.phoneticGivenName = phoneticGivenName;
        self.phoneNumber = phoneNumber;
        self.emailAddress = emailAddress;
        self.origiation = origiation;
        self.birthday = birthday;
    }
    
    func initWithContactData(userId:String,contactId:String,familyName:String,givenName:String,phoneticFamilyName:String,phoneticGivenName:String,phoneNumbers:[CNLabeledValue],emailAddress:[CNLabeledValue],origiation:String,birthday:NSDateComponents?){
        self.userId = userId;
        self.contactId = contactId;
        self.familyName = familyName;
        self.givenName = givenName;
        self.phoneticFamilyName = phoneticFamilyName;
        self.phoneticGivenName = phoneticGivenName;
        for number in phoneNumbers {
            let phoneNumber = number.value as! CNPhoneNumber
            self.phoneNumber.append(phoneNumber.stringValue)
        }
        for email in emailAddress {
            self.emailAddress.append(email.value as! String)
        }
        self.origiation = origiation;
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if(birthday?.day != nil){
            self.birthday = formatter.stringFromDate(birthday!.date!);
        }else{
            self.birthday = ""
        }
    }
    
}

