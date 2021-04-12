//
//  Slide.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/30/21.
//

import UIKit


struct Slide {
    let title: String
    let animationName: String
    let buttonColor: UIColor
    let buttonTitle: String
    
    static let collection: [Slide] = [
        .init(title: "Choose a moview with your friend all around the world", animationName: "engagement", buttonColor: #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1), buttonTitle: "Next"),
        .init(title: "We Bla bla bla bla bla bla bla bla bla bla", animationName: "notifications", buttonColor: #colorLiteral(red: 0.9490196078, green: 0.4431372549, blue: 0.1294117647, alpha: 1), buttonTitle: "Register Now")
    ]
}
