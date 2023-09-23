//
//  LoginViewController.swift
//  Seminar0Solution
//
//  Created by user on 2023/09/03.
//

import UIKit

class LoginViewController: UIViewController {

    let repository: any UserInfoRepositoryProtocol

    init(repository: some UserInfoRepositoryProtocol) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var usernameField = LabelTextField(label: "Username")
    private lazy var emailField = LabelTextField(label: "Email")
    private lazy var passwordField = LabelTextField(label: "Password", isSecure: true)

    private lazy var stackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    private lazy var loginButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemPink
        let btn = UIButton(configuration: config)
        btn.setTitle("로그인", for: .normal)
        btn.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setupLayout()
        title = "로그인"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameField.text = nil
        emailField.text = nil
        passwordField.text = nil
    }

    private func setupLayout() {
        view.addSubview(stackView)

        stackView.addArrangedSubview(usernameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(loginButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func loginButtonTapped() {
        guard let username = usernameField.text,
              let email = emailField.text else { return }

        if username.count < 3 {
            // show alert here
            let alert = UIAlertController(title: "에러", message: "username은 세 글자 이상이어야 합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "넹", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }

        let userInfo = UserInfo(username: username, email: email)
        repository.setUserInfo(userInfo)
        let toVC = UserInfoViewController(repository: repository)
        navigationController?.pushViewController(toVC, animated: true)
    }
}
