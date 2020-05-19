//
//  PersonListModel.swift
//  test_personList
//
//  Created by Vyacheslav Lagutov on 22.03.2020.
//  Copyright © 2020 Vyacheslav Lagutov. All rights reserved.
//

import UIKit
import RealmSwift

class PersonListModel {
    
    typealias Listener = (_ err: Error? ) -> ()
    
    func addListener(l: @escaping Listener) {
        listeners.append(l)
    }
    
    func updateList() {
        
        var personList: [Person] = []
        var error: Error?

        for addr in address {
            URLRequest.getData(addr: addr) { [unowned self] (data, err) in
                
                if err != nil {
                    error = err
                } else {
                    let jsonParser = JsonParser()
                    let newElements = jsonParser.readJson(data: data!)!
                    personList.append(contentsOf: newElements)
                }
                
                let db = RealDB()
                
                personList.forEach {
                    let results = db.fetch(predicate: NSPredicate(format: "id == %@", $0.id!))
                    if results!.isEmpty {
                        db.addObject(person: $0)
                    }
                }
                
                SettingsApp.saveParam(name: "update_at", value: Date())
                self.notify(err: error)
            }
        }
    }
    
    func filter(filterStr: String) -> Results<PersonDB> {
        
        var data: Results<PersonDB>
        let db = RealDB()
        
        if filterStr.isEmpty {
            data = db.fetch()!
        } else {
            data = db.fetch(predicate: NSPredicate(format: "phone CONTAINS %@ OR name CONTAINS[c] %@", filterStr, filterStr))!
        }
        
        return data
    }
    
    private func notify(err: Error?) {
        DispatchQueue.main.async { [unowned self] in
            for l in self.listeners {
                l(err)
            }
        }
    }
    
    private var listeners: [Listener] = []
    let address = ["https://github.com/SkbkonturMobile/mobile-test-ios/blob/master/json/generated-01.json?raw=true",
                "https://github.com/SkbkonturMobile/mobile-test-ios/blob/master/json/generated-02.json?raw=true",
                "https://github.com/SkbkonturMobile/mobile-test-ios/blob/master/json/generated-03.json?raw=true"]
    
}
