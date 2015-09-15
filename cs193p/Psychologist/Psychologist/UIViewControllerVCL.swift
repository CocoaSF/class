//
//  UIViewControllerVCL.swift
//  Psychologist
//
//  Created by sbx_fc on 15/9/14.
//  Copyright (c) 2015年 SF. All rights reserved.
//

import UIKit

var accumulatingLogVCLprefix = ""
var lastLogVCLPrefixRequest: NSDate?

extension UIViewController {
    var logVCLprefix: String {
        if let lastRequestDate = lastLogVCLPrefixRequest {
            if lastRequestDate.timeIntervalSinceNow < -2 {
                accumulatingLogVCLprefix += "__"
            }
        }
        lastLogVCLPrefixRequest = NSDate(timeIntervalSinceNow: 0)
        return accumulatingLogVCLprefix
    }
}