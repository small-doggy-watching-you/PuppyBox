//
//  DateCell.swift
//  PuppyBox
//
//  Created by 김우성 on 7/18/25.
//

import SnapKit
import UIKit

final class DateCell: UICollectionViewCell {
    static let reuseIdentifier = "DateCell"

    private let label = UILabel()
    private var currentDate: Date?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.layer.cornerRadius = 8
        updateAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(date: Date) {
        currentDate = date
        let calendar = Calendar.current
        let now = Date()
        let dayNumber = calendar.component(.day, from: date)

        if calendar.isDate(date, inSameDayAs: now) {
            label.text = "오늘\n\(dayNumber)"
        } else if let tomorrow = calendar.date(byAdding: .day, value: 1, to: now),
                  calendar.isDate(date, inSameDayAs: tomorrow)
        {
            label.text = "내일\n\(dayNumber)"
        } else {
            let formatter = DateCell.formatter
            label.text = formatter.string(from: date)
        }

        updateAppearance()
    }

    override var isSelected: Bool {
        didSet { updateAppearance() }
    }

    private func updateAppearance() {
        if isSelected {
            contentView.backgroundColor = .appPrimary
            label.textColor = .white
        } else {
            contentView.backgroundColor = .white
            if let date = currentDate {
                let weekday = Calendar.current.component(.weekday, from: date)
                switch weekday {
                case 1: label.textColor = .systemRed
                case 7: label.textColor = .systemBlue
                default: label.textColor = .black
                }
            }
        }
    }

    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "E\nd"
        return f
    }()
}
