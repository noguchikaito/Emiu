//
//  ContactUtil.swift
//  Emiu
//
//  Created by Triomphe on 2016/01/30.
//  Copyright © 2016年 noguchikaito. All rights reserved.
//

import Foundation
import UIKit
import Contacts


class ContactUtil : NSObject {
    
    static var store = CNContactStore()
    
    // コンタクトID -> コンタクト
    static func getContactByID(contactId:String) -> CNContact{
        var contact = CNContact()

        let keysToFetch = [
            CNContactUrlAddressesKey,
            CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
            CNContactPhoneticFamilyNameKey,
            CNContactPhoneticGivenNameKey,
            CNContactImageDataKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey
        ]
        
        do {
            contact = try store.unifiedContactWithIdentifier(contactId, keysToFetch: keysToFetch)
        }
        catch let error as NSError {
            print("[ERROR] by getContactByID : " + error.localizedDescription)
        }
        return contact
    }
    
    // コンタクトID -> コンタクトアクセサ
    static func getContactAccessorByID(contactId:String) -> ContactRecordAccessor{
        var contact = CNContact()
        let record = ContactRecordAccessor()
        var phoneNumbers = [String]()
        var emailAddress = [String]()
        
        let keysToFetch = [
            CNContactUrlAddressesKey,
            CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
            CNContactPhoneticFamilyNameKey,
            CNContactPhoneticGivenNameKey,
            CNContactImageDataKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey
        ]
        
        do {
            contact = try store.unifiedContactWithIdentifier(contactId, keysToFetch: keysToFetch)
            
            for phone in contact.phoneNumbers{
                let phoneNumber = phone.value as! CNPhoneNumber
                phoneNumbers.append(phoneNumber.stringValue)
            }
            
            for email in contact.emailAddresses{
                emailAddress.append(email.value as! String)
            }
            
            record.initWithData("",
                contactId: contactId,
                dateTime: "",
                familyName: contact.familyName,
                givenName: contact.givenName,
                phoneticFamilyName: contact.phoneticFamilyName,
                phoneticGivenName: contact.phoneticGivenName,
                phoneNumber: phoneNumbers,
                emailAddress: emailAddress,
                origiation: contact.organizationName,
                birthday: ""
            )
        }
        catch let error as NSError {
            print("[ERROR] by getContactByID : " + error.localizedDescription)
        }
        return record
    }
    
    static func getMyContact(){
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),CNContactPhoneNumbersKey]
        let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch)
        var contacts = [CNContact]()
        CNContact.localizedStringForKey(CNLabelPhoneNumberiPhone)
        fetchRequest.mutableObjects = false
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = .UserDefault
        
        do {
            try store.enumerateContactsWithFetchRequest(fetchRequest, usingBlock: { (let contact, let stop) -> Void in
                contacts.append(contact)
            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    static func getAllContactRecord() -> [ContactRecordAccessor]{
        var contactRecords = [ContactRecordAccessor]()
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneticFamilyNameKey,CNContactPhoneticGivenNameKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactOrganizationNameKey,CNContactBirthdayKey,CNContactPhoneNumbersKey]
        let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch)
        CNContact.localizedStringForKey(CNLabelPhoneNumberiPhone)
        fetchRequest.mutableObjects = false
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = .UserDefault
        do {
            try store.enumerateContactsWithFetchRequest(fetchRequest, usingBlock: { (let contact, let stop) -> Void in
                
                let person = ContactRecordAccessor()
                person.initWithContactData("",contactId:contact.identifier,familyName: contact.familyName, givenName: contact.givenName, phoneticFamilyName: contact.phoneticFamilyName, phoneticGivenName: contact.phoneticGivenName, phoneNumbers: contact.phoneNumbers, emailAddress: contact.emailAddresses , origiation: contact.organizationName, birthday: contact.birthday)
                contactRecords.append(person)
            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return contactRecords
    }
    
    /**
     * 連絡先の新規作成
     */
    static func createContactByContact(contact:CNContact) -> Bool{
        let createContact:CNMutableContact = contact.mutableCopy() as! CNMutableContact
        var result = false
        let addRequest = CNSaveRequest()
        addRequest.addContact(createContact,toContainerWithIdentifier: nil)
        do {
            result = true;
            try store.executeSaveRequest(addRequest)
        }catch let error as NSError {
            result = true;
            print("[ERROR] by getContactByID : " + error.localizedDescription)
        }
        return result
    }
    
    /**
     * 連絡先の更新
     */
    static func saveContactByContact(record:ContactRecordAccessor) -> String{
        var contact = CNContact()
        contact = getContactByID(record.contactId)
        
        if(contact.identifier.isEmpty){
            return "連絡先が存在しません"
        }
        
        let updatedContact:CNMutableContact = contact.mutableCopy() as! CNMutableContact
        let saveRequest = CNSaveRequest()

        // データの追加
        updatedContact.familyName = record.familyName
        updatedContact.givenName = record.givenName
        updatedContact.phoneticFamilyName = record.phoneticFamilyName
        updatedContact.phoneticGivenName = record.phoneticGivenName
        updatedContact.organizationName = record.origiation
        
        /*
        let birthday = NSDateComponents()
        birthday.day = 1
        birthday.month = 4
        birthday.year = 1988  // You can omit the year value for a yearless birthday
        contact.birthday = birthday
        */
        
        updatedContact.phoneNumbers.removeAll()
        for phone in record.phoneNumber{
            let newPhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: phone))
            updatedContact.phoneNumbers.append(newPhone)
        }
        
        updatedContact.emailAddresses.removeAll()
        for email in record.emailAddress{
            let newEmail = CNLabeledValue(label: CNLabelHome, value: email)
            updatedContact.emailAddresses.append(newEmail)
        }
        
        saveRequest.updateContact(updatedContact)
        
        do {
            try store.executeSaveRequest(saveRequest)
        }catch let error as NSError {
            return "同期中にエラーが発生しました : " + error.localizedDescription
        }
        return "同期が完了しました"
    }
}