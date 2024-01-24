//
//  OnboardingCollectionViewCell.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/20/24.
//

import UIKit
import SnapKit

protocol OnboardingCollectionViewCellDelegate {
    func didEndEditing(_ cell: OnboardingCollectionViewCell, type: SlideType, text: String)
}

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "OnboardingCollectionViewCell"
    let nicknameMaxLength = 7
    
    var delegate: OnboardingCollectionViewCellDelegate?
    
    var type: SlideType? {
        didSet {
            switch type {
            case .nickname:
                titleLabel.text = "앱에서 사용할 닉네임을 알려주세요."
                textField.keyboardType = .default
            case .weight:
                titleLabel.text = "몸무게를 알려주세요."
                textField.keyboardType = .numberPad
            default:
                return
            }
        }
    }
    
    private let stackView = UIStackView()
    private let titleLabelView = UIView()
    private let titleLabel = UILabel()
    private let textFieldView = UIStackView()
    private let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupTitleLabelView()
        setupTitleLabel()
        setupTextFieldView()
        setupTextField()
    }
    
    required init(coder: NSCoder) {
        fatalError("OnboardingCollectionViewCell 생성 실패")
    }
    
    private func setupStackView() {
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setupTitleLabelView() {
        stackView.addArrangedSubview(titleLabelView)
        titleLabelView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    private func setupTitleLabel() {
        titleLabelView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    private func setupTextFieldView() {
        stackView.addArrangedSubview(textFieldView)
        textFieldView.axis = .vertical
        textFieldView.distribution = .fillEqually
        textFieldView.alignment = .center
        textFieldView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.4)
        }
    }
    
    private func setupTextField() {
        textFieldView.addArrangedSubview(textField)
        textField.keyboardType = .default
        textField.textColor = .label
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 12
        textField.clipsToBounds = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.snp.makeConstraints { make in
            make.width.equalTo(textFieldView.snp.width).multipliedBy(0.9)
            make.height.equalTo(textFieldView.snp.height).multipliedBy(0.7)
            make.top.equalTo(textFieldView.snp.top)
        }
    }
}

extension OnboardingCollectionViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let type = type, let text = textField.text else { return }
        delegate?.didEndEditing(self, type: type, text: text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        switch type {
        case .nickname:
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= nicknameMaxLength
        case .weight:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        default:
            return false
        }
    }
}
