import UIKit

protocol MainDisplaying: AnyObject {
    func displaySomething()
}

private extension MainViewController.Layout {
    enum Size {
    }
}

final class MainViewController: ViewController<MainInteracting> {
    fileprivate enum Layout { 
        // template
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.loadSomething()
    }

    override func buildViewHierarchy() {
    }
    
    override func setupConstraints() {
    }

    override func configureViews() {
    }
}

// MARK: - MainDisplaying
extension MainViewController: MainDisplaying {
    func displaySomething() { 
        // template
    }
}
