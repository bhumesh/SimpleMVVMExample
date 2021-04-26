//
//  Utility.swift
//  MyHotels
//
//  Created by BhumeshwerKatre on 17/04/21.
//

import Foundation
import UIKit

class Utility {
    class func getFormatterRate(_ rate: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        let valueFomatted = formatter.string(from: NSNumber(value: Double(rate) ?? 0)) ?? "$0.00"
        return valueFomatted
    }
    class func randomStringWithLength(len: Int) -> String {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString: NSMutableString = NSMutableString(capacity: len)
        for _ in 1...len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        return randomString as String
    }
}

