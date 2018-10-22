//
//  Preferences.swift
//  StudyTool
//
//  Created by Aaron Walker on 22/10/2018.
//  Copyright © 2018 Aaron Walker. All rights reserved.
//

import Foundation

struct Preferences {
    
    // 1
    var selectedTime: TimeInterval {
        get {
            // 2
            let savedTime = UserDefaults.standard.double(forKey: "selectedTime")
            if savedTime > 0 {
                return savedTime
            }
            // 3
            return 1500
        }
        set {
            // 4
            UserDefaults.standard.set(newValue, forKey: "selectedTime")
        }
    }
    
}

