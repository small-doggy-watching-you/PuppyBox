//
//  SeatSelectionView.swift
//  PuppyBox
//
//  Created by 김우성 on 7/21/25.
//

import SnapKit
import Then
import UIKit

// MARK: - 좌석 선택 화면 전용 View

final class SeatSelectionView: UIView {
    // MARK: - UI

    let seatCollectionView = UICollectionView(frame: .zero, collectionViewLayout: SeatSelectionView.makeLayout()).then {
        $0.backgroundColor = .clear
    }

    let infoContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }

    let infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }

    let cinemaLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
    }

    let dividerView = UIView().then {
        $0.backgroundColor = .systemGray5
    }

    let selectedSeatsTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.text = "좌석"
    }

    let selectedSeatsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
    }

    let peopleCountTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.text = "인원"
    }

    let peopleCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }

    let priceTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.text = "결제 금액"
    }

    let priceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }

    let payButton = UIButton(type: .system).then {
        $0.setTitle("결제하기", for: .normal)
        $0.backgroundColor = .appPrimary
        $0.tintColor = .white
        $0.layer.cornerRadius = 8
        $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        $0.isEnabled = false
        $0.alpha = 0.5
    }

    // MARK: - 초기화

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - UI 세팅

    private func configureUI() {
        backgroundColor = .black
        addSubview(seatCollectionView)
        addSubview(infoContainerView)

        seatCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(infoContainerView.snp.top)
        }

        infoContainerView.addSubview(infoStackView)

        infoContainerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }

        [
            cinemaLabel,
            dividerView,
            makeLabelStack(title: selectedSeatsTitleLabel, value: selectedSeatsLabel),
            makeLabelStack(title: peopleCountTitleLabel, value: peopleCountLabel),
            makeLabelStack(title: priceTitleLabel, value: priceLabel),
            payButton
        ].forEach {
            infoStackView.addArrangedSubview($0)
        }

        dividerView.snp.makeConstraints {
            $0.height.equalTo(1)
        }

        infoStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(8)
        }

        cinemaLabel.text = "퍼피박스 젭 1관 (3층)"
    }

    private func makeLabelStack(title: UILabel, value: UILabel) -> UIStackView {
        UIStackView(arrangedSubviews: [title, value]).then {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .equalSpacing
        }
    }

    // MARK: - Compositional Layout

    private static func makeLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(40), heightDimension: .absolute(40))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(40 * 20), heightDimension: .absolute(40))
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitem: item, count: 20)
            horizontalGroup.interItemSpacing = .fixed(4)

            let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(40 * 20), heightDimension: .absolute(40 * 14))
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitem: horizontalGroup, count: 14)
            verticalGroup.interItemSpacing = .fixed(4)

            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 40, bottom: 16, trailing: 40)
            return section
        }
    }
}
