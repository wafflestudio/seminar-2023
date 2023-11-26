//
//  HomeViewControllerViewModel.swift
//  Seminar3Solution
//
//  Created by user on 2023/10/28.
//

import Foundation
import Combine

class HomeViewControllerViewModel {
    let repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
        bindSearch()
    }

    private var movieViewModelsSubject = CurrentValueSubject<[HomeMovieCellViewModel], Never>([])
    var movieViewModels: AnyPublisher<[HomeMovieCellViewModel], Never> {
        movieViewModelsSubject.eraseToAnyPublisher()
    }

    private var searchTask: Task<Void, Never>?

    private var searchQuery = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()

    var nowPlayingMoviePage = 1

    func viewModel(at indexPath: IndexPath) -> HomeMovieCellViewModel {
        movieViewModelsSubject.value[indexPath.row]
    }

    func numberOfRows() -> Int {
        movieViewModelsSubject.value.count
    }

    private func fetchNowPlayingMovies(page: Int) async -> [HomeMovieCellViewModel] {
        guard let data = try? await repository.fetchNowPlayingMovies(page: page) else { return [] }
        print(data)
        let viewModels = data.results.map { HomeMovieCellViewModel(movie: $0) }
        return viewModels
    }

    func fetchInitialNowPlayingMovies() async {
        let viewModels = await fetchNowPlayingMovies(page: 1)
        movieViewModelsSubject.send(viewModels)
    }

    func fetchMoreNowPlayingMovies() async {
        nowPlayingMoviePage += 1
        let viewModels = await fetchNowPlayingMovies(page: nowPlayingMoviePage)
        let array = (movieViewModelsSubject.value + viewModels).removingDuplicates(byKey: { $0.id })
        movieViewModelsSubject.value = array
    }
}

extension HomeViewControllerViewModel {
    func updateSearchResults(query: String) {
        searchQuery.send(query)
    }

    private func bindSearch() {
        searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                guard let self else { return }
                searchTask?.cancel()
                searchTask = Task {
                    print("search \(query)")
                    guard let data = try? await self.repository.fetchSearchResults(query: query) else { fatalError() }
                    let viewModels = data.results.map { HomeMovieCellViewModel(movie: $0) }
                    print(viewModels)
                    self.movieViewModelsSubject.send(viewModels)
                }
            }
            .store(in: &cancellables)
    }
}

class HomeMovieCellViewModel: Identifiable {
    let movie: MovieDto

    init(movie: MovieDto) {
        self.movie = movie
    }

    var id: Int {
        movie.id
    }

    var posterURL: URL? {
        movie.posterAbsoluteURL
    }

    var movieTitle: String {
        movie.title
    }
}

extension Array {

    func removingDuplicates<T: Hashable>(byKey key: (Element) -> T)  -> [Element] {
         var result = [Element]()
         var seen = Set<T>()
         for value in self {
             if seen.insert(key(value)).inserted {
                 result.append(value)
             }
         }
         return result
     }

}
