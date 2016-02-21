//
//  TimeLineRecordAccessor.swift
//  Emiu
//
//  Created by Triomphe on 2016/02/21.
//  Copyright © 2016年 noguchikaito. All rights reserved.
//

import Foundation
import Contacts

class TimeLineRecordAccessor {
    
    var fullName = String();
    var dateTime = String();
    
    func initWithRecord(record:ContactRecordAccessor){
        if(!record.dateTime.isEmpty){
            self.fullName = record.familyName + record.givenName
            self.dateTime = record.dateTime
        }
    }
}
