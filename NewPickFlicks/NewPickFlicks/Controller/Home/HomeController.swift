//
//  HomeController.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/16/21.
//

import UIKit
import SwiftUI

class HomeController: UIViewController {
    
    //MARK: - Properties
    
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlStackView()
    
    private let popUpWindow: StartSession = {
        let view = StartSession()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let bluerEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: bluerEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let movieController = MovieController()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCards()
        configureUI()
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)

        visualEffectView.alpha = 0
                
//        handleStartSession()
        
    }
    
    //MARK: - Helpers
    
    func configureCards() {
        
        movieController.fetchItems { (movies) in
        
            DispatchQueue.main.async {
                for movie in movies {
                        
                    let newCardView = CardView(viewModel: CardViewModel(movie: movie))
                        
                    self.deckView.addSubview(newCardView)
                        
                    newCardView.fillSuperview()
                }
            }
        }
        
    }
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        topStack.delegate = self
        bottomStack.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [topStack, deckView, bottomStack])
        stack.axis = .vertical
        stack.spacing = 10
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0)
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
        
    }
}

extension HomeController: HomeNavigationStackViewDelegate {
    
    func ShowProfile() {
            let alert = UIAlertController(title: "", message: "Srart Matching", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Host", style: .default, handler: { (_) in
                print("User click Approve button")
                
                let controller = NewGroupController()
                self.present(controller, animated: true, completion: nil)
            }))

            alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { (_) in
                print("User click Edit button")
            }))

            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
                print("User click Dismiss button".uppercased())
                
            }))

            self.present(alert, animated: true, completion: {
                print("completion block")
            })
    }
    
    func RegreshCards() {
        print("DEBUG: Refresh cards")
    }
}

//MARK: - cardViewDelegate

extension HomeController: cardViewDelegate {
    func cardView(_ view: CardView, wantToShowProfileFor movie: Movie) {
        let controller = UIHostingController(rootView: MovieDetailView())
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
        
    }
}

extension HomeController: BottomControlStackViewDelegate {
    
    func handleLike() {
        
    }
    
    func handleDislike() {
        print("DEBUG: Handlo disLike here...")

    }
    
    func handleStartSession() {

        print("DEBUG: Handlo startSession here...")
                
        view.addSubview(popUpWindow)
        popUpWindow.fillSuperview()

    }
    

    
    func showPopUpStartSession() {

    }
    
}
