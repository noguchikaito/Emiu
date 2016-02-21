//
//  StrUtil.swift
//  Emiu
//
//  Created by Triomphe on 2016/02/06.
//  Copyright © 2016年 noguchikaito. All rights reserved.
//

import Foundation

class StrUtil : NSObject {
    
    /**
     * 文字列を特定の文字で区切って結果を配列で渡す。
     */
    static func transformDivideByKeyword(item:String,key:String) -> NSArray{
        let items = item.componentsSeparatedByString(key)
        return items
    }
    
    static func getJpTimeByYMD(dateStr:String) -> String{
        let ymd = (dateStr as NSString).substringToIndex(10)
        let ymdArray = StrUtil.transformDivideByKeyword(ymd, key: "-")
        let year = ymdArray[0] as! String
        let month = ymdArray[1] as! String
        let day = ymdArray[2] as! String
        return year + "年" + month + "月" + day + "日"
    }
}


