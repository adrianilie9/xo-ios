//
//  NXDeviceDetector.swift
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import UIKit

class NXUIDeviceDetector {
    static func IS_IPHONE_X() -> Bool {
        return (
            (UIDevice.current.userInterfaceIdiom == .phone)
            &&
            (
                max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 812
            )
        )
    }
}
