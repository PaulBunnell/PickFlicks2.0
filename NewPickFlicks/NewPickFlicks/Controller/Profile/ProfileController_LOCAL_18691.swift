//
//  ProfileController.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/17/21.
//

import UIKit
import SwiftUI
import Firebase

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {

    //MARK: - Properties
    let database = Firestore.firestore()
    
    private var user: User { didSet { collectionView.reloadData() }}
    
    var likedCardViews = [CardView]()
    var likedMovies = [Movie]()

    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                            
        configureCollectionView()
        checkIfUserISFollowed()
        fetchUsersStats()
        view.backgroundColor = .secondarySystemBackground
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let movies = User.favoriteMovies {
            MovieDetail.likedMovies = movies
        }
        
    }
    
    //MARK: - API
    
    func checkIfUserISFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUsersStats() {
//        UserService.fetchUserStats(uid: user.uid) { stats in
//            self.user.stats = stats
//            self.collectionView.reloadData()
//        }
    }

    
    //MARK: - Actions
    
    @objc func handleGoToSettings() {
        let controller = SettingsController()
        controller.title = "Settings"
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleRefresh() {
        likedMovies.removeAll()
        collectionView.reloadData()
        collectionView.refreshControl?.endRefreshing()
    }
    
    //MARK: - helpers
    
    func updateCollectionView() {
        collectionView.reloadData()
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .secondarySystemBackground

        navigationItem.title = user.username
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-news-feed-50-7"), style: .done, target: self, action: #selector(handleGoToSettings))
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    func showEditProfileController() {
        let controller = EditProfileController(user: user)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func showMessage() {
        let controller = NewGroupController()
        present(controller, animated: true, completion: nil)
    }
    
    func showMatching() {
        let controller = PlayController(user: self.user)
        let nav = UINavigationController(rootViewController: controller)

        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController

        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
        
    }
    
}

//MARK: - UICollectionViewDataSource

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if User.favoriteMovies == nil {
            return 0
        }
        else {
            return User.favoriteMovies!.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if MovieDetail.editTapped == true {
            
            User.favoriteMovies?.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
            collectionView.reloadData()
            
        }
        else {
            
            database.collection("Movie")
            MovieDetail.detailedMovie = User.favoriteMovies![indexPath.row]
            let controller = UIHostingController(rootView: MovieDetailView(user: user))
            controller.modalPresentationStyle = .popover
            DispatchQueue.main.async {
                self.getTopMostViewController()?.present(controller, animated: true, completion: nil)
            }
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
                
        // Use array of liked movies to populate instead of making api call
        
        if let movies = User.favoriteMovies {
            
            let task = URLSession.shared.dataTask(with: URL(string: "http://image.tmdb.org/t/p/w500\(movies[indexPath.row].poster_path)")!) { (data, response, error) in
                    
            guard let data = data, let image = UIImage(data: data) else {return}
                        
                DispatchQueue.main.async {
                    cell.posterImageView.image = image
                }
            }
            task.resume()
            
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.delegate = self
        header.viewModel = ProfileHeaderViewModel(user: user)

        return header
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 3
        let height = (view.frame.height - 2) / 4.35
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: view.frame.width, height: 480)
    }
}

//MARK: ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        guard let tab = tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }

        if user.isCurrentUser {
            showEditProfileController()
        } else if user.isFollowed {
            UserService.unFollow(uid: user.uid) { error in
                self.user.isFollowed = false
                NotificationService.deleteNotification(toUid: user.uid, type: .follow)
            }
        } else {
            UserService.follow(uid: user.uid) { error in
                self.user.isFollowed = true
                NotificationService.uploadNotification(toUid: user.uid, fromUser: currentUser, type: .follow)
            }
        }
    }
    
    func header(_ profileHeader: ProfileHeader, wantsToViewFollowingFor user: User) {
        let controller = SearchController(config: .following(user.uid))
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func header(_ profileHeader: ProfileHeader, wantsToViewFollowersFor user: User) {
        let controller = SearchController(config: .followers(user.uid))
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func header(_ profileHeader: ProfileHeader, didTapMatchingButtonFor user: User) {
        if user.isCurrentUser {
//            showNewGroupMatching()
            showMatching()
        } else {
            showMessage()
        }
    }
}

//MARK: - EditProfileControllerDelegate

extension ProfileController: EditProfileControllerDelegate {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
    }
}
