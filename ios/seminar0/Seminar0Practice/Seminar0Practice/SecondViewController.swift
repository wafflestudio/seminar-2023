//
//  SecondViewController.swift
//  Seminar0Practice
//
//  Created by user on 2023/09/03.
//

import UIKit

class SecondViewController: UIViewController {
    let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        //        label.text = "hello world"
        button.frame = view.frame
        button.backgroundColor = .blue
        view.backgroundColor = .white
        title = "네비게이션 타이틀"
        view.addSubview(button)
        // Do any additional setup after loading the view.
        button.setTitle("버튼", for: .normal)
        button.backgroundColor = UIColor.cyan
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.addAction(.init(handler: { _f in
            self.buttonTapped()
        }), for: .touchUpInside)

        let textField = UITextField()
        textField.placeholder = "username"
    }

    let button = UIButton()

    func buttonTapped() {
        let viewController = SecondViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
