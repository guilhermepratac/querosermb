import UIKit

protocol MainDisplaying: AnyObject {
    func displayExchanges(exchanges: [ExchangeCellModel])
}

private extension MainViewController.Layout {
    enum Size {
    }
}

final class MainViewController: ViewController<MainInteracting> {
    fileprivate enum Layout { 
        // template
    }
    
    private let exchangeTableView = ExchangeListTableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.load()
    }

    override func buildViewHierarchy() {
        view.addSubview(exchangeTableView)
    }
    
    override func setupConstraints() {
        exchangeTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            exchangeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            exchangeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space3),
            exchangeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space3),
            exchangeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func configureViews() {
        exchangeTableView.delegate = self
        view.backgroundColor = Colors.background.color
    }
}

// MARK: - MainDisplaying
extension MainViewController: MainDisplaying {
    func displayExchanges(exchanges: [ExchangeCellModel]) {
        exchangeTableView.updateData(exchanges)
    }
}

// MARK: - ExchangeTableViewDelegate
extension MainViewController: ExchangeTableViewDelegate {
    func tap(_ view: ExchangeListTableView, didSelect index: Int) {
        print("Tap exchange")
    }
}

