//
//  StartSession.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/18/21.
//

import UIKit

class StartSession: UIView {
    
    //MARK: - Properties
    
    private let matchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Start Matching!"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.text = "What do you want to do to choose your favorite movie?"
        return label
    }()
    
    private let hostButton: UIButton = {
        let button = FillButtonController(type: .system)
        button.setTitle("HOST", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(45)
        button.addTarget(self, action: #selector(didTapHost), for: .touchUpInside)
        return button
    }()
    
    private let joinButton: UIButton = {
        let button = FillButtonController(type: .system)
        button.setTitle("JOIN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(45)
        button.addTarget(self, action: #selector(didTapJoin), for: .touchUpInside)
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = ClearButtonController(type: .system)
        button.setTitle("DISMISS", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(45)
        button.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        return button
    }()
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    lazy var views = [matchImageView, descriptionLabel, hostButton, joinButton, dismissButton]
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureBlurView()
        configureUI()
        configureAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func didTapHost() {
//        let controller = NewGroupController()
        
    }
    
    @objc func didTapJoin() {
        
    }
    
    @objc func didTapDismiss() {
        
    }
    
    //MARK: - Actions
    
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        views.forEach { view in
            addSubview(view)
            view.alpha = 1
        }
        
        let stackView = UIStackView(arrangedSubviews: [matchImageView, descriptionLabel, hostButton, joinButton, dismissButton])
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func configureAnimation() {
        views.forEach({ $0.alpha = 1})
        
//        let angle = 30 * CGFloat.pi / 180
        
        self.hostButton.transform = CGAffineTransform(translationX: -500, y: 0)
        self.joinButton.transform = CGAffineTransform(translationX: 500, y: 0)
        self.dismissButton.transform = CGAffineTransform(translationX: -500, y: 0)
        
//        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
//            self.hostButton.transform = .identify
//            self.joinButton.transform = .identify
//            self.dismissButton.transform = .identify
//        }, completion: nil)
        
        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            self.hostButton.transform = .identity
            self.joinButton.transform = .identity
            self.dismissButton.transform = .identity
        } completion: { _ in}
    }
    
    func configureBlurView() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        visualEffectView.addGestureRecognizer(tap)
        
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.visualEffectView.alpha = 1
        } completion: { _ in}
    }
}
