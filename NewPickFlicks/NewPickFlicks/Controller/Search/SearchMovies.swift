//
//  SearchMovies.swift
//  NewPickFlicks
//
//  Created by John Padilla on 4/30/21.
//

import UIKit

class SearchMovies: UIViewController {

    //AMRL: - Propetties
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    let tableView = UITableView()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
//         tableView.delegate = self
//         tableView.dataSource = self
        
        self.title = "Search Movies"
        
        
//         setupTableView()
        configureUI()
        configureSearchController()
        
    }
    
    //MARK: - Actions
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
//     func setupTableView() {
//         view.addSubview(tableView)
//         tableView.register(TableViewCell.self, forCellReuseIdentifier: "MovieCell")
//         tableView.translatesAutoresizingMaskIntoConstraints = false
//         tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//         tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//       }
    
    
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleDismiss))
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}


//MARK: - UISearchResultUpdating

extension SearchMovies: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

// extension SearchMovies: UITableViewDelegate {
    
// }

// extension SearchMovies: UITableViewDataSource {
//     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         User.favoriteMovies?.count ?? 0
//     }
    
//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//         let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! TableViewCell
        
//         cell.textLabel?.text = User.favoriteMovies![indexPath.row].title
        
//         return cell
        
//     }
    
    
// }
