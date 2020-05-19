//
//  extension.swift
//  test_personList
//
//  Created by Vyacheslav Lagutov on 22.03.2020.
//  Copyright © 2020 Vyacheslav Lagutov. All rights reserved.
//

import RealmSwift

extension Results {
    func toArray<U>(ofType: U.Type) -> [U] {
        var array = [U]()
        
        self.forEach {
            if let result = $0 as? U {
                array.append(result)
            }
        }
        
        return array
    }
}
