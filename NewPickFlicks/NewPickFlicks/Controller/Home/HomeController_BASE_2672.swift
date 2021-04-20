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
    
    var user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var refreshIndexPath = 2
    private var genreIndexPath = 1
    private var indexPath = 12
    private var hasSelectedGenre = false
    private var selectedGenreID: Int?
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlStackView()
    
    var cardView: CardView?
    
    var cardViewArray = [CardView]()
    
    var likedMovies = [Movie]()
    
    var dislikedCards = [CardView]()
    
    var listOfMovies = [Movie]()
    
    var listOfGenres = [Genre]()
        
    let movieController = MovieController()
        
    let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    
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
        
        configureCards(ID: nil, pageNum: 1)
        configureUI()
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        visualEffectView.alpha = 0
        
//        handleStartSession()
        
    }
    
    //MARK: - Helpers
    
    func configureCards(ID: Int?, pageNum: Int) {
                        
        movieController.fetchItems(genreID: ID, numb: pageNum) { (movies) in
        
            print(movies.count)
            
            DispatchQueue.main.async {
                
                self.listOfMovies = movies
                
                for movie in movies {
                                        
                    let newCardView = CardView(viewModel: CardViewModel(movie: movie))
                    
                    self.cardView = newCardView
                    
                    self.cardViewArray.append(self.cardView!)
                                            
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
    
    func refreshWithGenre(genreId: Int) {
        
        for card in cardViewArray {
            card.removeFromSuperview()
        }
        
        configureCards(ID: genreId, pageNum: genreIndexPath)
        
        genreIndexPath += 1
        
    }
    
}

extension HomeController: HomeNavigationStackViewDelegate {
    
    //MARK: Filter Function
    
    func ShowProfile() {
        
        for card in cardViewArray {
            card.removeFromSuperview()
        }
        
        cardViewArray.removeAll()
        
        print("Genre functionality")
                
        let alert = UIAlertController(title: "Genre", message: "Pick a Genre", preferredStyle: .actionSheet)
        
        let defaultAction = UIAlertAction(title: "All", style: .default) { (alert) in
            self.refreshCards()
        }
        alert.addAction(defaultAction)
        
        movieController.fetchGenre { (genres) in
            
            for genre in genres {
                
                let action = UIAlertAction(title: "\(genre.name)", style: .default) { (action) in
                    self.selectedGenreID = genre.id
                    self.refreshWithGenre(genreId: self.selectedGenreID!)
                }
                
                DispatchQueue.main.async {
                    alert.addAction(action)
                }
            
            }
        }
        
        present(alert, animated: true) {
            self.hasSelectedGenre = true
        }

    }
    
}

//MARK: - Card View Delegate

extension HomeController: cardViewDelegate {
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController

        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }
    
    func showMovieDetails() {
        let controller = UIHostingController(rootView: MovieDetailView())
        controller.modalPresentationStyle = .pageSheet
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(controller, animated: true, completion: nil)
        }
    }
    
}

extension HomeController: BottomControlStackViewDelegate {
    
    //MARK: Like and Dislike
    
    func refreshCards() {
        
        for card in cardViewArray {
            card.removeFromSuperview()
        }
        configureCards(ID: nil, pageNum: refreshIndexPath)
        refreshIndexPath += 1
        
    }
    
    func animateLike(view: UIView) {
        
//        view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 7)
        view.center.x += 400

    }
    
    func animateDislike(view: UIView) {
        
//        view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 7)
        view.center.x -= 400

    }
    
    func handleLike() {
        
        /* when movie is liked it needs to be appended to users array of like movies */
                
        indexPath = cardViewArray.count - 1
        UIView.animate(withDuration: 0.3) {
            self.animateLike(view: self.cardViewArray[self.indexPath])
        } completion: { _ in
            self.likedMovies.append(self.cardViewArray[self.indexPath].viewModel.movie)
            print(self.likedMovies.count)
            
            User.favoriteMovies?.append(self.cardViewArray[self.indexPath].viewModel.movie)
            
            User.favoriteMovies = self.likedMovies

            // How to acess movie poster info through card view
            print(self.cardViewArray[self.indexPath].viewModel.movie.poster_path)
            
            self.cardViewArray[self.indexPath].removeFromSuperview()
            self.cardViewArray.remove(at: self.indexPath)
            self.indexPath -= 1
        }
        
        // TODO: When cards refresh indexPath count is off
        
        if hasSelectedGenre == false && self.indexPath == 0 {
            self.refreshCards()
        }
        
        print(indexPath)
        
        if hasSelectedGenre == true && indexPath == 0 {
            
            if let genreID = selectedGenreID {
                self.refreshWithGenre(genreId: genreID)
            }
            else {
                self.refreshCards()
            }
            
        }
        
    }
    
    func handleDislike() {
        
        indexPath = cardViewArray.count - 1
        
        UIView.animate(withDuration: 0.3) {
            self.animateDislike(view: self.cardViewArray[self.indexPath])
        } completion: { _ in
            self.dislikedCards.append(self.cardViewArray[self.indexPath])
            print(self.dislikedCards.count)
            self.cardViewArray[self.indexPath].removeFromSuperview()
            self.cardViewArray.remove(at: self.indexPath)
            self.indexPath -= 1
        }
        
        // TODO: When cards refresh indexPath count is off
        
        if self.indexPath == 0 {
            self.refreshCards()
        }
        
        print(indexPath)
        
        if hasSelectedGenre == true && indexPath == 0 {
            
            if let genreID = selectedGenreID {
                self.refreshWithGenre(genreId: genreID)
            }
            else {
                self.refreshCards()
            }
            
        }
            
    }
    
    func handleStartSession() {
     
        let alert = UIAlertController(title: "", message: "Start Matching", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Become a Host", style: .default, handler: { (_) in
            print("User click Approve button")
            
            let controller = NewGroupController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .automatic
            controller.title = "Add Participants"
            self.present(nav, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Join a group", style: .default, handler: { (_) in
            
            self.joinGroupAlert()
            print("User click Edit button")
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })

        print("DEBUG: Handlo startSession here...")
                
        view.addSubview(popUpWindow)
        popUpWindow.fillSuperview()

    }
    
    func showPopUpStartSession() {

        print("pop up pressed".uppercased())

    }
    
    /// join the group seson by entering in SessionID
    func joinGroupAlert() {
        let alertController = UIAlertController(title: "Join Group", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter code"
            textField.textAlignment = .center
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: .none)
        
        let joinButton = UIAlertAction(title: "Join", style: .default){ (alert) in
            guard let textField = alertController.textFields, let sessionIDString = textField[0].text
            else {return}
           //Once the session ID has been entered this is where the code will be to add the user to the the groupSession
            
            let joincontroller = JoinGroupViewController()
            self.present(joincontroller, animated: true, completion: nil)
        }
        
        alertController.addAction(cancelButton)
        alertController.addAction(joinButton)
        
        present(alertController, animated: true, completion: nil)
    }
}
