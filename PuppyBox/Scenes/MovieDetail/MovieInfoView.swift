//
//  MovieInfoView.swift
//  PuppyBox
//
//  Created by 김우성 on 7/17/25.
//

import SnapKit
import Then
import UIKit

class MovieInfoView: UIView {
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .heavy)
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private let adultIconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "18.circle.fill")
        $0.tintColor = .systemRed
        $0.isHidden = false
    }
    
    private let metaInfoLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private let metaDetailStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fillEqually
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private let overviewTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.text = "줄거리"
    }
    
    private let overviewLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        for item in [titleLabel, adultIconImageView, metaInfoLabel, metaDetailStackView, separatorView, overviewTitleLabel, overviewLabel] {
            addSubview(item)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().inset(20)
        }
        
        adultIconImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.width.height.equalTo(15)
        }
        
        metaInfoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        metaDetailStackView.snp.makeConstraints {
            $0.top.equalTo(metaInfoLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(metaDetailStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        overviewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.top.equalTo(overviewTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    private func setupMetaDetailContent(symbol: String, title: String, value: String) -> UIStackView {
        let hStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .leading
        }
        
        let iconImageView = UIImageView().then {
            $0.image = UIImage(systemName: symbol)
            $0.tintColor = .white
        }
        
        let vStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 1
            $0.alignment = .leading
        }
        
        let titleLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 8, weight: .bold)
            $0.textColor = .systemGray2
            $0.numberOfLines = 1
            $0.textAlignment = .left
            $0.text = title
        }
        
        let valueLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 8, weight: .regular)
            $0.textColor = .white
            $0.numberOfLines = 1
            $0.textAlignment = .left
            $0.text = value
        }
        
        [titleLabel, valueLabel].forEach { vStackView.addArrangedSubview($0) }
        [iconImageView, vStackView].forEach { hStackView.addArrangedSubview($0) }
        
        return hStackView
    }
    
    func configure(with movie: MovieResults) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        adultIconImageView.isHidden = !movie.adult
        
        let genreNames = movie.genreIds.compactMap { genreMap[$0]}
        let genreText = genreNames.joined(separator: ", ")
        metaInfoLabel.text = "\(movie.releaseDate) 개봉 | \(genreText)"
        
        for arrangedSubview in metaDetailStackView.arrangedSubviews {
            metaDetailStackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        [
            setupMetaDetailContent(symbol: "globe", title: "언어", value: movie.originalLanguage.uppercased()),
            setupMetaDetailContent(symbol: "star.leadinghalf.filled", title: "평점", value: String(format: "%.1f", movie.voteAverage)),
            setupMetaDetailContent(symbol: "chart.line.uptrend.xyaxis", title: "인기도", value: String(format: "%.2f", movie.popularity)),
        ].forEach { metaDetailStackView.addArrangedSubview($0) }
    }
}
