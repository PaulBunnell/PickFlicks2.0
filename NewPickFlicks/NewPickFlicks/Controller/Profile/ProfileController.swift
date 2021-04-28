//
//  ProfileController.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/17/21.
//

import UIKit
import SwiftUI

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {

    //MARK: - Properties
    
    private var user: User {
        didSet { collectionView.reloadData() }
    }
    
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
        UserService.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }

    //MARK: - Actions
    
    @objc func handleGoToSettings() {
        let controller = SettingsController()
        controller.title = "Settings"
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - helpers
    
    func updateCollectionView() {
        collectionView.reloadData()
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        navigationItem.title = user.username
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-news-feed-50-7"), style: .done, target: self, action: #selector(handleGoToSettings))
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    func showEditProfileController() {
        let controller = EditProfileController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func showNewGroupMatching() {
        let controller = NewGroupController()
        present(controller, animated: true, completion: nil)
    }
    
    func showMatching() {
        let controller = HomeController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .popover
        present(nav, animated: true, completion: nil)
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
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: 205)
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
                self.collectionView.reloadData()
            }
        } else {
            UserService.follow(uid: user.uid) { error in
                self.user.isFollowed = true
                self.collectionView.reloadData()
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
            showNewGroupMatching()
        } else {
            showMatching()
        }
    }
}
