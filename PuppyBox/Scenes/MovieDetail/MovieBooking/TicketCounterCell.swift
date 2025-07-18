//
//  TicketCounterCell.swift
//  PuppyBox
//
//  Created by 김우성 on 7/18/25.
//

import SnapKit
import UIKit

final class TicketCounterCell: UICollectionViewCell {
    private enum Metrics {
        static let buttonSize: CGFloat = 40
    }
    
    static let reuseIdentifier = "TicketCounterCell"
    
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    
    private var onChange: ((Int) -> Void)?
    private var count: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        countLabel.font = .systemFont(ofSize: 16, weight: .medium)
        countLabel.textAlignment = .center
        
        countLabel.snp.makeConstraints {
            $0.width.equalTo(30)
        }
        
        // 버튼 기본 설정
        minusButton.setTitle("-", for: .normal)
        plusButton.setTitle("+", for: .normal)
        minusButton.tintColor = .label
        plusButton.tintColor = .label
        
        // 액션
        minusButton.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(increase), for: .touchUpInside)
        
        // 버튼 스타일 (동그란 회색 버튼)
        styleRoundButton(minusButton)
        styleRoundButton(plusButton)
        
        let hStack = UIStackView(arrangedSubviews: [minusButton, countLabel, plusButton])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 8
        
        let mainStack = UIStackView(arrangedSubviews: [titleLabel, hStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 16
        
        contentView.addSubview(mainStack)
        mainStack.snp.makeConstraints { $0.edges.equalToSuperview().inset(8) }
        
        contentView.backgroundColor = .clear
    }
    
    private func styleRoundButton(_ button: UIButton) {
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = Metrics.buttonSize / 2
        button.clipsToBounds = true
        button.snp.makeConstraints { make in
            make.width.height.equalTo(Metrics.buttonSize)
        }
    }
    
    func configure(title: String, count: Int, onChange: @escaping (Int) -> Void) {
        titleLabel.text = title
        self.count = count
        countLabel.text = "\(count)"
        self.onChange = onChange
    }
    
    @objc private func decrease() {
        guard count > 0 else { return }
        count -= 1
        countLabel.text = "\(count)"
        onChange?(count)
    }
    
    @objc private func increase() {
        guard count < 5 else { return }
        count += 1
        countLabel.text = "\(count)"
        onChange?(count)
    }
}
