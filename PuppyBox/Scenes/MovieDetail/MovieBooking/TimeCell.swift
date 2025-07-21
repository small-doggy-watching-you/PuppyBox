//
//  TimeCell.swift
//  PuppyBox
//
//  Created by 김우성 on 7/18/25.
//

import SnapKit
import UIKit

// MARK: - 시간 셀

final class TimeCell: UICollectionViewCell {
    static let reuseIdentifier = "TimeCell"

    // MARK: - UI

    private let label = UILabel()

    // MARK: - 초기화

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.layer.cornerRadius = 8
        updateAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - 셀 구성

    func configure(time: String) {
        label.text = time
    }

    override var isSelected: Bool {
        didSet { updateAppearance() }
    }

    // MARK: - 선택상태에 따른 UI

    private func updateAppearance() {
        contentView.backgroundColor = isSelected ? .appPrimary : .systemGray5
        label.textColor = isSelected ? .white : .black
    }
}
