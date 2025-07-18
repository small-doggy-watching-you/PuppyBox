//
//  TimeCell.swift
//  PuppyBox
//
//  Created by 김우성 on 7/18/25.
//

import SnapKit
import UIKit

final class TimeCell: UICollectionViewCell {
    static let reuseIdentifier = "TimeCell"

    private let label = UILabel()

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

    func configure(time: String) {
        label.text = time
    }

    override var isSelected: Bool {
        didSet { updateAppearance() }
    }

    private func updateAppearance() {
        contentView.backgroundColor = isSelected ? .appPrimary : .systemGray5
        label.textColor = isSelected ? .white : .black
    }
}
