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
    static func transformStrByKeyword(item:String,key:String) -> NSArray{
        let items = item.componentsSeparatedByString(key)
        return items
    }
}

