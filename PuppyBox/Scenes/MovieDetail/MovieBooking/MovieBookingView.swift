//
//  MovieBookingView.swift
//  PuppyBox
//
//  Created by 김우성 on 7/18/25.
//

import SnapKit
import Then
import UIKit

// MARK: - 섹션 구분용 열거형

enum MovieBookingSection: Hashable {
    case dateSelection
    case timeSelection
    case ticketQuantity
}

// MARK: - 아이템 구분용 열거형

enum MovieBookingItem: Hashable {
    case date(Date)
    case time(String)
    case ticketAdult(Int)
    case ticketChild(Int)
}

// MARK: - 커스텀 헤더뷰

final class MovieBookingSectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "MovieBookingSectionHeaderView"
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .label
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(title: String?) {
        titleLabel.text = title
    }
}

// MARK: - 예매 뷰 (상태를 직접 관리)

final class MovieBookingView: UIView, UICollectionViewDelegate {
    // MARK: - 외부로 전달할 콜백

    var onSelectSeat: ((Date?, String?, Int, Int) -> Void)?

    // MARK: - UI 요소

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    private lazy var dataSource = makeDataSource()
    private let footerButton = UIButton().then {
        $0.setTitle("좌석 선택", for: .normal)
        $0.backgroundColor = .systemRed
        $0.tintColor = .white
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
        $0.alpha = 0.5
    }

    // MARK: - 데이터

    private var dateItems: [Date] = {
        let today = Date()
        return (0 ..< 7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: today) }
    }()

    private var timeItems = ["10:00 AM", "1:00 PM", "4:00 PM", "7:00 PM"]

    private var selectedAdultCount = 0
    private var selectedChildCount = 0
    private var selectedDateIndexPath: IndexPath? = IndexPath(item: 0, section: 0)
    private var selectedTimeIndexPath: IndexPath?

    // MARK: - 초기화

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        applySnapshot()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - UI 세팅

    private func setupUI() {
        backgroundColor = .white
        addSubview(collectionView)
        addSubview(footerButton)

        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(footerButton.snp.top).offset(-8)
        }
        footerButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }

        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true

        footerButton.addTarget(self, action: #selector(selectSeatTapped), for: .touchUpInside)
    }

    // MARK: - 스냅샷 갱신

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MovieBookingSection, MovieBookingItem>()
        snapshot.appendSections([.dateSelection, .timeSelection, .ticketQuantity])
        snapshot.appendItems(dateItems.map { .date($0) }, toSection: .dateSelection)
        snapshot.appendItems(timeItems.map { .time($0) }, toSection: .timeSelection)
        snapshot.appendItems([.ticketAdult(selectedAdultCount), .ticketChild(selectedChildCount)],
                             toSection: .ticketQuantity)

        dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            guard let self else { return }
            if let dateIndex = self.selectedDateIndexPath {
                self.collectionView.selectItem(at: dateIndex, animated: false, scrollPosition: [])
            }
            if let timeIndex = self.selectedTimeIndexPath {
                self.collectionView.selectItem(at: timeIndex, animated: false, scrollPosition: [])
            }
        }

        // 버튼 활성화 여부 갱신
        updateFooterButtonState()
    }

    // MARK: - 레이아웃

    private func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let section = self?.dataSource.sectionIdentifier(for: sectionIndex) else {
                return nil
            }

            switch section {
            case .dateSelection:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(50), heightDimension: .absolute(60))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.orthogonalScrollingBehavior = .continuous
                sectionLayout.interGroupSpacing = 8
                sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                return sectionLayout

            case .timeSelection:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .absolute(40))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(45))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)

                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.interGroupSpacing = 8
                sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
                sectionLayout.boundarySupplementaryItems = [self?.makeHeaderItem()].compactMap { $0 }
                return sectionLayout

            case .ticketQuantity:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16)
                sectionLayout.boundarySupplementaryItems = [self?.makeHeaderItem()].compactMap { $0 }
                return sectionLayout
            }
        }
    }

    private func makeHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }

    // MARK: - Diffable DataSource

    private func makeDataSource() -> UICollectionViewDiffableDataSource<MovieBookingSection, MovieBookingItem> {
        let dateCellRegistration = UICollectionView.CellRegistration<DateCell, Date> { cell, _, date in
            cell.configure(date: date)
        }
        let timeCellRegistration = UICollectionView.CellRegistration<TimeCell, String> { cell, _, time in
            cell.configure(time: time)
        }
        let adultCellRegistration = UICollectionView.CellRegistration<TicketCounterCell, Int> { [weak self] cell, _, count in
            cell.configure(title: "어른", count: count) { [weak self] newCount in
                self?.selectedAdultCount = newCount
                self?.applySnapshot()
            }
        }
        let childCellRegistration = UICollectionView.CellRegistration<TicketCounterCell, Int> { [weak self] cell, _, count in
            cell.configure(title: "어린이", count: count) { [weak self] newCount in
                self?.selectedChildCount = newCount
                self?.applySnapshot()
            }
        }

        let dataSource = UICollectionViewDiffableDataSource<MovieBookingSection, MovieBookingItem>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch item {
            case .date(let date):
                return collectionView.dequeueConfiguredReusableCell(using: dateCellRegistration, for: indexPath, item: date)
            case .time(let time):
                return collectionView.dequeueConfiguredReusableCell(using: timeCellRegistration, for: indexPath, item: time)
            case .ticketAdult(let count):
                return collectionView.dequeueConfiguredReusableCell(using: adultCellRegistration, for: indexPath, item: count)
            case .ticketChild(let count):
                return collectionView.dequeueConfiguredReusableCell(using: childCellRegistration, for: indexPath, item: count)
            }
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<MovieBookingSectionHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] header, _, indexPath in
            guard let section = self?.dataSource.sectionIdentifier(for: indexPath.section) else {
                header.configure(title: nil)
                return
            }
            switch section {
            case .timeSelection:
                header.configure(title: "영화 시간")
            case .ticketQuantity:
                header.configure(title: "티켓 수량")
            default:
                header.configure(title: nil)
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        return dataSource
    }

    // MARK: - 셀 선택

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let section = dataSource.sectionIdentifier(for: indexPath.section) {
            switch section {
            case .dateSelection:
                if let prev = selectedDateIndexPath, prev != indexPath {
                    collectionView.deselectItem(at: prev, animated: false)
                }
                selectedDateIndexPath = indexPath
            case .timeSelection:
                if let prev = selectedTimeIndexPath, prev != indexPath {
                    collectionView.deselectItem(at: prev, animated: false)
                }
                selectedTimeIndexPath = indexPath
            default: break
            }
        }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateFooterButtonState()
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        let section = dataSource.sectionIdentifier(for: indexPath.section)
        switch section {
        case .dateSelection, .timeSelection: // 날짜와 시간은 선택 해제되지 않도록 막음
            return false
        default:
            return true
        }
    }

    // MARK: - 버튼 상태 업데이트

    private func updateFooterButtonState() {
        let hasDate = (selectedDateIndexPath != nil)
        let hasTime = (selectedTimeIndexPath != nil)
        let hasPeople = (selectedAdultCount + selectedChildCount > 0)
        let canProceed = hasDate && hasTime && hasPeople

        footerButton.isEnabled = canProceed
        footerButton.alpha = canProceed ? 1.0 : 0.5
    }

    // MARK: - 버튼 액션

    @objc private func selectSeatTapped() {
        let selectedDate: Date? = selectedDateIndexPath.flatMap { dateItems[$0.item] }
        let selectedTime: String? = selectedTimeIndexPath.flatMap { timeItems[$0.item] }
        onSelectSeat?(selectedDate, selectedTime, selectedAdultCount, selectedChildCount)
    }
}

// MARK: - 배열 안전 접근

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
