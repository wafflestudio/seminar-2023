import UIKit
import Kingfisher

class NewHotMoviesCell: UITableViewCell {
    static let reuseIdentifier = "NewHotMoviesCell"

    weak var tableView: UITableView?
    var indexPath: IndexPath?

    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.cornerCurve = .continuous
        return imageView
    }()

    let keywordsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .tertiaryLabel
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [posterImageView, movieTitleLabel, descriptionLabel, keywordsLabel])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private var keywordFetchTask: Task<Void, Error>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    private var loadImageTask: Task<Void, Never>?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        posterImageView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
    }


    func configure(with viewModel: NewHotMoviesCellViewModel) {
        movieTitleLabel.text = viewModel.movieTitle
        descriptionLabel.text = viewModel.overview
        loadImage(from: viewModel.posterURL, into: posterImageView)
        keywordFetchTask = Task { @MainActor in
            let keywordString = await viewModel.keywordsString
            try Task.checkCancellation()
            keywordsLabel.text = keywordString
            keywordsLabel.isHidden = keywordString.isEmpty
            self.invalidateIntrinsicContentSize()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        keywordsLabel.text = nil
        keywordsLabel.isHidden = true
        keywordFetchTask?.cancel()
        keywordFetchTask = nil
    }

    private func loadImage(from url: URL, into imageView: UIImageView) {
        imageView.kf.setImage(
            with: url,
            options: [
                .processor(DownsamplingImageProcessor(size: .init(width: 393, height: 800))),
                .transition(.fade(0.25)),
                .cacheMemoryOnly
            ]
        )
    }
}
