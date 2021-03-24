//
//  HomeController.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/16/21.
//

import UIKit

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
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureCards()
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        visualEffectView.alpha = 0
        
        //        handleStartSession()
        
    }
    
    //MARK: - Helpers
    
    func configureCards() {
        
        //        cardView.delegate = self
        
        let movie1 = Movies(name: "King Kong", rating: "PG-13", category: "Adventure/Fantasy", images: [#imageLiteral(resourceName: "King-Kong-2005-movie-poster-709x1024"), #imageLiteral(resourceName: "4562400e6b92705125b2b8ef458b6603")])
        let movie2 = Movies(name: "The Dark Night", rating: "PG-13", category: "Action/Adventure", images: [#imageLiteral(resourceName: "dark_knight_2008_graffiti_teaser_original_film_art_db2955b9-07ea-47b9-94fa-abf3e9e594a2_5000x"), #imageLiteral(resourceName: "MV5BMTk4ODQzNDY3Ml5BMl5BanBnXkFtZTcwODA0NTM4Nw@@._V1_UY1200_CR90,0,630,1200_AL_"), #imageLiteral(resourceName: "c6636d059525d610bbca10afa36a125d"), #imageLiteral(resourceName: "976d4a125f485f771d70567c2c90ec70")])
        let movie3 = Movies(name: "Back to the Future", rating: "PG", category: "Sci-fi/Comedy", images: [#imageLiteral(resourceName: "39b39a4615f98ed1174f61a0f910e00b")])
        let movie4 = Movies(name: "The little mermaid", rating: "G", category: "Family/Musical", images: [#imageLiteral(resourceName: "MV5BN2JlZTBhYTEtZDE3OC00NTA3LTk5NTQtNjg5M2RjODllM2M0XkEyXkFqcGdeQXVyNjk1Njg5NTA@._V1_")])
        let movie5 = Movies(name: "Braveheart", rating: "R", category: "War/Drama", images: [#imageLiteral(resourceName: "51PvUkCVqOL._AC_"), #imageLiteral(resourceName: "e0c580fdd7a6191f7873b6071095117d_a8de0a69ff17e925e8233498ae3bc2d1"), #imageLiteral(resourceName: "282339__65385.1342528156.380.500")])
        let movie6 = Movies(name: "Forrest Gump", rating: "PG-13", category: "Romance/Drama", images: [#imageLiteral(resourceName: "s-l640")])
        
        let cardView1 = CardView(viewModel: CardViewModel(movies: movie1))
        let cardView2 = CardView(viewModel: CardViewModel(movies: movie2))
        let cardView3 = CardView(viewModel: CardViewModel(movies: movie3))
        let cardView4 = CardView(viewModel: CardViewModel(movies: movie4))
        let cardView5 = CardView(viewModel: CardViewModel(movies: movie5))
        let cardView6 = CardView(viewModel: CardViewModel(movies: movie6))
        
        deckView.addSubview(cardView1)
        deckView.addSubview(cardView2)
        deckView.addSubview(cardView3)
        deckView.addSubview(cardView4)
        deckView.addSubview(cardView5)
        deckView.addSubview(cardView6)
        
        cardView1.fillSuperview()
        cardView2.fillSuperview()
        cardView3.fillSuperview()
        cardView4.fillSuperview()
        cardView5.fillSuperview()
        cardView6.fillSuperview()
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
        let controller = FiltersController()
        self.present(controller, animated: true, completion: nil)
    }
    
    func RegreshCards() {
        print("DEBUG: Refresh cards")
    }
}


//MARK: - cardViewDelegate

extension HomeController: cardViewDelegate {
    func cardView(_ view: CardView, wantToShowProfileFor movies: Movies) {
        let controller = MovieDetailController(movies: movies)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
        
        print("DEBUG: Show details")
        
    }
}

extension HomeController: BottomControlStackViewDelegate {
    
    func handleLike() {
        
    }
    
    func handleDislike() {
        print("DEBUG: Handlo disLike here...")
        
    }
    
    func handleStartSession() {
        //        print("DEBUG: Handlo startSession here...")
        //
        //        view.addSubview(popUpWindow)
        //        popUpWindow.fillSuperview()
        
        let alert = UIAlertController(title: "", message: "Srart Matching", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Become a host", style: .default, handler: { (_) in
            print("User click Approve button")
            
            let controller = NewGroupController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .automatic
            controller.title = "Add Participants"
            self.present(nav, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Join a group", style: .default, handler: { (_) in
            
            self.joinGroupAlert()
            
            let joincontroller = JoinGroupViewController()
            self.present(joincontroller, animated: true, completion: nil)
            
            print("User click Edit button")
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    
    func showPopUpStartSession() {
        
    }
    
    
    func joinGroupAlert() {
        let alertController = UIAlertController(title: "Join Group", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter code"
            textField.textAlignment = .center
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: .none)
        let joinButton = UIAlertAction(title: "Join", style: .default, handler: .none)
        
        alertController.addAction(cancelButton)
        alertController.addAction(joinButton)
        
        present(alertController, animated: true, completion: nil)
        
        if joinButton.isEnabled {
            
           
        }
    }
}
