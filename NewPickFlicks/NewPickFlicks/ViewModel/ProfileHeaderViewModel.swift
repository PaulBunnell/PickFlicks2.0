//
//  ProfileHeaderViewModel.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/18/21.
//

import UIKit

struct ProfileHeaderViewModel {
    
    var user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var email: String {
        return user.email
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var followButtonText: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return user.isCurrentUser ? #colorLiteral(red: 0.989223063, green: 0.9227725863, blue: 0.9294853806, alpha: 1) : #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
    }
    
    var followButtonTextcolor: UIColor {
        return user.isCurrentUser ? #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1) : .white
    }
    
    var numberOfFollowers: NSAttributedString {
        return attributedStatsText(value: user.stats.followers, label: "Followers")
    }
    
    var numberOfFollowings: NSAttributedString {
        return attributedStatsText(value: user.stats.following, label: "Following")
    }
    
    var matchingButtonImage: UIImage {
        if user.isCurrentUser {
            return #imageLiteral(resourceName: "icons8-red-card-50-2")
        }
        return #imageLiteral(resourceName: "top_right_messages")
    }
    
    var matchingButtonBackgroundColor: UIColor {
        return user.isCurrentUser ? .white : #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
    }
    
    var matchingButtonTextColor: UIColor {
        return user.isCurrentUser ? #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1) : .white
    }
    
    
    init(user: User) {
        self.user = user
    }
    
    func attributedStatsText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: " \(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 30), .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 10), .foregroundColor: UIColor.white]))

        return attributedText
    }
}
