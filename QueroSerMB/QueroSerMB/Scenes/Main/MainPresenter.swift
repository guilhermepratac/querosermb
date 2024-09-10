protocol MainPresenting: AnyObject {
    func displaySomething()
    func didNextStep()
}

final class MainPresenter {
    private let coordinator: MainCoordinating
    weak var viewController: MainDisplaying?

    init(coordinator: MainCoordinating) {
        self.coordinator = coordinator
    }
}

// MARK: - MainPresenting
extension MainPresenter: MainPresenting {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep() {
        coordinator.openSomething()
    }
}
