//
//  SeatCell.swift
//  PuppyBox
//
//  Created by 김우성 on 7/19/25.
//

import UIKit

// MARK: - 좌석 셀

final class SeatCell: UICollectionViewCell {
    // MARK: - UI

    private let label = UILabel()

    // MARK: - 초기화

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.snp.makeConstraints { $0.edges.equalToSuperview() }
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - 셀 구성

    func configure(with item: SeatItem) {
        switch item.state {
        case .empty:
            contentView.backgroundColor = .clear
            label.text = ""
        case .available:
            contentView.backgroundColor = .systemGray5
            label.text = item.id
            label.textColor = .black
        case .selected:
            contentView.backgroundColor = .appPrimary
            label.text = item.id
            label.textColor = .white
        case .reserved:
            contentView.backgroundColor = .systemGray
            label.text = item.id
            label.textColor = .white
        case .disabled:
            contentView.backgroundColor = UIColor(red: 0, green: 0.4, blue: 0, alpha: 1)
            label.text = item.id
            label.textColor = .white
        }
    }
}
