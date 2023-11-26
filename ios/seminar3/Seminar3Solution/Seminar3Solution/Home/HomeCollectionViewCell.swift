//
//  HomeCollectionViewCell.swift
//  Seminar3Solution
//
//  Created by user on 2023/10/28.
//

import Foundation
import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "HomeCollectionViewCell"

    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.cornerCurve = .continuous
        return imageView
    }()

    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackView.addArrangedSubview(posterImageView)
        stackView.addArrangedSubview(titleLabel)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: HomeMovieCellViewModel) {
        loadImage(from: viewModel.posterURL, into: posterImageView)
        titleLabel.text = viewModel.movieTitle
    }

    private func loadImage(from url: URL?, into imageView: UIImageView) {
        imageView.kf.setImage(
            with: url,
            options: [
                .processor(DownsamplingImageProcessor(size: .init(width: 200, height: 200))),
                .transition(.fade(0.25)),
                .cacheMemoryOnly
            ]
        )
    }
}


