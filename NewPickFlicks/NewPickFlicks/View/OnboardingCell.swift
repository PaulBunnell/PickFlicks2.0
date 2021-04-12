//
//  OnboardingCell.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/30/21.
//

import UIKit
import Lottie

class OnboardingCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var actionButtonDidTap: (() -> Void)?
    
    private let animationView: AnimationView = {
        let view = AnimationView()
        view.heightAnchor.constraint(equalToConstant: 400).isActive = true
        return view
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .darkGray
        label.text = "Watch movies"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1)
        button.layer.cornerRadius = 10
        button.setHeight(65)
        button.setWidth(80)
        button.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let pageControl: UIPageControl = {
       let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 2
        
        let redColor = #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
        pc.currentPageIndicatorTintColor = redColor
        pc.pageIndicatorTintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        return pc
    }()
    
    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(pageControl)
        pageControl.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 16)
        
        configureCenterUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleActionButtonTapped() {
        actionButtonDidTap?()
    }
    
    //MARK: - Helper
    
    
    fileprivate func configureCenterUI() {
        let stack = UIStackView(arrangedSubviews: [animationView, titleLabel, actionButton])
        stack.axis = .vertical
        stack.spacing = 30
        addSubview(stack)
        stack.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
    func configure(with slide: Slide) {
        titleLabel.text = slide.title
        actionButton.backgroundColor = slide.buttonColor
        actionButton.setTitle(slide.buttonTitle, for: .normal)
        
        
        let animation = Animation.named(slide.animationName)
        
        animationView.animation = animation
        animationView.loopMode = .loop
        
        if !animationView.isAnimationPlaying {
            animationView.play()
        }
    }
}
