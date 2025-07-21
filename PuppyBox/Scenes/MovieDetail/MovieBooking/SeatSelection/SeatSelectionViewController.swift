//
//  SeatSelectionViewController.swift
//  PuppyBox
//
//  Created by 김우성 on 7/18/25.
//

import UIKit
import SnapKit
import Then

// MARK: - SeatItem
enum SeatState {
    case available
    case selected
    case reserved
    case disabled // 장애인석
    case empty // 표시 안할 빈자리
}

struct SeatItem: Hashable {
    let id: String
    var state: SeatState
}

final class SeatSelectionViewController: UIViewController {
    // MARK: - Data
    private let movie: MovieResults
    private let selectedDate: Date?
    private let selectedTime: String?
    private let adultCount: Int
    private let childCount: Int
    
    private var selectedSeats: Set<String> = []
    private var seatItems: [SeatItem] = []
    
    private var maxSelectable: Int { adultCount + childCount }
    
    // MARK: - UI
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout()).then {
        $0.backgroundColor = .black
    }
    private var dataSource: UICollectionViewDiffableDataSource<Int, SeatItem>!
    
    private let infoView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    private let infoStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
    }
    private let cinemaLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .label
    }
    private let selectedSeatsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .label
        $0.numberOfLines = 0
    }
    private let peopleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .label
    }
    private let priceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .label
    }
    private let payButton = UIButton(type: .system).then {
        $0.setTitle("결제하기", for: .normal)
        $0.backgroundColor = .appPrimary
        $0.tintColor = .white
        $0.layer.cornerRadius = 8
        $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    init(movie: MovieResults,
         selectedDate: Date?,
         selectedTime: String?,
         adultCount: Int,
         childCount: Int) {
        self.movie = movie
        self.selectedDate = selectedDate
        self.selectedTime = selectedTime
        self.adultCount = adultCount
        self.childCount = childCount
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "좌석 선택"
        print("영화: \(movie.title)")
        print("날짜: \(String(describing: selectedDate))")
        print("시간: \(String(describing: selectedTime))")
        print("어른: \(adultCount), 어린이: \(childCount)")
        
        setupNavigationBar()
        setupUI()
        generateSeats()
        configureDataSource()
        applySnapshot()
        updateInfoView()
    }
    
    // MARK: - NavigationBar
    private func setupNavigationBar() {
        title = movie.title
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "house.fill"),
            style: .plain,
            target: self,
            action: #selector(goHome)
        )
    }
    
    @objc private func goHome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - UI
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(infoView)
        
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(infoView.snp.top)
        }
        
        infoView.addSubview(infoStack)
        infoView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        infoStack.addArrangedSubview(cinemaLabel)
        infoStack.addArrangedSubview(selectedSeatsLabel)
        infoStack.addArrangedSubview(peopleLabel)
        infoStack.addArrangedSubview(priceLabel)
        infoStack.addArrangedSubview(payButton)
        
        infoStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        cinemaLabel.text = "퍼피박스 젭 1관 (3층)"
        peopleLabel.text = "성인 \(adultCount)명 / 어린이 \(childCount)명"
        
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - DataSource & Layout
    private func configureDataSource() {
        let registration = UICollectionView.CellRegistration<SeatCell, SeatItem> { cell, _, item in
            cell.configure(with: item)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, SeatItem>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
        }
        
        collectionView.delegate = self
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SeatItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(seatItems)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(40),
                heightDimension: .absolute(40)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // 가로 한 줄(20칸)
            let horizontalGroupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(40 * 20),
                heightDimension: .absolute(40)
            )
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: horizontalGroupSize,
                subitem: item,
                count: 20
            )
            horizontalGroup.interItemSpacing = .fixed(4)
            
            // 세로로 14줄 쌓기
            let verticalGroupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(40 * 20),
                heightDimension: .absolute(40 * 14)
            )
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: verticalGroupSize,
                subitem: horizontalGroup,
                count: 14
            )
            verticalGroup.interItemSpacing = .fixed(4)
            
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.orthogonalScrollingBehavior = .continuous // 가로 스크롤
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            
            return section
        }
    }
    
    // MARK: - Seats
    private func generateSeats() {
        seatItems = []
        let rows = 14
        let cols = 18
        let reservedSeats: Set<String> = Set((65...78).flatMap { l in (1...18).map { "\(String(UnicodeScalar(l)!))\(String(format: "%02d", $0))" } }.shuffled().prefix(Int.random(in: 0...70))) // 예약된 좌석 : A~N + 01~18 조합 후 섞고, 앞에서부터 0~70개 뽑기
        
        for r in 0..<rows {
            let rowChar = Character(UnicodeScalar(65 + r)!) // A,B,C…
            for c in 0..<20 {
                if c == 6 || c == 13 {
                    // 7번째, 14번째는 빈칸
                    seatItems.append(SeatItem(id: "EMPTY_\(r)_\(c)", state: .empty))
                    continue
                }
                
                // 실제 좌석 인덱스 계산 (빈칸 건너뛰기)
                let realIndex: Int
                if c > 6 && c < 13 {
                    realIndex = c - 1
                } else if c > 13 {
                    realIndex = c - 2
                } else {
                    realIndex = c
                }
                
                guard realIndex < cols else {
                    seatItems.append(SeatItem(id: "EMPTY_\(r)_\(c)", state: .empty))
                    continue
                }
                
                let seatId = "\(rowChar)\(String(format:"%02d", realIndex+1))"
                if reservedSeats.contains(seatId) {
                    seatItems.append(SeatItem(id: seatId, state: .reserved))
                } else {
                    seatItems.append(SeatItem(id: seatId, state: .available))
                }
            }
        }
    }
    
    private func updateInfoView() {
        selectedSeatsLabel.text = "선택된 좌석: \(selectedSeats.sorted().joined(separator: ", "))"
        let totalPrice = adultCount * 12000 + childCount * 11000
        priceLabel.text = "결제 금액: \(totalPrice)원"
    }
    
    // MARK: - Actions
    @objc private func payButtonTapped() {
        let totalPrice = adultCount * 12000 + childCount * 11000
        let alert = AlertFactory.paymentConfirmAlert(totalPrice: totalPrice) { [weak self] in
            guard let self = self else { return }
            let ticketVC = TicketViewController(movie: self.movie,
                                                seats: Array(self.selectedSeats),
                                                date: self.selectedDate,
                                                time: self.selectedTime)
            self.navigationController?.pushViewController(ticketVC, animated: true)
        }
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension SeatSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var item = seatItems[indexPath.item]
        switch item.state {
        case .available:
            if selectedSeats.count < maxSelectable {
                item.state = .selected
                selectedSeats.insert(item.id)
            }
        case .selected:
            item.state = .available
            selectedSeats.remove(item.id)
        default:
            return
        }
        seatItems[indexPath.item] = item
        applySnapshot()
        updateInfoView()
    }
}
