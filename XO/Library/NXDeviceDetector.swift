//
//  NXDeviceDetector.swift
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import UIKit

class NXUIDeviceDetector {
    // MARK: - Device type
    
    static func IS_IPHONE_X() -> Bool {
        return (
            (UIDevice.current.userInterfaceIdiom == .phone)
            &&
            (
                max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 812
            )
        )
    }
    
    static func IS_IPHONE_PLUS() -> Bool {
        return (
            (UIDevice.current.userInterfaceIdiom == .phone)
            &&
            (
                max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 736
            )
        )
    }
    
    static func IS_IPHONE() -> Bool {
        return (
            (UIDevice.current.userInterfaceIdiom == .phone)
                &&
                (
                    max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 667
            )
        )
    }
    
    static func IS_IPHONE_5() -> Bool {
        return (
            (UIDevice.current.userInterfaceIdiom == .phone)
                &&
                (
                    max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 568
            )
        )
    }
    
    static func IS_IPHONE_4() -> Bool {
        return (
            (UIDevice.current.userInterfaceIdiom == .phone)
                &&
                (
                    max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 480
            )
        )
    }
    
    // MARK: - iOS version
    
    static func SYSTEM_VERSION_EQUAL_TO(v: String) -> Bool {
        return (UIDevice.current.systemVersion.compare(v, options: .numeric) == ComparisonResult.orderedSame)
    }
    
    static func SYSTEM_VERSION_GREATER_THAN(v: String) -> Bool {
        return (UIDevice.current.systemVersion.compare(v, options: .numeric) == ComparisonResult.orderedDescending)
    }
    
    static func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v: String) -> Bool {
        return (UIDevice.current.systemVersion.compare(v, options: .numeric) != ComparisonResult.orderedAscending)
    }
    
    static func SYSTEM_VERSION_LESS_THAN(v: String) -> Bool {
        return (UIDevice.current.systemVersion.compare(v, options: .numeric) == ComparisonResult.orderedAscending)
    }
    
    static func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v: String) -> Bool {
        return (UIDevice.current.systemVersion.compare(v, options: .numeric) != ComparisonResult.orderedDescending)
    }
}
