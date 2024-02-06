//
//  SettingViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 2/6/24.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {
    
    private let signOutButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupSignOutButton()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Setting"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupSignOutButton() {
        view.addSubview(signOutButton)
        signOutButton.setTitle("로그아웃", for: .normal)
        signOutButton.setTitleColor(.systemRed, for: .normal)
        signOutButton.titleLabel?.textAlignment = .center
        signOutButton.backgroundColor = .systemGray5
        signOutButton.layer.cornerRadius = 12
        signOutButton.clipsToBounds = true
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        signOutButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
    }
    
    @objc private func signOut() {
        let alertVC = UIAlertController(title: "로그아웃 하시겠습니까?", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .destructive) { [weak self] _ in
            do {
                try Auth.auth().signOut()
            } catch {
                NSLog("로그아웃에 실패했습니다.")
                NSLog(error.localizedDescription)
            }
            
            let vc = SignUpViewController()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}
