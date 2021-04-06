//
//  SettingsSection.swift
//  NewPickFlicks
//
//  Created by John Padilla on 4/2/21.
//

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    
    case Social
    case Communications
    
    var description: String {
        switch self {
        case .Social: return "Social"
        case .Communications: return "Communications"
        }
    }
}

enum SocialOptions: Int, CaseIterable, SectionType {
    case tellAFriend
    case resetPassword
    case logout
    
    var containsSwitch: Bool {
        return false
    }
    
    var description: String {
        switch self {
        case .tellAFriend: return "Tell a Friend"
        case .resetPassword: return "Reset Password"
        case .logout: return "Log Out"
        }
    }
}

enum CommunicationOptions: Int, CaseIterable, SectionType {
    case notification
    case email
    case activateStatus
    case reportAProblem
    
    var containsSwitch: Bool {
        switch self {
        case .notification: return true
        case .email: return true
        case .reportAProblem: return false
        case .activateStatus: return true
        }
    }
    
    var description: String {
        switch self {
        case .notification: return "Notifications"
        case .email: return "Email"
        case .activateStatus: return "Active Status"
        case .reportAProblem: return "Report a Problem"
        }
    }
}
