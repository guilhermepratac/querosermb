import UIKit

/// Uma classe base para ViewControllers, configurada para gerenciar um interator e fornecer configuração padrão para a hierarquia de visualização, restrições, estilos e acessibilidade.
open class ViewController<Interactor>: UIViewController, ViewConfiguration {
    /// O interator associado a esta ViewController.
    public var interactor: Interactor

    /// Inicializador padrão que aceita um interator.
    /// - Parameter interactor: O interator a ser associado a esta ViewController.
    public init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    /// Inicializador necessário, mas indisponível.
    /// - Parameter aDecoder: O decodificador.
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Método chamado após a ViewController carregar a visualização na memória.
    /// Utilizado para imprimir informações de depuração e construir o layout da visualização.
    override open func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        print("NavigationDebug – " + String(describing: type(of: self)))
        #endif
        buildLayout()
    }

    /// Método para construir a hierarquia de visualização.
    open func buildViewHierarchy() { }

    /// Método para configurar as restrições da visualização.
    open func setupConstraints() { }

    /// Método para configurar os estilos da visualização.
    open func configureStyles() { }

    /// Método para configurar as propriedades da visualização.
    open func configureViews() { }

    /// Método para configurar as propriedades de acessibilidade da visualização.
    open func configureAccessibility() { }
}

public extension ViewController where Interactor == Void {
    /// Conveniência para inicializar a ViewController sem um interator.
    /// - Parameter interactor: O interator, padrão é vazio.
    convenience init(_ interactor: Interactor = ()) {
        self.init(interactor: interactor)
    }
}
