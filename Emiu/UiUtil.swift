//
//  UiUtil.swift
//  Emiu
//
//  Created by Triomphe on 2016/02/21.
//  Copyright © 2016年 noguchikaito. All rights reserved.
//

import Foundation
import UIKit

/**
 * Label作成
 */
func createLabel(frame:CGRect,text:String) -> UILabel{
    let label = UILabel.init(frame: frame)
    label.text = text
    return label
}