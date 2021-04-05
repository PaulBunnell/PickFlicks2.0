//
//  CardView.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/16/21.
//

import UIKit
import SwiftUI

enum swipeDirection: Int {
    case left = -1
    case right = 1
}

protocol cardViewDelegate: class {
    func showMovieDetails()
    func refreshCards()
}

class CardView: UIView {
    
    //MARK: - Properties
    
    let movieController = MovieController()
    
    let homeController = HomeController()
    
    weak var delegate: HomeNavigationStackViewDelegate?

    private let viewModel: CardViewModel

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
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
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
        
//        delegate?.showMovieDetails()
        
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
        } completion: { _ in
            if shouldDismissCard {
                self.delegate?.refreshCards()
                self.removeFromSuperview()
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
        infoButton.anchor(right: rightAnchor, paddingBottom: 16, paddingRight: 16)

    }
    
}

