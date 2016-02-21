//
//  XmlParser.swift
//  Emiu
//
//  Created by Triomphe on 2016/01/31.
//  Copyright © 2016年 noguchikaito. All rights reserved.
//

import Foundation
import UIKit

class XmlParser : NSObject,NSXMLParserDelegate {
    
    enum XmlKey : String {
        case ITEMS = "items"
        case PARSON = "parson"
        case DATA = "data"
        case ID = "id"
        case CONTACTID = "contactId"
        case DATETIME = "dateTime"
        case FAMILY_NAME = "type_1"
        case GIVEN_NAME = "type_2"
        case PHONETIC_FAMILY_NAME = "type_3"
        case PHONETIC_GIVEN_NAME = "type_4"
        case ORIGATION = "type_5"
        case BIRTHDY = "type_6"
        case PHONE_NUMBER = "type_7"
        case EMAIL_ADDRESS = "type_8"
    }
    
    var parser = NSXMLParser()

    var id = String();
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
    
    var records = [ContactRecordAccessor]()
    var timeLineRecords = [TimeLineRecordAccessor]()
    
    var dataMuStr = NSMutableString()
    
    func initParse(data:NSData) {
        parser = NSXMLParser(data: data)
        parser.delegate = self;
        parser.parse()
        records.removeAll()
        phoneNumber.removeAll()
        emailAddress.removeAll()
        print(data)
    }

    // 要素が見つかった場合
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {

    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        dataMuStr.appendString(string);
    }
    
    // 要素が終わった場合
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        print("------------------")
        print(elementName)
        print("------------------")

        switch(elementName){
            
        case XmlKey.ITEMS.rawValue:
            break;
        case XmlKey.PARSON.rawValue:
            let contactAccessor = ContactRecordAccessor()
            contactAccessor.initWithData(
                id,
                contactId: contactId,
                dateTime:  dateTime,
                familyName:familyName,
                givenName: givenName,
                phoneticFamilyName: phoneticFamilyName,
                phoneticGivenName: phoneticGivenName,
                phoneNumber: phoneNumber,
                emailAddress: emailAddress,
                origiation: origiation,
                birthday: birthday
            )
            
            let timeLineAccount = TimeLineRecordAccessor()
            timeLineAccount.initWithRecord(contactAccessor)
            
            if(!timeLineAccount.dateTime.isEmpty){
                timeLineRecords.append(timeLineAccount)                
            }
            records.append(contactAccessor)
            //print("records -> ")
            print(records)
            break;
        case XmlKey.DATA.rawValue:
            break;
        case XmlKey.ID.rawValue:
            id = dataMuStr as String
            break;
        case XmlKey.CONTACTID.rawValue:
            contactId = dataMuStr as String
            break;
        case XmlKey.DATETIME.rawValue:
            dateTime = dataMuStr as String
            break;
        case XmlKey.FAMILY_NAME.rawValue:
            familyName = dataMuStr as String
            break;
        case XmlKey.GIVEN_NAME.rawValue:
            givenName = dataMuStr as String
            break;
        case XmlKey.PHONETIC_FAMILY_NAME.rawValue:
            phoneticFamilyName = dataMuStr as String
            break;
        case XmlKey.PHONETIC_GIVEN_NAME.rawValue:
            phoneticGivenName = dataMuStr as String
            break;
        case XmlKey.ORIGATION.rawValue:
            origiation = dataMuStr as String
            break;
        case XmlKey.BIRTHDY.rawValue:
            birthday = dataMuStr as String
            break;
        case XmlKey.PHONE_NUMBER.rawValue:
            phoneNumber.append(dataMuStr as String)
            break;
        case XmlKey.EMAIL_ADDRESS.rawValue:
            emailAddress.append(dataMuStr as String)
            break;
        default:
            break;
        }
        dataMuStr = ""
    }
    
    // エラー処理
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print("parseError ")
        print(parseError)
        print(parser.lineNumber)
        print(parseError.description)
        
    }
    
    func parserDidEndDocument(parser: NSXMLParser)
    {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.friendListController.friendRecords = records
        appDelegate.timeLineRecords = timeLineRecords;
    }
}
