//
//  HttpRequest.swift
//  test_personList
//
//  Created by Vyacheslav Lagutov on 22.03.2020.
//  Copyright © 2020 Vyacheslav Lagutov. All rights reserved.
//

import UIKit

class URLRequest {
    
    static func getData(addr: String, closure: @escaping (_ data: Data?, _ error: Error?) -> ()) {
        
        let session = URLSession.shared
        let url = URL(string: addr)!
        
        let _ = session.dataTask(with: url) { (data, response, err)  in
            
            closure(data, err)
        }.resume()
    }
}
