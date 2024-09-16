//
//  LoadingView.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 16/09/24.
//

import UIKit

class LoadingView: UIView {
    private let activityIndicator: UIActivityIndicatorView

    init() {
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func startAnimating() {
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
