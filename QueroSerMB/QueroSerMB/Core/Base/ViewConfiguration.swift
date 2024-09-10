import Foundation

/// Protocolo que define a configuração da visualização para componentes do Artemis.
///
public protocol ViewConfiguration: AnyObject {
    /// Constrói a hierarquia de visualizações.
    func buildViewHierarchy()

    /// Configura as restrições de layout.
    func setupConstraints()

    /// Configura as propriedades da visualização.
    func configureViews()

    /// Configura os estilos da visualização.
    func configureStyles()

    /// Configura a acessibilidade da visualização.p
    func configureAccessibility()

    /// Constrói o layout completo da visualização.
    func buildLayout()

    /// Atualiza a visualização com configurações de propriedades e estilos.
    func updateView()
}

public extension ViewConfiguration {
    /// Atualiza a visualização com configurações de propriedades e estilos.
    func updateView() {
        configureViews()
        configureStyles()
    }

    /// Constrói o layout completo da visualização, incluindo hierarquia, restrições, propriedades, estilos e acessibilidade.
    func buildLayout() {
        buildViewHierarchy()
        setupConstraints()
        configureViews()
        configureStyles()
        configureAccessibility()
    }

    /// Configura as propriedades da visualização. Implementação padrão faz nada.
    func configureViews() { }

    /// Configura os estilos da visualização. Implementação padrão faz nada.
    func configureStyles() { }

    /// Configura a acessibilidade da visualização. Implementação padrão faz nada.
    func configureAccessibility() {}
}
