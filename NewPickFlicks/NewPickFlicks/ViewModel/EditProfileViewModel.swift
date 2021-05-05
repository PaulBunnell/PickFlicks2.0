//
//  EditProfileViewModel.swift
//  NewPickFlicks
//
//  Created by John Padilla on 4/20/21.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    
    var description: String {
        switch self {
        case .username:
            return "Username"
        case .fullname:
            return "Name"
        }
    }
}

struct EditProfileViewModel {
    
    private let user: User
    let option: EditProfileOptions
    
    var titleText: String {
        return option.description
    }
    
    var optionValue: String? {
        switch option {
        case .username:
            return user.username
        case .fullname:
            return user.fullname
        }
    }
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
