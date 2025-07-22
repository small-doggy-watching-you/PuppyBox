//
//  MovieDetailView.swift
//  PuppyBox
//
//  Created by 김우성 on 7/16/25.
//

import Kingfisher
import SnapKit
import Then
import UIKit

// MARK: - 영화 상세 뷰

class MovieDetailView: UIView {
    // MARK: - UI 구성요소

    private let movieInfoView = MovieInfoView()
    let movieBookingView = MovieBookingView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    var onPosterTapped: (() -> Void)?
    var posterImage: UIImage? { return posterImageView.image }
    
    private let gradientMaskView = GradientView().then {
        $0.colors = [UIColor.clear, UIColor.black]
        $0.locations = [0.0, 1.0]
        $0.isUserInteractionEnabled = false
    }

    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray5
        $0.clipsToBounds = true
    }

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }

    private let contentView = UIView().then {
        $0.backgroundColor = .black
    }

    private let posterTapView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - 초기화

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupGesture()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - UI 구성

    private func configureUI() {
        backgroundColor = .black
        [posterImageView, scrollView].forEach { addSubview($0) }
        
        posterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.5)
        }
        
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        [gradientMaskView, posterTapView, contentView].forEach { scrollView.addSubview($0) }
        gradientMaskView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        posterTapView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(gradientMaskView.snp.bottom)
        }
        contentView.snp.makeConstraints {
            $0.top.equalTo(gradientMaskView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        [movieInfoView, movieBookingView].forEach { contentView.addSubview($0) }
        movieInfoView.snp.makeConstraints { $0.top.leading.trailing.equalToSuperview() }
        movieBookingView.snp.makeConstraints {
            $0.top.equalTo(movieInfoView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(500)
        }
    }
    
    // MARK: - 외부 설정

    func configure(with movie: MovieResults) {
        movieInfoView.configure(with: movie)
    }

    func setPosterImage(_ image: UIImage?) {
        posterImageView.image = image
    }
    
    // MARK: - 포스터 탭 제스처

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPoster))
        posterTapView.isUserInteractionEnabled = true
        posterTapView.addGestureRecognizer(tapGesture)
    }

    @objc private func didTapPoster() {
        onPosterTapped?()
    }
}

// MARK: - 포스터 로딩 Kingfisher 헬퍼

extension MovieDetailView {
    func kfSetPosterImage(with url: URL, options: KingfisherOptionsInfo? = nil) {
        posterImageView.kf.setImage(with: url, placeholder: nil, options: options)
    }
}
