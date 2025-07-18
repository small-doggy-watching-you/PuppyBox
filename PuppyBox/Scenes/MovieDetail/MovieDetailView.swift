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
// 백그라운드 뷰 안을 영화 정보 뷰(MovieInfoView), 그 밑에 예매 뷰(추가예정)로 구성

class MovieDetailView: UIView {
    var onPosterTapped: (() -> Void)?
    var posterImage: UIImage? {
        return posterImageView.image
    }

    private let movieInfoView = MovieInfoView()
    
    private let topGradientMaskView = UIView().then { // 이미지 상단 (최상단) 그라데이션
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    }
    
    private let gradientMaskView = UIView().then { // 이미지 하단 (글자영역 상단) 그라데이션
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    }
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray5
        $0.clipsToBounds = true
    }
    
    private let blackBackgroundView = UIView().then { // 글씨 영역용
        $0.backgroundColor = .black
        $0.clipsToBounds = true
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
        
        for item in [posterImageView, topGradientMaskView, gradientMaskView, blackBackgroundView] {
            addSubview(item)
        }
        
        topGradientMaskView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
        
        posterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(posterImageView.snp.width)
        }
        
        gradientMaskView.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(-100) // 겹치기
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100) // 위에랑 같이 설정하기
        }
        
        blackBackgroundView.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        blackBackgroundView.addSubview(movieInfoView)
        
        movieInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        posterImageView.isUserInteractionEnabled = true
        posterImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func didTapPoster() {
        onPosterTapped?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient()
        applyTopGradient()
    }
    
    private func applyTopGradient() {
        topGradientMaskView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.4).cgColor, // 위쪽은 살짝 어둡게
            UIColor.clear.cgColor // 아래로 갈수록 투명
        ]
        gradient.locations = [0.0, 1.0]
        gradient.frame = topGradientMaskView.bounds
        topGradientMaskView.layer.insertSublayer(gradient, at: 0)
    }
    
    private func applyGradient() {
        gradientMaskView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer }) // 이미 있으면 제거
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor, // 위쪽 투명
            UIColor.black.cgColor // 아래쪽 검정
        ]
        gradient.locations = [0.0, 1.0]
        gradient.frame = gradientMaskView.bounds
        gradientMaskView.layer.insertSublayer(gradient, at: 0)
    }
}

extension MovieDetailView {
    func kfSetPosterImage(with url: URL, options: KingfisherOptionsInfo? = nil) {
        posterImageView.kf.setImage(with: url, placeholder: nil, options: options)
    }
}
