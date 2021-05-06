//
//  MainTabController.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/17/21.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    var user: User? { didSet { guard let user = user else { return }
            configureViewController(withUser: user) } }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        checkIfUserIsLoggedIn()
        fetchUser()
    }
    
    //MARK: - Actions
    
    func fetchUser() {
        UserService.fetchUser { user in
            self .user = user
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureViewController(withUser user: User) {
        view.backgroundColor = .white
        
        let search = templateNAvigationController(unselectedImage: #imageLiteral(resourceName: "Search"), selectedImage: #imageLiteral(resourceName: "Search"), rootViewController: SearchController(config: .all))

        let notification = templateNAvigationController(unselectedImage: #imageLiteral(resourceName: "icons8-notification-50"), selectedImage: #imageLiteral(resourceName: "icons8-notification-50-2"), rootViewController: NotificationController())
        
        let profileController = ProfileController(user: user)
        let profile = templateNAvigationController(unselectedImage: #imageLiteral(resourceName: "icons8-user-96-2"), selectedImage: #imageLiteral(resourceName: "icons8-user-96-2"), rootViewController: profileController)
        
        viewControllers = [profile, search, notification]
        
        tabBar.tintColor = #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
        tabBar.barStyle = .default
    }
    
    func templateNAvigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
}

extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}
