//
//  EditProfileController.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/25/21.
//

import UIKit

class EditProfileController: UIViewController {
    
    //MARK: - Properties
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handloDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handloDismiss))
    }
    
    @objc func handloDismiss() {
        dismiss(animated: true, completion: nil)
    }
}
