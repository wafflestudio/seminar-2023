import UIKit
import Foundation

class NewHotMoviesCellViewModel {
    let movie: MovieDto
    var keywords: [KeywordDto]?
    weak var moviesViewControllerViewModel: NewHotMoviesViewControllerViewModel?

    init(movie: MovieDto) {
        self.movie = movie
    }

    var id: Int {
        movie.id
    }

    var movieTitle: String {
        movie.title
    }

    var overview: String {
        movie.overview
    }

    var posterURL: URL {
        movie.posterAbsoluteURL
    }

    var keywordsString: String {
        get async {
            if keywords == nil {
                keywords = await moviesViewControllerViewModel?.fetchKeywords(for: movie.id)
            }
            guard let keywords else { fatalError() }
            if keywords.isEmpty {
                return "키워드 없음"
            }
            return keywords.map({ $0.name }).joined(separator: " · ")
        }
    }
}


