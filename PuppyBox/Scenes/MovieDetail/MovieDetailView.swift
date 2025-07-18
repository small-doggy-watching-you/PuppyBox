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

// 위에서부터 포스터이미지, 이미지 위에 겹치는 그라데이션, 그 밑에 검정 백그라운드 뷰
// 백그라운드 뷰 안을 영화 정보 뷰(MovieInfoView), 그 밑에 예매 뷰(MovieBookingView)로 구성

class MovieDetailView: UIView {
    private let movieInfoView = MovieInfoView()
    let movieBookingView = MovieBookingView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    var onPosterTapped: (() -> Void)?
    var posterImage: UIImage? {
        return posterImageView.image
    }
    
    private let topGradientMaskView = GradientView().then { // 이미지 상단 (최상단) 그라데이션
        $0.colors = [
            UIColor.black,
            UIColor.clear
        ]
        $0.locations = [0.0, 1.0]
        
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    }
    
    private let gradientMaskView = GradientView().then { // 이미지 하단 (글자영역 상단) 그라데이션
        $0.colors = [
            UIColor.clear, // 위쪽 투명
            UIColor.black // 아래쪽 검정
        ]
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
    
    private let contentView = UIView().then { // 포스터 아래 영역용
        $0.backgroundColor = .black
        //        $0.clipsToBounds = true
    }
    
    private let posterTapView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .black
        
        [
            posterImageView,
            topGradientMaskView,
            scrollView
        ].forEach { addSubview($0) }
        
        posterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(posterImageView.snp.width)
        }
        
        topGradientMaskView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [
            gradientMaskView,
            posterTapView,
            contentView,
        ].forEach { scrollView.addSubview($0) }
        
        gradientMaskView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        posterTapView.snp.makeConstraints {
            $0.edges.equalTo(posterImageView)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(gradientMaskView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(scrollView.frameLayoutGuide) // 수직 스크롤만 되도록 고정
        }
        
        [
            movieInfoView,
            movieBookingView
        ].forEach { contentView.addSubview($0) }
        
        movieInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        movieBookingView.snp.makeConstraints {
            $0.top.equalTo(movieInfoView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(500)
        }
    }
    
    func configure(with movie: MovieResults) {
        movieInfoView.configure(with: movie)
    }
    
    func setPosterImage(_ image: UIImage?) {
        posterImageView.image = image
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPoster))
        posterTapView.isUserInteractionEnabled = true
        posterTapView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func didTapPoster() {
        onPosterTapped?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("gradientMaskView.bounds: \(gradientMaskView.bounds)")
    }
}

extension MovieDetailView {
    func kfSetPosterImage(with url: URL, options: KingfisherOptionsInfo? = nil) {
        posterImageView.kf.setImage(with: url, placeholder: nil, options: options)
    }
}
