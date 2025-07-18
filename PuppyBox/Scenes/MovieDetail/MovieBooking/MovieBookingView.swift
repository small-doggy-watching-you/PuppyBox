//
//  MovieBookingView.swift
//  PuppyBox
//
//  Created by 김우성 on 7/18/25.
//

import SnapKit
import Then
import UIKit

enum MovieBookingSection: Hashable {
    case dateSelection
    case timeSelection
    case ticketQuantity
}

enum MovieBookingItem: Hashable {
    case date(Date)
    case time(String)
    case ticketAdult(Int)
    case ticketChild(Int)
}

// MARK: - Custom Header View

final class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"
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

final class MovieBookingView: UIView, UICollectionViewDelegate {
    // MARK: - Public callback

    var onSelectSeat: ((Date?, String?, Int, Int) -> Void)?

    // MARK: - UI

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    private lazy var dataSource = makeDataSource()
    private let footerButton = UIButton().then {
        $0.setTitle("좌석 선택", for: .normal)
        $0.backgroundColor = .systemRed
        $0.tintColor = .white
        $0.layer.cornerRadius = 8
    }

    // MARK: - Data

    private var dateItems: [Date] = {
        let today = Date()
        return (0 ..< 7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: today) }
    }()

    private var timeItems = ["10:00 AM", "1:00 PM", "4:00 PM", "7:00 PM"]

    private var selectedAdultCount = 0
    private var selectedChildCount = 0

    private var selectedDateIndexPath: IndexPath?
    private var selectedTimeIndexPath: IndexPath?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        selectedDateIndexPath = IndexPath(item: 0, section: 0)
        setupUI()
        applySnapshot()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

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

    // MARK: - Snapshot

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MovieBookingSection, MovieBookingItem>()
        snapshot.appendSections([.dateSelection, .timeSelection, .ticketQuantity])
        snapshot.appendItems(dateItems.map { .date($0) }, toSection: .dateSelection)
        snapshot.appendItems(timeItems.map { .time($0) }, toSection: .timeSelection)
        snapshot.appendItems([.ticketAdult(selectedAdultCount), .ticketChild(selectedChildCount)], toSection: .ticketQuantity)

        dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            guard let self else { return }
            if let dateIndex = self.selectedDateIndexPath {
                self.collectionView.selectItem(at: dateIndex, animated: false, scrollPosition: [])
            }
            if let timeIndex = self.selectedTimeIndexPath {
                self.collectionView.selectItem(at: timeIndex, animated: false, scrollPosition: [])
            }
        }
    }

    // MARK: - Layout

    private func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self, let section = self.dataSource.snapshot().sectionIdentifiers[safe: sectionIndex] else { return nil }
            switch section {
            case .dateSelection:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(50), heightDimension: .absolute(60))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                return section
            case .timeSelection:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .absolute(40))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(45))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
                section.boundarySupplementaryItems = [self.makeHeaderItem()]
                return section
            case .ticketQuantity:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16)
                section.boundarySupplementaryItems = [self.makeHeaderItem()]
                return section
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

    // MARK: - DataSource

    private func makeDataSource() -> UICollectionViewDiffableDataSource<MovieBookingSection, MovieBookingItem> {
        // CellRegistrations
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

        // HeaderRegistration
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] header, _, indexPath in
            guard let section = self?.dataSource.snapshot().sectionIdentifiers[safe: indexPath.section] else {
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

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
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
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    // MARK: - Button Action

    @objc private func selectSeatTapped() {
        let selectedDate: Date? = selectedDateIndexPath.flatMap { dateItems[$0.item] }
        let selectedTime: String? = selectedTimeIndexPath.flatMap { timeItems[$0.item] }
        onSelectSeat?(selectedDate, selectedTime, selectedAdultCount, selectedChildCount)
    }
}

// MARK: - Safe array access

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

@available(iOS 17.0, *)
#Preview {
    MovieBookingView()
}
