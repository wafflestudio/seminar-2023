//
//  ViewController.swift
//  Seminar2Practice
//
//  Created by user on 2023/10/08.
//

import UIKit
import Kingfisher
import SnapKit
import Alamofire

class ViewController: UIViewController {

    var movies = [MovieDTO]()

    lazy var tableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseIdentifier)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        Task {
            let fetchedMovies = await fetchUpcomingMovies()
            movies.append(contentsOf: fetchedMovies)
            tableView.reloadData()
        }

    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier) as? MovieCell else { fatalError() }
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

}

class MovieCell: UITableViewCell {
    static let reuseIdentifier = "MovieCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: MovieDTO) {
        posterImageView.kf.setImage(
            with: movie.posterAbsoluteURL,
            options: [
                .processor(DownsamplingImageProcessor(size: .init(width: 400, height: 200))),
                .transition(.fade(0.25))
            ]
        )
    }
}

let token = "Your token here"


class Interceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
}

let session = Session(interceptor: Interceptor())

struct PaginatedMoviesResponseDTO: Codable {
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int
}

struct MovieDTO: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String

    var posterAbsoluteURL: URL {
        let urlString = "https://image.tmdb.org/t/p/original/\(posterPath)"
        return URL(string: urlString)!
    }
}

func fetchUpcomingMovies() async -> [MovieDTO] {
    var decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    let response = try! await session.request("https://api.themoviedb.org/3/movie/upcoming")
        .serializingDecodable(PaginatedMoviesResponseDTO.self, decoder: decoder)
        .value
    print(response.results.first?.title)
    return response.results
}

