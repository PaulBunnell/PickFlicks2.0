//
//  CardView.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/16/21.
//

import UIKit

enum swipeDirection: Int {
    case left = -1
    case right = 1
}

protocol cardViewDelegate: class {
    func cardView(_ view: CardView, wantToShowProfileFor moview: Movies)
}

class CardView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: cardViewDelegate?
    
    private let gradientLayer = CAGradientLayer()
    
    private let viewModel: CardViewModel
    
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
        button.addTarget(self, action: #selector(handleShowMovieDetails), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureGestureRecognizers()
        
        infoLabel.attributedText = viewModel.moviesInfoText
        
        imageView.image = viewModel.movies.images.first
        category.text = viewModel.movies.category
        
        backgroundColor = .systemBlue
        layer.cornerRadius = 15
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        configureGradientLayer()
        
        configureInfoUI()
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    //MARK: - Actions
    
    @objc func handleShowMovieDetails() {
        delegate?.cardView(self, wantToShowProfileFor: viewModel.movies)
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
    
    @objc func handleChangePhoto(sender: UITapGestureRecognizer) {
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto = location > self.frame.width / 2
        
        if shouldShowNextPhoto {
            viewModel.showNextPhoto()
        } else {
            viewModel.showPreviousPhoto()
        }
        imageView.image = viewModel.imageToShow
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        addGestureRecognizer(tap)
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
        infoButton.anchor(right: rightAnchor, paddingRight: 16)

    }
}
