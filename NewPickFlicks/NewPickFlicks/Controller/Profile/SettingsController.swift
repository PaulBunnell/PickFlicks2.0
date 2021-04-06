//
//  SettingsController.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/17/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "SettingsCell"

class SettingsController: UIViewController {

    //MARK: - Properties

    var tableView: UITableView!

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    //MARK: - Helpers

    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60

        tableView.register(SettingCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.fillSuperview()
    }

    func configureUI() {

        configureTableView()
        navigationItem.title = "Settings"
    }

    private func didTapLogOut() {

        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                let controller = LoginController()
                controller.delegate = self.tabBarController as? MainTabController as! AuthenticationDelegate
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true) {
                    self.navigationController?.popToRootViewController(animated: false)
                    self.tabBarController?.selectedIndex = 0
                }
            } catch {
                print("DEBUG: Failed to sign out")
            }
        }))

        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
    }
    
    private func presentShareSheet() {
        
        let shareSheetVC = UIActivityViewController (activityItems: [], applicationActivities: nil)
        present(shareSheetVC, animated: true)
        
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0}

        switch section {
        case .Social: return SocialOptions.allCases.count
        case .Communications: return CommunicationOptions.allCases.count
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground

        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = .black
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingCell
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell()}

        switch section {
        case .Social:
            let social = SocialOptions(rawValue: indexPath.row)
            cell.sectionType = social
        case .Communications:
            let communication = CommunicationOptions(rawValue: indexPath.row)
            cell.sectionType = communication
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }

        switch section {
        case .Social:
            guard let socialOptions = SocialOptions(rawValue: indexPath.row) else { return }
 
            switch socialOptions {
            case .tellAFriend :
                presentShareSheet()
            case .resetPassword:
                print("DEBUG: Reset your password")
            case .logout:
                didTapLogOut()
            }

        default:
            guard let communicationOptions = CommunicationOptions(rawValue: indexPath.row) else { return }
            
            switch communicationOptions {
            case .notification:
                print("DEBUG: Turn On/Off on notifications")
            case .email:
                print("DEBUG: Turn On/Off email so others can't can see it")
            case .activateStatus:
                print("DEBUG: Turn On/Off status to see if you are online or not")
            case .reportAProblem:
                print("DEBUG: Report a problem by sending us an email")
            }
        }
    }
}
