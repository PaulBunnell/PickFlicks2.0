//
//  HomeController.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/16/21.
//

import UIKit
import SwiftUI
import Firebase

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
    
    let refreshMovie: Movie = Movie(id: 191911, title: "Refresh Card", overview: "Please wait one moment", vote_average: 9.7, poster_path: "A path", release_date: "2019")
    
    private var refreshIndexPath = 2
    private var genreIndexPath = 1
    private var hasSelectedGenre = false
    private var selectedGenreID: Int?
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlStackView()

    let database = Firestore.firestore()
    
    var cardView: CardView?
        
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
        view.backgroundColor = .secondarySystemBackground
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
        
        view.backgroundColor = .secondarySystemBackground
        
    }
    
    //MARK: - Helpers
    
    func configureCards(ID: Int?, pageNum: Int) {
        
        
        movieController.fetchItems(genreID: ID, numb: pageNum) { (movies) in
            
            print("Number of loaded Movies: \(movies.count)")

            if MovieDetail.dataWasReturned == true {
            
                DispatchQueue.main.async {
                    
                    self.listOfMovies = movies
                    
                    for movie in movies {
                                            
                        let newCardView = CardView(viewModel: CardViewModel(movie: movie), user: self.user)
                        
                        self.cardView = newCardView
                        
                        MovieDetail.cardViewArray.append(self.cardView!)
                                                
                        self.deckView.addSubview(newCardView)
                        
                        newCardView.fillSuperview()
                        
                    }
                    
                    MovieDetail.detailedMovie = movies[19]
                    
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
        
        for card in MovieDetail.cardViewArray {
            card.removeFromSuperview()
        }
        
        configureCards(ID: genreId, pageNum: genreIndexPath)
        
        genreIndexPath += 1
        
    }
    
}

extension HomeController: HomeNavigationStackViewDelegate {
    
    //MARK: Filter Function
    
    func filterGenre() {
        
        //Genre Filtering
        
        for card in MovieDetail.cardViewArray {
            card.removeFromSuperview()
        }
        
        MovieDetail.cardViewArray.removeAll()
                
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
        
        alert.view.tintColor = .systemPink
        
        present(alert, animated: true) {
            self.hasSelectedGenre = true
        }
        
    }
    
}

//MARK: - Card View Delegate

extension HomeController: CardViewDelegate {
    func refreshWithSwipe() {
        MovieDetail.detailedMovie = refreshMovie
        
        for card in MovieDetail.cardViewArray {
            card.removeFromSuperview()
        }
        
        if hasSelectedGenre == true {
            
            if let genreID = selectedGenreID {
                self.refreshWithGenre(genreId: genreID)
            }
            else {
                self.refreshCards()
            }
            
        }
        else {
            configureCards(ID: nil, pageNum: refreshIndexPath)
            refreshIndexPath += 1
        }
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
    func showMovieDetails() {
        let controller = UIHostingController(rootView: MovieDetailView(user: user))
        controller.modalPresentationStyle = .popover
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(controller, animated: true, completion: nil)
        }
    }
    
}

extension HomeController: BottomControlStackViewDelegate {
    
    //MARK: Like and Dislike
    
    func refreshCards() {
        
        MovieDetail.detailedMovie = refreshMovie
        
        for card in MovieDetail.cardViewArray {
            card.removeFromSuperview()
        }
        
        if hasSelectedGenre == true {
            
            if let genreID = selectedGenreID {
                self.refreshWithGenre(genreId: genreID)
            }
            else {
                self.refreshCards()
            }
            
        }
        else {
            configureCards(ID: nil, pageNum: refreshIndexPath)
            refreshIndexPath += 1
        }
    
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
                        
        MovieDetail.indexPath = MovieDetail.cardViewArray.count - 1
                
        UIView.animate(withDuration: 0.3) {
            self.animateLike(view: MovieDetail.cardViewArray[MovieDetail.indexPath])
        } completion: { _ in
            MovieDetail.likedMovies.append(MovieDetail.cardViewArray[MovieDetail.indexPath].viewModel.movie)
            print("Liked Movies Count: \(MovieDetail.likedMovies.count)")
            
            User.favoriteMovies?.append(MovieDetail.cardViewArray[MovieDetail.indexPath].viewModel.movie)
            
            User.favoriteMovies = MovieDetail.likedMovies
                        
            MovieDetail.cardViewArray[MovieDetail.indexPath].removeFromSuperview()
            MovieDetail.cardViewArray.remove(at: MovieDetail.indexPath)
            MovieDetail.indexPath -= 1

            //Add movie to Firebase
            
//            if MovieDetail.indexPath > 0 {
//                self.addFavoriteMovie(movie: MovieDetail.cardViewArray[MovieDetail.indexPath].viewModel.movie)
//            }
//            else {
//                self.addFavoriteMovie(movie: self.refreshMovie)
//            }
            
        }
        
        // TODO: When cards refresh indexPath count is off
        
        if hasSelectedGenre == false && MovieDetail.indexPath == 0 {
            MovieDetail.detailedMovie = refreshMovie
            self.refreshCards()
        }
        
        if MovieDetail.indexPath > 0 {
            MovieDetail.detailedMovie = MovieDetail.cardViewArray[MovieDetail.indexPath - 1].viewModel.movie
        }
        
        print("Index Path: \(MovieDetail.indexPath)")

        if hasSelectedGenre == true && MovieDetail.indexPath == 0 {
            
            if let genreID = selectedGenreID {
                self.refreshWithGenre(genreId: genreID)
            }
            else {
                self.refreshCards()
            }
            
        }
        
    }
    
    func addFavoriteMovie(movie: Movie) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).updateData(["likedmovies" : user.likedMovie + 1])
        
//        database.collection("Users").document(uid).setData([
//            "email" : user.email,
//            "fullname" : user.fullname,
//            "likedmovies" : user.likedMovie,
//            "profileImageUrl" : user.profileImageUrl,
//            "uid" : uid,
//            "username" : user.username
//        ])
        
        COLLECTION_USERS.document(uid).collection("Movies").document(String(movie.id)).setData([
            "id" : movie.id,
            "title": movie.title,
            "overview": movie.overview,
            "vote_average": movie.vote_average,
            "poster_path": movie.poster_path,
            "release_date": movie.release_date
        ])
 
        print("saved \(movie.title)\(movie.id)")
    }
    
    func handleDislike() {
        
        MovieDetail.indexPath = MovieDetail.cardViewArray.count - 1
        
        UIView.animate(withDuration: 0.3) {
            self.animateDislike(view: MovieDetail.cardViewArray[MovieDetail.indexPath])
        } completion: { _ in
            
            MovieDetail.cardViewArray[MovieDetail.indexPath].removeFromSuperview()
            
            MovieDetail.cardViewArray.remove(at: MovieDetail.indexPath)
            MovieDetail.indexPath -= 1
        }
        
        // TODO: When cards refresh indexPath count is off
        
        if MovieDetail.indexPath == 0 {
            MovieDetail.detailedMovie = refreshMovie
            self.refreshCards()
        }
        
        if MovieDetail.indexPath > 0 {
            MovieDetail.detailedMovie = MovieDetail.cardViewArray[MovieDetail.indexPath-1].viewModel.movie
        }
        
        print("Index Path: \(MovieDetail.indexPath)")

        if hasSelectedGenre == true && MovieDetail.indexPath == 0 {
            
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
            
                self.addSessionToFirebase()
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
    func addSessionToFirebase() {
        
        //identify the current user
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print("Session \(uid) created")
        //create the session's document in firestore's collecion
        database.collection("Session").document("Session hosted by \(uid)").setData([
            "user" : [user.uid],
            "userFavoriteMovies" : "all of them",
            "date" : Date(),
            "sessionStarted" : false
            
            ]) { (error) in
            if error == nil {
                print(error?.localizedDescription as Any)
            }
            
        }
    
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

struct MovieDetail {
    static var indexPath = 19
    static var cardViewArray = [CardView]()
    static var likedMovies = [Movie]()
    static var detailedMovie: Movie?
    static var editTapped = false
    static var dataWasReturned = true
}
