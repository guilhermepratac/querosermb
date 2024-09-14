import UIKit

protocol DetailDisplaying: AnyObject {
    func displayDetail(urlImage: String?, name: String, exchangeID: String, price: String)
}

private extension DetailViewController.Layout {
    enum Size {
    }
}

final class DetailViewController: ViewController<DetailInteracting> {
    
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let exchangeIDLabel = UILabel()
    private let priceLabel = UILabel()
    
    private let chartView = ExchangeChartView()
    private let valueLabel = UILabel()

    private let chartData: [(Date, Double)] = [
        (Date(timeIntervalSince1970: 1633046400), 150000),
        (Date(timeIntervalSince1970: 1640995200), 225000),
        (Date(timeIntervalSince1970: 1648771200), 350000),
        (Date(timeIntervalSince1970: 1656633600), 325000),
        (Date(timeIntervalSince1970: 1664582400), 334763.63)
    ]
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerStackView,
            priceLabel,
            chartView,
            valueLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Spacing.space2
        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            iconImageView,
            infoStackView
        ])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = Spacing.space2
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            exchangeIDLabel,
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = Spacing.space2
        return stackView
    }()
    
    fileprivate enum Layout {
        // template
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.loadSomething()
    }

    override func buildViewHierarchy() { 
        view.addSubview(contentStackView)
    }
    
    override func setupConstraints() { 
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.space3),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.space3),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.space3),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 60),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            chartView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    override func configureViews() {
        iconImageView.contentMode = .scaleAspectFit
    }
    
    override func configureStyles() {
        view.backgroundColor = Colors.background.color
        
        nameLabel.font = Typography.titleFont
        nameLabel.textColor = Colors.textPrimary.color
        
        exchangeIDLabel.font = Typography.captionFont
        exchangeIDLabel.textColor = Colors.textSecondary.color
        
        priceLabel.font = Typography.bodyFont
        priceLabel.textColor = Colors.textPrimary.color
        
        valueLabel.font = Typography.bodyFont
        valueLabel.textColor = Colors.textPrimary.color
        valueLabel.textAlignment = .center
    }
    
    private func updateValueLabel(date: Date, value: Double) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        let valueString = String(format: "%.2f", value)
        
        valueLabel.text = "Date: \(dateString), Value: R$ \(valueString)"
    }
}

// MARK: - DetailDisplaying
extension DetailViewController: DetailDisplaying {
    func displayDetail(urlImage: String?, name: String, exchangeID: String, price: String) {
        if let url = urlImage {
            iconImageView.loadImage(from: url)
        }
        nameLabel.text = name
        exchangeIDLabel.text = exchangeID
        priceLabel.text = price
        
        chartView.data = chartData
        chartView.onPointSelected = { [weak self] date, value in
            self?.updateValueLabel(date: date, value: value)
        }
    }
}
