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
    
    var username: String {
        return user.username
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
        return user.isCurrentUser ? .white : #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
    }
    
    var followButtonTextcolor: UIColor {
        return user.isCurrentUser ? #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1) : .white
    }
    
    var numberOfFollowers: NSAttributedString {
        return attributedStatsText(label: "Followers", value: user.stats.followers)
    }
    
    var numberOfFollowings: NSAttributedString {
        return attributedStatsText(label: "Following", value: user.stats.following)

    }
    
    init(user: User) {
        self.user = user
    }
    
    func attributedStatsText(label: String, value: Int) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: label, attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: CGColor(red: 233/255, green: 64/255, blue: 87/255, alpha: 1)])
        
        attributedText.append(NSAttributedString(string: " \(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
}
