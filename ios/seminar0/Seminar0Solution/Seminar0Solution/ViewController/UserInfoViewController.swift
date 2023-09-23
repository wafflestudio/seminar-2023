//
//  UserInfoViewController.swift
//  Seminar0Solution
//
//  Created by user on 2023/09/23.
//

import UIKit

class UserInfoViewController: UIViewController {
    private var userInfo: UserInfo! {
        didSet {
            usernameField.text = userInfo?.username
            emailField.text = userInfo?.email
        }
    }

    private let repository: any UserInfoRepositoryProtocol

    init(repository: any UserInfoRepositoryProtocol) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "유저 정보"
        userInfo = repository.getUserInfo()
        setupLayout()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.hidesBackButton = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var stackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    private lazy var usernameField = LabelTextField(label: "Username")
    private lazy var emailField = LabelTextField(label: "Email")
    private lazy var logoutButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemPink
        let btn = UIButton(configuration: config)
        btn.setTitle("로그아웃", for: .normal)
        btn.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return btn
    }()

    private func setupLayout() {
        view.addSubview(stackView)

        usernameField.isUserInteractionEnabled = false
        emailField.isUserInteractionEnabled = false

        stackView.addArrangedSubview(usernameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(logoutButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func editButtonTapped() {
        let editVC = EditUserInfoViewController(userInfo: userInfo)
        let navVC = UINavigationController(rootViewController:  editVC)
        navVC.modalPresentationStyle = .pageSheet
        editVC.delegate = self
        present(navVC, animated: true)
    }

    @objc private func logoutButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension UserInfoViewController: EditUserInfoViewControllerDelegate {
    func editUserInfoViewController(
        _ viewController: EditUserInfoViewController, 
        didUpdateUserInfoTo newUserInfo: UserInfo)
    {
        userInfo = newUserInfo
        repository.setUserInfo(newUserInfo)
    }
}
