//
//  SeatInfoCell.swift
//  PuppyBox
//
//  Created by 김우성 on 7/22/25.
//

import UIKit

final class SeatInfoCell: UICollectionViewCell {
    private let salonLabel = UILabel()
    private let rowLabel = UILabel()
    private let numLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        contentView.layer.cornerRadius = 12
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        let salonStack = makeStack(top: "상영관", bottomLabel: salonLabel)
        let rowStack = makeStack(top: "열", bottomLabel: rowLabel)
        let numStack = makeStack(top: "번", bottomLabel: numLabel)
        let hStack = UIStackView(arrangedSubviews: [salonStack, rowStack, numStack])
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.alignment = .center
        hStack.spacing = 8
        contentView.addSubview(hStack)
        hStack.snp.makeConstraints { $0.edges.equalToSuperview().inset(12) }
    }

    private func makeStack(top: String, bottomLabel: UILabel) -> UIStackView {
        let topLabel = UILabel().then {
            $0.text = top
            $0.font = .systemFont(ofSize: 12, weight: .medium)
            $0.textColor = .systemGray
            $0.textAlignment = .center
        }
        bottomLabel.font = .systemFont(ofSize: 16, weight: .bold)
        bottomLabel.textColor = .white
        bottomLabel.textAlignment = .center
        let vStack = UIStackView(arrangedSubviews: [topLabel, bottomLabel])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 4
        return vStack
    }

    func configure(salon: String, row: String, num: String) {
        salonLabel.text = salon
        rowLabel.text = row
        numLabel.text = num
    }
}
