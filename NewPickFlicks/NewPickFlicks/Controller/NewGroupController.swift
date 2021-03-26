//
//  NewGroupController.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/23/21.
//

import UIKit

private let reuseIdentifier = "UserCell"

class NewGroupController: UITableViewController {
    
    //MARK: - Properties
    
    private let headerView = NewGroupHeader()
    private var searchController = UISearchController(searchResultsController: nil)
    private var inSearchModel: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()

    }
    
    //MARK: - Actions
    
    @objc func handloDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handloNext() {
        
    }
    
    //MARK: - Helpers
    
    func configureTableView() {
        
        configureNavigationBar()
        
        tableView.backgroundColor = .white
        configureSearchController()
        tableView.rowHeight = 65
        tableView.tableFooterView = UIView()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)

        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        tableView.tableHeaderView = headerView


    }
    
    func configureSearchController() {
//        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
//        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handloDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(handloNext))

//        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handloNext))
//        let invateButton = UIBarButtonItem(title: "Invate", style: .plain, target: self, action: #selector(handloNext))
//
//        navigationItem.rightBarButtonItems = [nextButton, invateButton]

    }
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
        label.text = "Add friends"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        view.addSubview(label)
        label.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 12)
        return view
    }
}
