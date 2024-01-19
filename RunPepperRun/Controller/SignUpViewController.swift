//
//  SignUpViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/19/24.
//

import UIKit
import SnapKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class SignUpViewController: UIViewController {
    
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let buttonView = UIView()
    private let signInButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupStackView()
        setupImageView()
        setupTitleLabel()
        setupSubtitleLabel()
        setupButtonView()
        setupSignInButton()
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setupImageView() {
        stackView.addArrangedSubview(imageView)
        imageView.image = UIImage(named: "runningIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    private func setupTitleLabel() {
        stackView.addArrangedSubview(titleLabel)
        titleLabel.text = "안녕하세요"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .inverted
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.05)
        }
    }
    
    private func setupSubtitleLabel() {
        stackView.addArrangedSubview(subtitleLabel)
        subtitleLabel.text = "로그인하고 러닝을 시작해보세요."
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.05)
        }
    }
    
    private func setupButtonView() {
        stackView.addArrangedSubview(buttonView)
        buttonView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    private func setupSignInButton() {
        buttonView.addSubview(signInButton)
        signInButton.layer.cornerRadius = 15
        signInButton.clipsToBounds = true
        signInButton.setTitle("Google 로그인", for: .normal)
        signInButton.setTitleColor(.label, for: .normal)
        signInButton.setImage(UIImage(named: "googleIcon")?.resizeImage(targetSize: CGSize(width: 30, height: 30)), for: .normal)
        signInButton.backgroundColor = .systemBackground
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor.inverted.cgColor
        signInButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        var config = UIButton.Configuration.plain()
        let spacing: CGFloat = 8
        config.imagePadding = spacing
        config.titlePadding = spacing
        signInButton.configuration = config
        signInButton.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(250)
            make.height.greaterThanOrEqualTo(60)
            make.center.equalToSuperview()
        }
    }
    
    @objc private func handleGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else { return }
            guard let user = result?.user, let idToken = user.idToken?.tokenString
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) {[weak self] result, error in
                guard error == nil else { return }
                let vc = OnBoardingViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }
        }
    }
}
