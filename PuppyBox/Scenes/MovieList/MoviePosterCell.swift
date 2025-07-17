//
//  MoviePosterCell.swift
//  PuppyBox
//
//  Created by 노가현 on 7/17/25.
//

import UIKit

final class MoviePosterCell: UICollectionViewCell {
    static let identifier = "MoviePosterCell"

    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ text: String) {
        titleLabel.text = text
    }
}
