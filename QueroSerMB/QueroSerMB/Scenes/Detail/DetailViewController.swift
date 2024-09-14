import UIKit

protocol DetailDisplaying: AnyObject {
    func displayDetail(urlImage: String?, name: String, exchangeID: String, price: String)
    func displayChart(data: [(Date, Double)])
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

        interactor.load()
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
        let dateString = date.toString(format: .displayFormat)
        
        valueLabel.text = "Date: \(dateString), Price: \(value.toCurrency(.usd))"
    }
}

// MARK: - DetailDisplaying
extension DetailViewController: DetailDisplaying {
    func displayChart(data: [(Date, Double)]) {
        DispatchQueue.main.async {
            self.chartView.data = data
            self.chartView.onPointSelected = { [weak self] date, value in
                self?.updateValueLabel(date: date, value: value)
            }
        }
    }
    
    func displayDetail(urlImage: String?, name: String, exchangeID: String, price: String) {
        if let url = urlImage {
            iconImageView.loadImage(from: url)
        }
        nameLabel.text = name
        exchangeIDLabel.text = exchangeID
        priceLabel.text = price
    }
}
