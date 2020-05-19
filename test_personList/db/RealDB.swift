//
//  RealDB.swift
//  test_personList
//
//  Created by Vyacheslav Lagutov on 22.03.2020.
//  Copyright © 2020 Vyacheslav Lagutov. All rights reserved.
//

import UIKit
import RealmSwift

class PersonDB: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var height: Double = 0
    @objc dynamic var biography: String = ""
    @objc dynamic var temperament: String = ""
    @objc dynamic var eduPeriodStart: Date?
    @objc dynamic var eduPeriodEnd: Date?
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    func save() {
        
        do {
            
            let realm = try Realm()
            
            try realm.write {
                realm.add(self, update: .modified)
            }
        } catch let error {
            debugPrint(error)
        }
    }
    
    func getPhoneFormat() -> String {
        
        let startCodeCountry = phone.index(phone.startIndex, offsetBy: 1)
        let subStringCodeCountry = phone.prefix(upTo: startCodeCountry)
        
        let startCodeOperator = phone.index(phone.startIndex, offsetBy: 1)
        let endCodeOperator = phone.index(phone.startIndex, offsetBy: 3)
        
        let startCodeRegion = phone.index(phone.startIndex, offsetBy: 4)
        let endCodeRegion = phone.index(phone.startIndex, offsetBy: 6)
        
        let startFirstPair = phone.index(phone.startIndex, offsetBy: 7)
        let endFirstPair = phone.index(phone.startIndex, offsetBy: 8)
        
        let startSecondPair = phone.index(phone.startIndex, offsetBy: 9)
        let endSecondPair = phone.index(phone.startIndex, offsetBy: 10)
        
        return "+" + subStringCodeCountry + " " + phone[startCodeOperator...endCodeOperator]
                + " " + phone[startCodeRegion...endCodeRegion]
                + "-" + phone[startFirstPair...endFirstPair]
                + "-" + phone[startSecondPair...endSecondPair]
    }
}

class RealDB {
    
    init() {
        debugPrint(Realm.Configuration().fileURL)
    }
    
    func addObject(person: Person) {
            
        let newObject = PersonDB()
        
        newObject.id = person.id!
        newObject.name = person.name!
        newObject.phone = onlyDigit(in: person.phone!)
        newObject.height = person.height!
        newObject.biography = person.biography!
        newObject.temperament = person.temperament!
        newObject.eduPeriodStart = person.educationPeriod.start
        newObject.eduPeriodEnd = person.educationPeriod.end
        
        newObject.save()
    }
    
    func fetch() -> Results<PersonDB>? {
        
        var result: Results<PersonDB>?
        
        do {
            result = try Realm().objects(PersonDB.self).sorted(byKeyPath: "name", ascending: true)
        } catch let error {
            debugPrint(error)
        }
        
        return result
    }
    
    func fetch(predicate: NSPredicate) -> Results<PersonDB>? {
        
        var result: Results<PersonDB>?
        
        do {
            try result = Realm().objects(PersonDB.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
        } catch let error {
            debugPrint(error)
        }
        
        return result
    }
    
    private func onlyDigit(in string: String) -> String {
        
        var value = string
        
        value.removeAll {
            !$0.isNumber
        }
        
        return value
    }
}
