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
    
    static func getMyContact(){
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),CNContactPhoneNumbersKey] //CNContactIdentifierKey
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
    static func saveContactByContact(contact:CNContact) -> Bool{
        let updatedContact:CNMutableContact = contact.mutableCopy() as! CNMutableContact
        let saveRequest = CNSaveRequest()
        var result = false;
        saveRequest.updateContact(updatedContact)
        do {
            result = true;
            try store.executeSaveRequest(saveRequest)
        }catch let error as NSError {
            result = true;
            print("[ERROR] by getContactByID : " + error.localizedDescription)
        }
        return result
    }
}