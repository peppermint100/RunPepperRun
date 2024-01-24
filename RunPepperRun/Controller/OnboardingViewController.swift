//
//  OnBoardingViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/19/24.
//

import UIKit

enum SlideType {
    case nickname, weight
}

class OnboardingViewController: UIViewController {
    
    let user = UserManager()
    var nickname = ""
    var weight = "60"
    
    var currentPage = 0 {
        didSet {
            if currentPage == slides.count - 1 {
                nextButton.setTitle("시작하기", for: .normal)
            } else {
                nextButton.setTitle("다음", for: .normal)
            }
        }
    }
    var slides: [SlideType] = []
    
    private let stackView = UIStackView()
    private let onboardingCollectionView: UICollectionView = {
        let layout = OnboardingCollectionViewLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    private let pageControl = UIPageControl()
    private let nextButtonView = UIView()
    private let nextButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSlides()
        setupStackView()
        setupCollectionView()
        setupPageControl()
        setupNextButtonView()
        setupNextButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupSlides() {
        slides = [.nickname, .weight]
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.5)
        }
    }
    
    private func setupCollectionView() {
        stackView.addArrangedSubview(onboardingCollectionView)
        onboardingCollectionView.showsHorizontalScrollIndicator = false
        onboardingCollectionView.showsVerticalScrollIndicator = false
        onboardingCollectionView.isPagingEnabled = true
        onboardingCollectionView.isScrollEnabled = false
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        onboardingCollectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        onboardingCollectionView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.7)
        }
    }
    
    private func setupPageControl() {
        stackView.addArrangedSubview(pageControl)
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = .label.lighter(by: 70)
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = currentPage
        pageControl.isUserInteractionEnabled = false
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.12)
        }
    }
    
    private func setupNextButtonView() {
        stackView.addArrangedSubview(nextButtonView)
        nextButtonView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.18)
        }
    }
    
    private func setupNextButton() {
        nextButtonView.addSubview(nextButton)
        nextButton.backgroundColor = .systemBlue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.setTitle("다음", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nextButton.layer.cornerRadius = 10
        nextButton.clipsToBounds = true
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        nextButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(50)
        }
    }
    
    @objc private func didTapNextButton() {
        if currentPage == slides.count - 1 {
            view.endEditing(true)
            guard let weight = Double(weight) else { return }
            UserManager.shared.createUser(nickname: nickname, weight: weight) { [weak self] success in
                if success {
                    let nvc = UINavigationController(rootViewController: HomeViewController())
                    nvc.modalPresentationStyle = .fullScreen
                    self?.present(nvc, animated: true)
                }
            }
        } else {
            currentPage += 1
            pageControl.currentPage = currentPage
            let indexPath = IndexPath(item: currentPage, section: 0)
            onboardingCollectionView.isPagingEnabled = false
            onboardingCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
            onboardingCollectionView.isPagingEnabled = true
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath)
            as! OnboardingCollectionViewCell
        let slide = slides[indexPath.row]
        cell.type = slide
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollViewWidth = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / scrollViewWidth)
        pageControl.currentPage = currentPage
    }
}

extension OnboardingViewController: OnboardingCollectionViewCellDelegate {
    func didEndEditing(_ cell: OnboardingCollectionViewCell, type: SlideType, text: String) {
        switch type {
        case .nickname:
            nickname = text
        case .weight:
            weight = text
        }
    }
}
