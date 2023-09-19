//
//  ViewController.swift
//  Seminar0Practice
//
//  Created by user on 2023/09/03.
//

import UIKit

class ViewController: UIViewController {
    let view1 = UIView()
    let view2 = UIView()
    let button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\

        view.backgroundColor = .yellow

        view1.backgroundColor = .red
        view2.backgroundColor = .blue
        view1.translatesAutoresizingMaskIntoConstraints = false
        view2.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(view1)
        view.addSubview(view2)
        view.addSubview(button)

        button.setTitle("버튼", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view1.bottomAnchor),
            button.centerXAnchor.constraint(equalTo: view1.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 50),
            view1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.heightAnchor.constraint(equalToConstant: 100),
            view1.topAnchor.constraint(equalTo: view.topAnchor),
            view1.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view1.heightAnchor.constraint(equalToConstant: 200),
        ])
    }

    @objc func buttonTapped() {
        let viewController = SecondViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true)
    }

    func hello(color: UIColor) {

    }
}

