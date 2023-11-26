import Foundation

class NewHotMoviesViewControllerViewModel {
    weak var delegate: NewHotMoviesViewControllerViewModelDelegate?
    let repository: NewHotMoviesRepository

    var upcomingMovieViewModels = [NewHotMoviesCellViewModel]()
    var upcomingMoviePage = 1
    let upcomingTotalPages = 3

    var popularMovieViewModels = [NewHotMoviesCellViewModel]()
    var popularMoviePage = 1
    let popularTotalPages = 3

    init(repository: NewHotMoviesRepository) {
        self.repository = repository
    }

    func numberOfRows(in section: Int) -> Int {
        let section = NewHotMoviesSection(rawValue: section)
        switch section {
        case .upcoming:
            return upcomingMovieViewModels.count
        case .popular:
            return popularMovieViewModels.count
        case nil:
            fatalError()
        }
    }

    func movieViewModel(at indexPath: IndexPath) -> NewHotMoviesCellViewModel {
        let section = NewHotMoviesSection(rawValue: indexPath.section)
        switch section {
        case .upcoming:
            return upcomingMovieViewModels[indexPath.row]
        case .popular:
            return popularMovieViewModels[indexPath.row]
        case nil:
            fatalError()
        }
    }

    func fetchKeywords(for movieId: Int) async -> [KeywordDto] {
        guard let response = try? await repository.fetchKeywords(for: movieId) else {
            return [] }
        try? await Task.sleep(nanoseconds: NSEC_PER_SEC * 1)
        return response.keywords
    }
}

// MARK: Upcoming

extension NewHotMoviesViewControllerViewModel {
    @discardableResult
    private func fetchUpcomingMovies(page: Int) async -> [NewHotMoviesCellViewModel] {
        guard let data = try? await repository.fetchUpcomingMovies(page: page) else { return [] }
        let viewModels = data.results.map {
            let viewModel = NewHotMoviesCellViewModel(movie: $0)
            viewModel.moviesViewControllerViewModel = self
            return viewModel
        }
        return viewModels
    }

    func fetchInitialUpcomingMovies() async {
        let viewModels = await fetchUpcomingMovies(page: 1)
        let newIndexPaths = (0..<viewModels.count).map { IndexPath(row: $0, section: NewHotMoviesSection.upcoming.rawValue) }
        upcomingMovieViewModels = viewModels
        delegate?.newHotMoviesViewControllerViewModel(self, didInsertViewModels: viewModels, at: newIndexPaths)
    }

    func fetchMoreUpcomingMovies() async {
        guard upcomingMoviePage < upcomingTotalPages else { return }
        upcomingMoviePage += 1
        let viewModels = await fetchUpcomingMovies(page: upcomingMoviePage)
        let newIndexPaths = (upcomingMovieViewModels.count..<upcomingMovieViewModels.count + viewModels.count).map { IndexPath(row: $0, section: NewHotMoviesSection.upcoming.rawValue) }
        upcomingMovieViewModels.append(contentsOf: viewModels)
        delegate?.newHotMoviesViewControllerViewModel(self, didInsertViewModels: viewModels, at: newIndexPaths)

        if upcomingMoviePage == upcomingTotalPages {
            await fetchInitialPopularMovies()
        }
    }
}

// MARK: Popular

extension NewHotMoviesViewControllerViewModel {
    @discardableResult
    private func fetchPopularMovies(page: Int) async -> [NewHotMoviesCellViewModel] {
        guard let data = try? await repository.fetchPopularMovies(page: page) else { return [] }
        let viewModels = data.results.map {
            let viewModel = NewHotMoviesCellViewModel(movie: $0)
            viewModel.moviesViewControllerViewModel = self
            return viewModel
        }
        return viewModels
    }

    func fetchInitialPopularMovies() async {
        let viewModels = await fetchPopularMovies(page: 1)
        let newIndexPaths = (0..<viewModels.count).map { IndexPath(row: $0, section: NewHotMoviesSection.popular.rawValue) }
        popularMovieViewModels = viewModels
        delegate?.newHotMoviesViewControllerViewModel(self, didInsertViewModels: viewModels, at: newIndexPaths)
    }

    func fetchMorePopularMovies() async {
        guard popularMoviePage < popularTotalPages else { return }
        popularMoviePage += 1
        let viewModels = await fetchPopularMovies(page: popularMoviePage)
        let newIndexPaths = (popularMovieViewModels.count..<popularMovieViewModels.count + viewModels.count).map { IndexPath(row: $0, section: NewHotMoviesSection.popular.rawValue) }
        popularMovieViewModels.append(contentsOf: viewModels)
        delegate?.newHotMoviesViewControllerViewModel(self, didInsertViewModels: viewModels, at: newIndexPaths)
    }
}


protocol NewHotMoviesViewControllerViewModelDelegate: AnyObject {
    func newHotMoviesViewControllerViewModel(
        _ viewModel: NewHotMoviesViewControllerViewModel,
        didInsertViewModels newViewModels: [NewHotMoviesCellViewModel],
        at indexPaths: [IndexPath]
    )
}
