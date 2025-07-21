//
//  SeatSelectionViewModel.swift
//  PuppyBox
//
//  Created by 김우성 on 7/21/25.
//

import Foundation

final class SeatSelectionViewModel: ViewModelProtocol {
    
    private(set) var state = State() {
        didSet { onStateChanged?(state) } // 상태가 바뀌면 호출
    }
    
    var onStateChanged: ((State) -> Void)? { // 외부에서 상태변화 구독
        didSet { onStateChanged?(state)}
    }
    
    private let movie: MovieResults
    private let selectedDate: Date?
    private let selectedTime: String?
    private let adultCount: Int
    private let childCount: Int
    
    private var seatItems: [SeatItem] = []
    private var selectedSeats: Set<String> = []
    private var maxSelectable: Int { adultCount + childCount }
    
    init(movie: MovieResults, selectedDate: Date?, selectedTime: String?, adultCount: Int, childCount: Int) {
        self.movie = movie
        self.selectedDate = selectedDate
        self.selectedTime = selectedTime
        self.adultCount = adultCount
        self.childCount = childCount
        
        generateSeats()
        updateState()
    }
    
    func action(_ action: Action) {
        switch action {
        case .toggleSeat(let index):
            toggleSeat(at: index)
        }
    }
}

private extension SeatSelectionViewModel {
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
                if c > 6 && c < 13 { realIndex = c - 1 }
                else if c > 13 { realIndex = c - 2 }
                else { realIndex = c }
                guard realIndex < cols else {
                    items.append(SeatItem(id: "EMPTY_\(r)_\(c)", state: .empty))
                    continue
                }
                let seatId = "\(rowChar)\(String(format:"%02d", realIndex+1))"
                if reservedSeats.contains(seatId) {
                    items.append(SeatItem(id: seatId, state: .reserved))
                } else {
                    items.append(SeatItem(id: seatId, state: .available))
                }
            }
        }
        self.seatItems = items
    }
    
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
    
    func updateState() {
        state.displayedSeats = seatItems
        state.infoText = "선택된 좌석: \(selectedSeats.sorted().joined(separator: ", "))"
        let totalPrice = adultCount * 12000 + childCount * 11000
        state.priceText = "결제 금액: \(totalPrice)원"
    }
}

extension SeatSelectionViewModel {
    enum Action {
        case toggleSeat(Int)
    }
    
    struct State {
        var displayedSeats: [SeatItem] = []
        var infoText: String = ""
        var priceText: String = ""
    }
}
