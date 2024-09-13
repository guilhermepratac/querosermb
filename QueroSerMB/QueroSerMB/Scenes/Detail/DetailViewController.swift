import UIKit

protocol DetailDisplaying: AnyObject {
    func displaySomething()
}

private extension DetailViewController.Layout {
    enum Size {
    }
}

final class DetailViewController: ViewController<DetailInteracting> {
    fileprivate enum Layout {
        // template
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.loadSomething()
    }

    override func buildViewHierarchy() { 
        // template
    }
    
    override func setupConstraints() { 
        // template
    }

    override func configureViews() { 
        // template
    }
}

// MARK: - DetailDisplaying
extension DetailViewController: DetailDisplaying {
    func displaySomething() { 
        // template
    }
}
