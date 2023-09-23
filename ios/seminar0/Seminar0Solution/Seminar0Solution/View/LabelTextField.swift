//
//  LabelTextField.swift
//  Seminar0Solution
//
//  Created by user on 2023/09/23.
//

import UIKit

class LabelTextField: UIView {

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    private lazy var label = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var textField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .label
        textField.autocapitalizationType = .none
        return textField
    }()

    init(label: String, isSecure: Bool = false) {
        super.init(frame: .zero)
        textField.placeholder = label
        textField.isSecureTextEntry = isSecure
        self.label.text = label

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(label)
        addSubview(textField)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),

            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
