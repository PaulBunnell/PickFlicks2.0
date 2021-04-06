//
//  AllMovies.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/31/21.
//

import Foundation

enum Item: Hashable  {
    
    case app(App)
    case category(StoreCategory)
    
    var app: App? {
        if case .app(let app) = self {
            return app
        } else {
            return nil
        }
    }
    
    var category: StoreCategory? {
        if case .category(let category) = self {
            return category
        } else {
            return nil
        }
    }
    
    static let promotedApps: [Item] = [
        
        .app(App(promotedHeadline: "Top 10 movies", title: "Moview Title", subtitle: "movie Description", moviePoster: nil)),
        .app(App(promotedHeadline: "Top 10 TV Show", title: "TV Title", subtitle: "movie Description", moviePoster: nil)),
        .app(App(promotedHeadline: "Now Streming", title: "Moview Title", subtitle: "movie Description", moviePoster: nil)),
        .app(App(promotedHeadline: "Top 10 movies", title: "Moview Title", subtitle: "movie Description", moviePoster: nil))

    ]
    
    static let popularApps: [Item] = [
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", moviePoster: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", moviePoster: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", moviePoster: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", moviePoster: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", moviePoster: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", moviePoster: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", moviePoster: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", moviePoster: nil)),
    ]

    static let categories: [Item] = [
        .category(StoreCategory(name: "Action")),
        .category(StoreCategory(name: "Comedy")),
        .category(StoreCategory(name: "Drama")),
        .category(StoreCategory(name: "Romance")),
        .category(StoreCategory(name: "Science fiction")),
        .category(StoreCategory(name: "Aventure")),
        .category(StoreCategory(name: "Horror")),
        
    ]
}
