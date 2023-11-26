//
//  NewHotMoviesViewController.swift
//  Seminar2Solution
//
//  Created by user on 2023/10/07.
//

import UIKit
import SnapKit
import Kingfisher

enum NewHotMoviesSection: Int, CaseIterable {
    case upcoming = 0
    case popular = 1
}

class NewHotMoviesViewController: UIViewController {
    let viewModel: NewHotMoviesViewControllerViewModel

    init(viewModel: NewHotMoviesViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NEW & HOT"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupLayout()
        tableView.register(NewHotMoviesCell.self, forCellReuseIdentifier: NewHotMoviesCell.reuseIdentifier)
        tableView.register(NewHotMoviesHeaderView.self, forHeaderFooterViewReuseIdentifier: NewHotMoviesHeaderView.reuseIdentifier)
        Task { @MainActor in
            await viewModel.fetchInitialUpcomingMovies()
        }
    }

    private lazy var tableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        return tableView
    }()

    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension NewHotMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewHotMoviesHeaderView.reuseIdentifier) as? NewHotMoviesHeaderView else {
            return nil
        }

        if let sectionType = NewHotMoviesSection(rawValue: section) {
            switch sectionType {
            case .upcoming:
                header.titleLabel.text = "Upcoming Movies"
            case .popular:
                header.titleLabel.text = "Popular Movies"
            }
        }

        return header
    }
}

extension NewHotMoviesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        NewHotMoviesSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewHotMoviesCell.reuseIdentifier, for: indexPath) as? NewHotMoviesCell else { fatalError() }
        let movieViewModel = viewModel.movieViewModel(at: indexPath)
        cell.configure(with: movieViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = NewHotMoviesSection(rawValue: indexPath.section) else { return }
        switch section {
        case .upcoming:
            let fetchedUpcomingCount = viewModel.numberOfRows(in: indexPath.section)
            guard indexPath.row >= fetchedUpcomingCount - 1 else { return }
            Task { @MainActor in
                await viewModel.fetchMoreUpcomingMovies()
            }
        case .popular:
            let fetchedPopularCount = viewModel.numberOfRows(in: indexPath.section)
            guard indexPath.row >= fetchedPopularCount - 1 else { return }
            Task { @MainActor in
                await viewModel.fetchMoreUpcomingMovies()
            }
        }
    }
}

extension NewHotMoviesViewController: NewHotMoviesViewControllerViewModelDelegate {
    func newHotMoviesViewControllerViewModel(_ viewModel: NewHotMoviesViewControllerViewModel, didInsertViewModels newViewModels: [NewHotMoviesCellViewModel], at indexPaths: [IndexPath]) {
        Task { @MainActor in
            self.tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
}
