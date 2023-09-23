//
//  EditUserInfoViewController.swift
//  Seminar0Solution
//
//  Created by user on 2023/09/23.
//

import UIKit

class EditUserInfoViewController: UIViewController {

    weak var delegate: EditUserInfoViewControllerDelegate?
    var userInfo: UserInfo

    private lazy var usernameField = LabelTextField(label: "Username")
    private lazy var emailField = LabelTextField(label: "Email")

    private lazy var stackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "정보 편집"
        setupLayout()
        usernameField.text = userInfo.username
        emailField.text = userInfo.email
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
    }

    @objc private func doneButtonTapped() {
        userInfo.username = usernameField.text ?? ""
        userInfo.email = emailField.text ?? ""

        if userInfo.username.count < 3 {
            // show alert here
            let alert = UIAlertController(title: "에러", message: "username은 세 글자 이상이어야 합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "넹", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }

        delegate?.editUserInfoViewController(self, didUpdateUserInfoTo: userInfo)
        dismiss(animated: true)
    }

    private func setupLayout() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(usernameField)
        stackView.addArrangedSubview(emailField)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}


protocol EditUserInfoViewControllerDelegate: AnyObject {
    func editUserInfoViewController(
        _ viewController: EditUserInfoViewController,
        didUpdateUserInfoTo newUserInfo: UserInfo
    )
}

