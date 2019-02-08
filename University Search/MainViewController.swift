//
//  ViewController.swift
//  University Search
//
//  Created by Mikhail Yaskou on 07.02.2019.
//  Copyright © 2019 Mikhail Yaskou. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableVIew: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    let apiManager = ApiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Univesitet name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        tableVIew.reloadData()
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 0  else {
            UniversityManager.shared.universities = []
            DispatchQueue.main.async {
                self.tableVIew.reloadData()
            }
            return
        }
        apiManager.getSearchResults(searchTerm: searchText) { universities in
            guard let universities = universities else {
               return
            }
            
            UniversityManager.shared.universities = universities
            DispatchQueue.main.async {
                self.tableVIew.reloadData()
            }
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  UniversityManager.shared.universities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityUITableViewCell") as! UniversityUITableViewCell
        cell.configureCell(with: UniversityManager.shared.universities[indexPath.row])        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.show(DetailViewController.instance(with: UniversityManager.shared.universities[indexPath.row]), sender: nil)
    }

}

