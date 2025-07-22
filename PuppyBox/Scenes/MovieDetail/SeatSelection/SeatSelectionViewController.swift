//
//  SeatSelectionViewController.swift
//  PuppyBox
//
//  Created by 김우성 on 7/18/25.
//

import SnapKit
import Then
import UIKit
import CoreData

// MARK: - 좌석 상태

enum SeatState {
    case available
    case selected
    case reserved
    case disabled // 장애인석
    case empty // 표시 안 할 빈칸
}

// MARK: - 좌석 아이템

struct SeatItem: Hashable {
    let id: String
    var state: SeatState
}

// MARK: - 좌석 선택 화면 컨트롤러

final class SeatSelectionViewController: UIViewController {
    // MARK: - ViewModel

    private let viewModel: SeatSelectionViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, SeatItem>!

    // MARK: - Custom View

    private let seatSelectionView = SeatSelectionView()

    // MARK: - 초기화

    init(movie: MovieResults,
         selectedDate: Date?,
         selectedTime: String?,
         adultCount: Int,
         childCount: Int)
    {
        self.viewModel = SeatSelectionViewModel(
            movie: movie,
            selectedDate: selectedDate,
            selectedTime: selectedTime,
            adultCount: adultCount,
            childCount: childCount
        )
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - 생명주기

    override func loadView() {
        view = seatSelectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "좌석 선택"
        setupNavigationBar()
        configureDataSource()
        bindViewModel()
        seatSelectionView.payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
    }

    // MARK: - 네비게이션 바

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.backButtonDisplayMode = .minimal
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

    // MARK: - Diffable DataSource

    private func configureDataSource() {
        let registration = UICollectionView.CellRegistration<SeatCell, SeatItem> { cell, _, item in
            cell.configure(with: item)
        }
        dataSource = UICollectionViewDiffableDataSource<Int, SeatItem>(
            collectionView: seatSelectionView.seatCollectionView
        ) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
        }
        seatSelectionView.seatCollectionView.delegate = self
    }

    private func applySnapshot(seats: [SeatItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SeatItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(seats)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - ViewModel Binding

    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self = self else { return }
            self.applySnapshot(seats: state.displayedSeats)
            self.seatSelectionView.selectedSeatsLabel.text = state.selectedSeats.isEmpty ? "좌석을 선택해주세요." : "\(state.selectedSeats.joined(separator: ", "))"
            self.seatSelectionView.selectedSeatsLabel.textColor = state.selectedSeats.isEmpty ? .systemGray3 : .label
            self.seatSelectionView.peopleCountLabel.text = "성인 \(state.adultCount) | 어린이 \(state.childCount)"
            self.seatSelectionView.priceLabel.text = "\(state.totalPrice)원"
            self.seatSelectionView.payButton.isEnabled = state.isPayEnabled
            self.seatSelectionView.payButton.alpha = state.isPayEnabled ? 1.0 : 0.5
        }
    }

    // MARK: - 결제 버튼

    @objc private func payButtonTapped() {
        let totalPrice = viewModel.state.totalPrice
        
        let alert = AlertFactory.paymentConfirmAlert(totalPrice: totalPrice) { [weak self] in
            guard let self = self else { return }
            
            @UserSetting(key: UDKey.userId, defaultValue: "")
            var userId: String
            
            guard let account = CoreDataManager.shared.fetchAccount(userId: userId) else { return }
            
            let movie = self.viewModel.movieInfo
            let selectedDate = self.viewModel.dateInfo
            let selectedTime = self.viewModel.timeInfo
            
            if let screeningDate = makeScreeningDate(selectedDate: selectedDate, selectedTime: selectedTime) {
                
                let success = CoreDataManager.shared.addReservation(
                    for: account,
                    movieId: Int32(movie.id),
                    movieName: movie.title,
                    posterImagePath: movie.posterPath ?? "",
                    screeningDate: screeningDate
                )
                if success { // 예약 성공 시
                    let ticketVM = TicketViewModel(
                        movie: self.viewModel.movieInfo,
                        seats: self.viewModel.selectedSeatsArray,
                        date: self.viewModel.dateInfo,
                        time: self.viewModel.timeInfo,
                        price: totalPrice
                    )
                    
                    let ticketVC = TicketViewController(viewModel: ticketVM)
                    self.navigationController?.pushViewController(ticketVC, animated: true)
                } else { // 예약 실패 시 (같은 영화를 예매한 적 있는 경우
                    let alert = AlertFactory.duplicateReservationAlert {self.navigationController?.popViewController(animated: true) // 이건 선택
                    }
                    self.present(alert, animated: true)
                }
            }
        }
        present(alert, animated: true)
    }
    
    func makeScreeningDate(selectedDate: Date?, selectedTime: String?) -> Date? {
        guard let selectedDate = selectedDate,
              let selectedTime = selectedTime else {
            return nil
        }
        
        // 1. selectedDate를 "yyyy-MM-dd"로 변환 (한국 시간대)
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        dayFormatter.locale = Locale(identifier: "ko_KR")
        dayFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let datePart = dayFormatter.string(from: selectedDate) // 예: "2025-07-21"
        
        // 2. 날짜와 timeString을 합치기
        // selectedTime이 "1:00 PM"처럼 AM/PM 형태라고 가정
        let combinedString = "\(datePart) \(selectedTime)" // "2025-07-21 1:00 PM"
        
        // 3. 최종 파싱
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd h:mm a" // h:mm a -> 12시간제
        formatter.locale = Locale(identifier: "en_US_POSIX") // AM/PM 파싱 안정화
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 한국 시간대
        return formatter.date(from: combinedString)
    }
}

extension SeatSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.action(.toggleSeat(indexPath.item))
    }
}
