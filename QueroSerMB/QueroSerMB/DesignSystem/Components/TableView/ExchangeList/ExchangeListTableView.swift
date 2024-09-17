//
//  ExchangesTableView.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 10/09/24.
//

import UIKit

protocol ExchangeTableViewDelegate: AnyObject {
    func tap(_ view: ExchangeListTableView, didSelect index: Int)
}

class ExchangeListTableView: UIView {
    // MARK: - Properties
    private let tableView: UITableView
    private var model: [ExchangeCellModel] = []
    weak var delegate: ExchangeTableViewDelegate?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        self.tableView = UITableView(frame: .zero, style: .plain)
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func updateData(_ model: [ExchangeCellModel]) {
        DispatchQueue.main.async {
            self.model = model
            self.tableView.reloadData()
        }
    }
}

extension ExchangeListTableView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureViews() {
        tableView.register(ExchangeCell.self, forCellReuseIdentifier: ExchangeCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    func configureStyles() {
        backgroundColor = Colors.background.color
    }
    
    func configureAccessibility() {
        tableView.accessibilityIdentifier = "ExchangeListTable"
    }
}

// MARK: - UITableViewDataSource
extension ExchangeListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeCell.identifier, for: indexPath) as? ExchangeCell else {
            return UITableViewCell()
        }
        
        let model = model[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ExchangeListTableView: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.tap(self, didSelect: indexPath.row)
    }
}
