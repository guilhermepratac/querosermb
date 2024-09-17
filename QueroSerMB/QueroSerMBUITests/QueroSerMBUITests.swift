import XCTest
@testable import QueroSerMB

class QueroSerMBUITableDataTests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testMainScreenLoadsExchangeList() throws {
        let exchangeListTable = app.tables["ExchangeListTable"]
        XCTAssertTrue(exchangeListTable.exists, "A tabela de câmbios deve estar presente na tela principal")
        
        let cell = exchangeListTable.cells["ExchangeCell"].firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 5), "Pelo menos uma célula de câmbio deve ser carregada")
        
        XCTAssertTrue(cell.images["ExchangeIconImageView"].exists, "O ícone da exchange deve estar presente")
        XCTAssertTrue(cell.staticTexts["ExchangeNameLabel"].exists, "O nome da exchange deve estar presente")
        XCTAssertTrue(cell.staticTexts["ExchangeIDLabel"].exists, "O ID da exchange deve estar presente")
        XCTAssertTrue(cell.staticTexts["ExchangeValueLabel"].exists, "O valor da exchange deve estar presente")
    }
        
    func testNavigationToDetailScreen() throws {
        let exchangeListTable = app.tables["ExchangeListTable"]
        
        let firstCell = exchangeListTable.cells["ExchangeCell"].firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "A primeira célula deve existir")
        
        let exchangeName = firstCell.staticTexts["ExchangeNameLabel"].label
        firstCell.tap()
        
        let detailView = app.otherElements["DetailView"]
        XCTAssertTrue(detailView.waitForExistence(timeout: 5), "A tela de detalhes deve ser exibida após tocar em uma célula")
        
        XCTAssertTrue(detailView.staticTexts[exchangeName].exists, "O nome da exchange selecionada deve estar presente na tela de detalhes")
        XCTAssertTrue(detailView.staticTexts["ExchangeID"].exists, "O ID da exchange deve estar presente na tela de detalhes")
        XCTAssertTrue(detailView.staticTexts["DailyVolume"].exists, "O volume diário deve estar presente na tela de detalhes")
    }
    
    func testExchangeCellContent() throws {
        let exchangeListTable = app.tables["ExchangeListTable"]
        let firstCell = exchangeListTable.cells["ExchangeCell"].firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "A primeira célula deve existir")
        
        let iconImage = firstCell.images["ExchangeIconImageView"]
        let nameLabel = firstCell.staticTexts["ExchangeNameLabel"]
        let idLabel = firstCell.staticTexts["ExchangeIDLabel"]
        let valueLabel = firstCell.staticTexts["ExchangeValueLabel"]
        
        XCTAssertTrue(iconImage.exists, "O ícone da exchange deve estar presente")
        XCTAssertFalse(nameLabel.label.isEmpty, "O nome da exchange não deve estar vazio")
        XCTAssertFalse(idLabel.label.isEmpty, "O ID da exchange não deve estar vazio")
        XCTAssertTrue(valueLabel.label.contains("$"), "O valor da exchange deve conter o símbolo de dólar")
    }
}
