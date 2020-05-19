//
//  SettingsApp.swift
//  test_personList
//
//  Created by Vyacheslav Lagutov on 22.03.2020.
//  Copyright © 2020 Vyacheslav Lagutov. All rights reserved.
//

import UIKit

class SettingsApp {
    
    static func saveParam(name: String, value: Any) {
        UserDefaults.standard.set(value, forKey: name)
    }
    
    static func getParam(name: String) -> Any? {
        return UserDefaults.standard.value(forKey: name)
    }
}
