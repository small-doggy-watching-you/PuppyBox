//
//  MoviePosterCell.swift
//  PuppyBox
//
//  Created by 노가현 on 7/17/25.
//

import Kingfisher
import UIKit

final class MoviePosterCell: UICollectionViewCell {
    static let identifier = "MoviePosterCell"

    let posterButton = UIButton().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .systemGray5
    }

    let numberLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 48)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.isHidden = true

        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterButton)
        contentView.addSubview(numberLabel)

        posterButton.snp.makeConstraints { $0.edges.equalToSuperview() }

        numberLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(with path: String?) {
        guard let path = path else { return }
        let url = URL(string: "https://image.tmdb.org/t/p/original\(path)")
        posterButton.kf.setImage(with: url, for: .normal)
    }

    func setNumber(_ number: Int?) {
        if let number {
            numberLabel.text = "\(number)"
            numberLabel.isHidden = false
        } else {
            numberLabel.isHidden = true
        }
    }
}
