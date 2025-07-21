//
//  MoviePosterCell.swift
//  PuppyBox
//
//  Created by 노가현 on 7/17/25.
//

import Kingfisher
import UIKit

// MARK: - MoviePosterCell

final class MoviePosterCell: UICollectionViewCell {
    // MARK: - Properties

    static let identifier = "MoviePosterCell"

    // 포스터 이미지 표시하는 버튼
    let posterButton = UIButton().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .systemGray5
    }

    // 순위 표시하는 레이블
    let numberLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 48)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.isHidden = true

        // 그림자 설정
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 2
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        // 서브뷰 추가
        contentView.addSubview(posterButton)
        contentView.addSubview(numberLabel)

        // 레이아웃 설정
        posterButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        numberLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    // 포스터 이미지 URL로 설정
    // Parameter path : 이미지 경로
    func setImage(with path: String?) {
        guard let path = path else { return }
        let url = URL(string: "https://image.tmdb.org/t/p/original\(path)")
        posterButton.kf.setImage(with: url, for: .normal)
    }

    // 순위 텍스트 설정
    //  Parameter number : 순위
    func setNumber(_ number: Int?) {
        if let number = number {
            numberLabel.text = "\(number)"
            numberLabel.isHidden = false
        } else {
            numberLabel.isHidden = true
        }
    }
}
