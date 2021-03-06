//
//  CardView.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/16/21.
//

import UIKit
import SwiftUI
import Firebase


enum swipeDirection: Int {
    case left = -1
    case right = 1
}

protocol CardViewDelegate: AnyObject {
    func showMovieDetails()
    func refreshWithSwipe()
}

class CardView: UIView {
    
    //MARK: - Properties
    
    let movieController = MovieController()
        
    weak var delegate: CardViewDelegate?

    let viewModel: CardViewModel
    
    var likedMovies = [Movie]()
    
    private var user: User

    private var image = UIImage()
    
    private let gradientLayer = CAGradientLayer()
    
    private let imageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let infoLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    private let category: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(ShowMovieDetails), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    init(viewModel: CardViewModel, user: User) {
        self.viewModel = viewModel
        self.user = user
        super.init(frame: .zero)
        
        if MovieDetail.dataWasReturned == true {
            configureGestureRecognizers()
            
            infoLabel.attributedText = viewModel.moviesInfoText
            
            backgroundColor = .systemBlue
            layer.cornerRadius = 15
            clipsToBounds = true
            
            addSubview(imageView)
           
            self.updateUI(movieInfo: viewModel.movie)
                
            imageView.fillSuperview()
            
            configureGradientLayer()
            
            configureInfoUI()
        }
        else {
            
            infoLabel.attributedText = NSAttributedString(string: "No data was recieved(Reload).")
            
            backgroundColor = .systemBlue
            layer.cornerRadius = 15
            clipsToBounds = true
            
            addSubview(imageView)
           
            imageView.image = UIImage(named: "new_icon")
                
            imageView.fillSuperview()
            
            configureGradientLayer()
            
            configureInfoUI()
        }
    }
    
    
    
    func updateUI(movieInfo: Movie) {
        
        let task = URLSession.shared.dataTask(with: URL(string: "http://image.tmdb.org/t/p/w500\(movieInfo.poster_path)")!) { (data, response, error) in
            
            guard let data = data, let image = UIImage(data: data) else {return}
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        task.resume()
        
    }
   
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    //MARK: - Actions
    
    @objc func ShowMovieDetails() {
        
        let homeController = PlayController(user: user)
        homeController.showMovieDetails()
        
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            superview?.subviews.forEach({ $0.layer.removeAllAnimations() })
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default: break
        }
        
    }
    
    //MARK: - Helpers
    
    func panCard(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    func resetCardPosition(sender: UIPanGestureRecognizer) {
        let direction: swipeDirection = sender.translation(in: nil).x > 100 ? .right : .left
        let shouldDismissCard = abs(sender.translation(in: nil).x) > 100
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            
            if shouldDismissCard {
                let xtranslation = CGFloat(direction.rawValue) * 1000
                let offScreenTransform = self.transform.translatedBy(x: xtranslation, y: 0)
                self.transform = offScreenTransform
            } else {
                self.transform = .identity

            }
        } completion: { [self] _ in
            if shouldDismissCard {
                
                MovieDetail.indexPath = MovieDetail.cardViewArray.count - 1
                
                MovieDetail.likedMovies.append(MovieDetail.cardViewArray[MovieDetail.indexPath].viewModel.movie)
                
                print("Liked Movies Count: \(MovieDetail.likedMovies.count)")
                
                User.favoriteMovies?.append(MovieDetail.cardViewArray[MovieDetail.indexPath].viewModel.movie)
                
                User.favoriteMovies = MovieDetail.likedMovies
                            
                MovieDetail.cardViewArray[MovieDetail.indexPath].removeFromSuperview()
                MovieDetail.cardViewArray.remove(at: MovieDetail.indexPath)
                MovieDetail.indexPath -= 1
                
                if MovieDetail.indexPath > 0 {
                    MovieDetail.detailedMovie = MovieDetail.cardViewArray[MovieDetail.indexPath].viewModel.movie
                }
                
                if MovieDetail.indexPath == 0 {
                    delegate?.refreshWithSwipe()
                }
                
                print("Index Path: \(MovieDetail.indexPath)")
  
            }
        }
    }
    
    func configureGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    func configureGestureRecognizers() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureInfoUI() {

        let stack = UIStackView(arrangedSubviews: [infoLabel, category])
        stack.axis = .vertical
        stack.spacing = 8

        addSubview(stack)
        stack.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 20, paddingRight: 16)
        
        addSubview(infoButton)
        infoButton.setDimensions(height: 40, width: 40)
        infoButton.centerY(inView: category)
        infoButton.anchor(right: rightAnchor, paddingBottom: 20, paddingRight: 16)

    }
    
}

