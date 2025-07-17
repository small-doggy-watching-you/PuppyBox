//
//  MovieDetailView.swift
//  PuppyBox
//
//  Created by 김우성 on 7/16/25.
//

import SnapKit
import Then
import UIKit

// 위에서부터 포스터이미지, 이미지 위에 겹치는 그라데이션, 그 밑에 검정 백그라운드 뷰
// 백그라운드 뷰 안을 영화 정보 뷰, 그 밑에 예매 뷰로 구성

class MovieDetailView: UIView {
    private let movieInfoView = MovieInfoView()
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray5
        $0.clipsToBounds = true
        $0.image = UIImage(named: "1585204391")
    }
    
    private let gradientMaskView = UIView().then {
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    }
    
    private let blackBackgroundView = UIView().then { // 글씨 영역용: 항상 검정
        $0.backgroundColor = .black
        $0.clipsToBounds = true
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
        backgroundColor = .black
        
        for item in [posterImageView, gradientMaskView, blackBackgroundView] {
            addSubview(item)
        }
        
        posterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(posterImageView.snp.width) // .multipliedBy(0.8)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient()
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
