//
//  JsonParser.swift
//  test_personList
//
//  Created by Vyacheslav Lagutov on 22.03.2020.
//  Copyright © 2020 Vyacheslav Lagutov. All rights reserved.
//

import UIKit

struct Person:Decodable {
    var id: String?
    var name: String?
    var phone: String?
    var height: Double?
    var biography: String?
    var temperament: String?
    var educationPeriod: EducationPeriod
}

struct EducationPeriod:Decodable {
    var start: Date?
    var end: Date?
}

class JsonParser {
    
    func readJson(data: Data) -> [Person]? {
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let model = try decoder.decode([Person].self, from: data)
            return model
        } catch let readError {
            debugPrint(readError)
        }
        
        return nil
    }
}
