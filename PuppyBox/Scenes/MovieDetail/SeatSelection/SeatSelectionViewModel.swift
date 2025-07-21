//
//  SeatSelectionViewModel.swift
//  PuppyBox
//
//  Created by 김우성 on 7/21/25.
//

import Foundation

// MARK: - 좌석 선택 뷰모델

final class SeatSelectionViewModel: ViewModelProtocol {
    // MARK: - 액션 정의

    enum Action {
        case toggleSeat(Int)
    }
    
    // MARK: - 상태 정의

    struct State {
        var displayedSeats: [SeatItem] = []
        var selectedSeats: [String] = [] // 선택된 좌석 ID
        var totalPrice: Int = 0 // 총 결제 금액
        var isPayEnabled: Bool = false // 결제 가능 여부
        var adultCount: Int = 0
        var childCount: Int = 0
    }
    
    // MARK: - 상태 관리

    private(set) var state = State() {
        didSet { onStateChanged?(state) }
    }

    var onStateChanged: ((State) -> Void)? {
        didSet { onStateChanged?(state) }
    }
    
    // MARK: - 외부에서 접근할 정보

    var selectedSeatsArray: [String] {
        return state.selectedSeats
    }

    var movieInfo: MovieResults { movie }
    var dateInfo: Date? { selectedDate }
    var timeInfo: String? { selectedTime }
    
    // MARK: - 내부 데이터

    private let movie: MovieResults
    private let selectedDate: Date?
    private let selectedTime: String?
    private let adultCount: Int
    private let childCount: Int
    
    private var seatItems: [SeatItem] = []
    private var selectedSeats: Set<String> = []
    private var maxSelectable: Int { adultCount + childCount }
    
    // MARK: - 초기화

    init(movie: MovieResults,
         selectedDate: Date?,
         selectedTime: String?,
         adultCount: Int,
         childCount: Int)
    {
        self.movie = movie
        self.selectedDate = selectedDate
        self.selectedTime = selectedTime
        self.adultCount = adultCount
        self.childCount = childCount
        
        generateSeats()
        updateState()
    }
    
    // MARK: - 액션 처리

    func action(_ action: Action) {
        switch action {
        case .toggleSeat(let index):
            toggleSeat(at: index)
        }
    }
}

// MARK: - Private Helper

private extension SeatSelectionViewModel {
    // MARK: 좌석 데이터 생성

    func generateSeats() {
        let rows = 14
        let cols = 18
        let reservedSeats: Set<String> = Set(
            (65...78).flatMap { l in
                (1...18).map { "\(String(UnicodeScalar(l)!))\(String(format: "%02d", $0))" }
            }.shuffled().prefix(Int.random(in: 0...70))
        )
        
        var items: [SeatItem] = []
        for r in 0..<rows {
            let rowChar = Character(UnicodeScalar(65 + r)!)
            for c in 0..<20 {
                if c == 6 || c == 13 {
                    items.append(SeatItem(id: "EMPTY_\(r)_\(c)", state: .empty))
                    continue
                }
                let realIndex: Int
                if c > 6, c < 13 { realIndex = c - 1 }
                else if c > 13 { realIndex = c - 2 }
                else { realIndex = c }
                guard realIndex < cols else {
                    items.append(SeatItem(id: "EMPTY_\(r)_\(c)", state: .empty))
                    continue
                }
                let seatId = "\(rowChar)\(String(format: "%02d", realIndex + 1))"
                
                if rowChar == "N", (1...6).contains(realIndex + 1) {
                    items.append(SeatItem(id: seatId, state: .disabled))
                    continue
                }
                
                if reservedSeats.contains(seatId) {
                    items.append(SeatItem(id: seatId, state: .reserved))
                } else {
                    items.append(SeatItem(id: seatId, state: .available))
                }
            }
        }
        seatItems = items
    }
    
    // MARK: 좌석 선택/해제

    func toggleSeat(at index: Int) {
        var item = seatItems[index]
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
        seatItems[index] = item
        updateState()
    }
    
    // MARK: 상태 업데이트

    func updateState() {
        state.displayedSeats = seatItems
        state.selectedSeats = selectedSeats.sorted()
        state.totalPrice = (adultCount * 12000) + (childCount * 11000)
        state.isPayEnabled = (selectedSeats.count == maxSelectable)
        state.adultCount = adultCount
        state.childCount = childCount
    }
}
