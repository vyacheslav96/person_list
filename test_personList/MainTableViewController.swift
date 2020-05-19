//
//  MainTableViewController.swift
//  test_personList
//
//  Created by Vyacheslav Lagutov on 22.03.2020.
//  Copyright © 2020 Vyacheslav Lagutov. All rights reserved.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    let personListModel = PersonListModel()
    var data: Results<PersonDB>?
    var alert: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        loadAlertLabel()
        loadSearchController()
        loadFreshControll()
    }
    
    func loadData() {
        personListModel.addListener(l: { [unowned self] (err) in self.reloadData(err: err) })
        
        if let update_at = SettingsApp.getParam(name: "update_at") as? Date {
            if Date().addingTimeInterval(TimeInterval(-60)).compare(update_at) == ComparisonResult.orderedDescending {
                personListModel.updateList()
            }
        } else {
            personListModel.updateList()
        }
    }
    
    func loadAlertLabel() {
        
        alert = UIView(frame: CGRect(origin: CGPoint(x: view.frame.midX - 150, y: view.frame.maxY - 150), size: CGSize(width: 300, height: 42)))
        alert.backgroundColor = .black
        alert.alpha = 0
        
        view.addSubview(alert)
        
        let label = UILabel()
        label.text = "Нет подключения к сети"
        label.font = UIFont(name: "System", size: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.frame = CGRect(origin: .zero, size: alert.frame.size)
        alert.addSubview(label)
    }
    
    func loadSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchBarStyle = .minimal
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func loadFreshControll() {
        
        refreshControl = UIRefreshControl()
        
        guard let rControl = refreshControl else { return }
        
        rControl.addTarget(self, action:#selector(updateRefresh), for: .valueChanged)
        
        tableView.addSubview(rControl)
    }
    
    @objc func updateRefresh() {
        personListModel.updateList()
        refreshControl?.endRefreshing()
    }

    func reloadData(err: Error? = nil) {
        
        if let _ = err {
            UIView.animate(withDuration: 3, animations: {[unowned self] in self.alert.alpha = 0.5},
                            completion: { [unowned self] (complete) in self.hiddenErrorView()})
            return
        }
        
        tableView.reloadData()
    }
    
    func hiddenErrorView() {
        UIView.animate(withDuration: 3, animations: {[unowned self] in self.alert.alpha = 0})
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        data = personListModel.filter(filterStr: searchController.searchBar.text!)
        
        guard let data = data else {
            return 0
        }
        
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        
        let element = data![indexPath.row]

        cell.nameLabel.text = element.name
        cell.phoneLabel.text = element.getPhoneFormat()
        cell.temperamentLabel.text = element.temperament
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dest = segue.destination as? DetailViewController,
            let _ = sender as? MainTableViewCell {
            
            let index = (tableView.indexPathForSelectedRow?.row)!
            dest.person = data![index]
        }

    }
}
