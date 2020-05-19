//
//  DetailViewController.swift
//  test_personList
//
//  Created by Vyacheslav Lagutov on 22.03.2020.
//  Copyright © 2020 Vyacheslav Lagutov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var callNumber: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eduPeriodLabel: UILabel!
    @IBOutlet weak var temperamentLabel: UILabel!
    @IBOutlet weak var biographyText: UITextView!
    
    var person: PersonDB?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let person = person {
            callNumber.setTitle(person.getPhoneFormat(), for: .normal)
            nameLabel.text = person.name
            eduPeriodLabel.text = "\(dateToString(value: person.eduPeriodStart!)) - \(dateToString(value: person.eduPeriodEnd!))"
            temperamentLabel.text = person.temperament
            biographyText.text = person.biography
        }
    }
    
    private func dateToString(value: Date) -> String {
        
        let dateFormatter = DateHelper.dateFormatter
        dateFormatter.dateFormat = "dd.MM.YYYY"
        
        return dateFormatter.string(from: value)
    }
    
    @IBAction func callPerson(_ sender: Any) {
        let url:NSURL = URL(string: "TEL://\(person!.phone)")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
