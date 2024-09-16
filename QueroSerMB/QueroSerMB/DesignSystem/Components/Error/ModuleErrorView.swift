//
//  ModuleErrorView.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 16/09/24.
//

import UIKit

class ModuleErrorView: UIView {
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let tryAgainButton = UIButton(type: .system)
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Spacing.space0
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: Spacing.space3,
            left: Spacing.space3,
            bottom: Spacing.space3,
            right: Spacing.space3
        )
        
        return stackView
    }()

    var onTryAgainTapped: (() -> Void)?

    init() {
        super.init(frame: .zero)
        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, message: String, buttonText: String?) {
        if let buttonText = buttonText {
            tryAgainButton.setTitle(buttonText, for: .normal)
        } else {
            tryAgainButton.isHidden = true
        }
        
        titleLabel.text = title
        messageLabel.text = message
    }

    @objc private func tryAgainTapped() {
        onTryAgainTapped?()
    }
}

extension ModuleErrorView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(tryAgainButton)
    }

    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space3),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space3),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space3),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space3),
            
            tryAgainButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configureViews() {
        backgroundColor = Colors.offBackground.color
        layer.cornerRadius = CornerRadius.medium.rawValue
        clipsToBounds = true

        tryAgainButton.addTarget(self, action: #selector(tryAgainTapped), for: .touchUpInside)
    }

    func configureStyles() {
        titleLabel.font = Typography.titleFont
        titleLabel.textColor = Colors.textPrimary.color
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        messageLabel.font = Typography.subtitleFont
        messageLabel.textColor = Colors.textSecondary.color
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        tryAgainButton.setTitleColor(Colors.textPrimary.color, for: .normal)
        tryAgainButton.backgroundColor = Colors.background.color
        tryAgainButton.layer.cornerRadius = CornerRadius.medium.rawValue
        tryAgainButton.titleLabel?.font = Typography.titleFont
    }

    func configureAccessibility() {
        titleLabel.accessibilityTraits = .header
        tryAgainButton.accessibilityTraits = .button
    }
}
