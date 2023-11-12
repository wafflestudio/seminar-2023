//
//  MoviesTabBarController.swift
//  Seminar2Solution
//
//  Created by user on 2023/10/07.
//

import UIKit
import Alamofire

class MoviesTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = UINavigationController(rootViewController: UIViewController())
        homeVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)

        let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjZDgwYTk0MmUzNWI5ZDIzMjEzNzQxOWUyNjAxYWNkOCIsInN1YiI6IjYxODZhMTdlY2I2ZGI1MDA2MjM3MGE5OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.wHZKaFi45_2ssOAmKSGBiKDbcvg7ix8ip1bBZY3MDwE"
        let interceptor = Interceptor(token: token)
        let session = Session(interceptor: interceptor)
        let repository = NewHotMoviesRepository(session: session)
        let viewModel = NewHotMoviesViewControllerViewModel(repository: repository)

        let newHotVC = UINavigationController(rootViewController: NewHotMoviesViewController(viewModel: viewModel))
        newHotVC.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 1)

        viewControllers = [newHotVC]
    }
}
