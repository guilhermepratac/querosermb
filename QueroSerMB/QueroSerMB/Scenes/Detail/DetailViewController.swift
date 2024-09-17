import UIKit

protocol DetailDisplaying: AnyObject {
    func displayDetail(with model: ExchangeInformationModel)
    func displayChart(data: [(Date, Double)])
    func displayChartError(title: String, message: String, button: String?)
    func displayLoading()
    func dismissLoading()
}

private extension DetailViewController.Layout {
    enum Size {
    }
}

final class DetailViewController: ViewController<DetailInteracting> {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let exchangeIDLabel = UILabel()
    private let dailyVolumeLabel = UILabel()
    
    private let loadingView = LoadingView()
    private let chartView = ExchangeChartView()
    private let errorView = ModuleErrorView()
    private let valueLabel = UILabel()
    
    private let hourVolumeLabel = UILabel()
    private let monthVolumeLabel = UILabel()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerStackView,
            dailyVolumeLabel,
            moduleChartStackView,
            valueLabel,
            hourVolumeLabel,
            monthVolumeLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Spacing.space3
        
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
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: Spacing.space3,
            left: Spacing.space3,
            bottom: Spacing.space3,
            right: Spacing.space3
        )
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
    
    
    private lazy var moduleChartStackView: UIStackView = {
        let stackView = UIStackView()
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)
    }
    
    override func setupConstraints() { 
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        chartView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.space3),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.space3),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.space3),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.space3),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 60),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            moduleChartStackView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    override func configureViews() {
        iconImageView.contentMode = .scaleAspectFit
        view.accessibilityIdentifier = "DetailView"
        nameLabel.accessibilityIdentifier = "ExchangeName"
        exchangeIDLabel.accessibilityIdentifier = "ExchangeID"
        dailyVolumeLabel.accessibilityIdentifier = "DailyVolume"
    }
    
    override func configureStyles() {
        view.backgroundColor = Colors.background.color
        headerStackView.backgroundColor = Colors.offBackground.color
        headerStackView.roundCorners(.allCorners, radius: .medium)
        
        nameLabel.font = Typography.titleFont
        nameLabel.textColor = Colors.textPrimary.color
        
        exchangeIDLabel.font = Typography.captionFont
        exchangeIDLabel.textColor = Colors.textSecondary.color
        
        dailyVolumeLabel.font = Typography.titleFont
        dailyVolumeLabel.textColor = Colors.textPrimary.color
        
        hourVolumeLabel.font = Typography.titleFont
        hourVolumeLabel.textColor = Colors.textPrimary.color
        
        monthVolumeLabel.font = Typography.titleFont
        monthVolumeLabel.textColor = Colors.textPrimary.color
        
        valueLabel.font = Typography.bodyFont
        valueLabel.textColor = Colors.textPrimary.color
        valueLabel.textAlignment = .center
    }
    
    private func updateValueLabel(date: Date, value: Double) {
        let dateString = date.toString(format: .displayFormat)
        
        valueLabel.text = "Data: \(dateString), Preço: \(value.toCurrency(.usd))"
    }
    
}

// MARK: - DetailDisplaying
extension DetailViewController: DetailDisplaying {
    func dismissLoading() {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating()
            self.moduleChartStackView.removeArrangedSubview(self.loadingView)
        }
    }
    
    func displayLoading() {
        DispatchQueue.main.async {
            self.moduleChartStackView.addArrangedSubview(self.loadingView)
            self.loadingView.startAnimating()
        }
    }
    
    func displayChartError(title: String, message: String, button: String?) {
        DispatchQueue.main.async {
            self.moduleChartStackView.removeAllArrangedSubviews()

            self.errorView.configure(title: title, message: message, buttonText: button)
            self.errorView.onTryAgainTapped = { [weak self] in
                self?.interactor.load()
            }
            
            self.moduleChartStackView.addArrangedSubview(self.errorView)
        }
    }
    
    func displayDetail(with model: ExchangeInformationModel) {
        if let url = model.urlImage {
            iconImageView.loadImage(from: url)
        }
        nameLabel.text = model.name
        exchangeIDLabel.text = model.exchangeId
        dailyVolumeLabel.text = model.dailyVolume
        monthVolumeLabel.text = model.monthVolume
        hourVolumeLabel.text = model.hourVolume
    }
    
    func displayChart(data: [(Date, Double)]) {
        DispatchQueue.main.async {
            self.moduleChartStackView.removeAllArrangedSubviews()
            self.chartView.data = data
            self.chartView.onPointSelected = { [weak self] date, value in
                self?.updateValueLabel(date: date, value: value)
            }
        }
    }
}
