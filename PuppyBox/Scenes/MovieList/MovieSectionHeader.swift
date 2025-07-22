//
//  MovieSectionHeader.swift
//  PuppyBox
//
//  Created by 노가현 on 7/17/25.
//

import SnapKit
import Then
import UIKit

// MARK: - MovieSectionHeader

// 섹션 제목 표시하는 헤더 뷰
final class MovieSectionHeader: UICollectionReusableView {
    // MARK: - Properties

    static let identifier = "MovieSectionHeader"

    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
        $0.textColor = .black
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Configuration

    // 헤더 타이틀 텍스트 설정
    //  Parameter text : 표시할 문자열
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
}
