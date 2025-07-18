//
//  MovieSectionHeader.swift
//  PuppyBox
//
//  Created by 노가현 on 7/17/25.
//

import SnapKit
import Then
import UIKit

final class MovieSectionHeader: UICollectionReusableView {
    static let identifier = "MovieSectionHeader"

    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
        $0.textColor = .black
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ text: String) {
        titleLabel.text = text
    }
}
