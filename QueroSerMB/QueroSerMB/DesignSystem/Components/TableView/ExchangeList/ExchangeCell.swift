//
//  ExchangeCell.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 10/09/24.
//

import UIKit

class ExchangeCell: UITableViewCell {
    // MARK: - UI Components
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let exchangeIDLabel = UILabel()
    private let priceLabel = UILabel()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            iconImageView,
            infoStackView
        ])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            exchangeIDLabel,
            priceLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.spacing = 8
        return stackView
    }()
    
    static let identifier = "ExchangeCell"
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with model: ExchangeCellModel) {
        if let url = model.icon {
            iconImageView.loadImage(from: url)
        }
        nameLabel.text = model.name
        exchangeIDLabel.text = model.exchange
        priceLabel.text = model.price
    }
}

// MARK: - ViewConfiguration
extension ExchangeCell: ViewConfiguration {
    func buildViewHierarchy() {
        contentView.addSubview(mainStackView)
    }
    
    func setupConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.space3),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.space3),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.space3),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.space3),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureViews() {
        backgroundColor = .clear
        contentView.backgroundColor = Colors.offBackground.color
        iconImageView.contentMode = .scaleAspectFit
        selectionStyle = .none
        contentView.roundCorners(.allCorners, radius: .medium)
    }
    
    func configureStyles() {
        nameLabel.font = Typography.titleFont
        nameLabel.textColor = Colors.textPrimary.color
        
        exchangeIDLabel.font = Typography.captionFont
        exchangeIDLabel.textColor = Colors.textSecondary.color
        
        priceLabel.font = Typography.bodyFont
        priceLabel.textColor = Colors.textPrimary.color
        
    }
    
    func configureAccessibility() {
        isAccessibilityElement = true
        accessibilityLabel = "\(nameLabel.text ?? ""), \(exchangeIDLabel.text ?? ""), Preço: \(priceLabel.text ?? "")"
    }
}
