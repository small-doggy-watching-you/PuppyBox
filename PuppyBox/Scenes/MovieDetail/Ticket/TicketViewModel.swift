//
//  TicketViewModel.swift
//  PuppyBox
//
//  Created by 김우성 on 7/22/25.
//

import Foundation

final class TicketViewModel: ViewModelProtocol {
    enum Action {
        case updateSeats([String])
        case reload
    }

    struct State {
        var movie: MovieResults
        var seats: [String]
        var dateString: String
        var timeString: String
        var priceString: String
    }

    private(set) var state: State

    init(movie: MovieResults, seats: [String], date: Date?, time: String?, price: Int) {
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        let dateString = date != nil ? df.string(from: date!) : "-"
        let timeString = time ?? "-"
        let priceString = "\(price)원"
        self.state = State(movie: movie, seats: seats, dateString: dateString, timeString: timeString, priceString: priceString)
    }

    func action(_ action: Action) {
        switch action {
        case .updateSeats(let newSeats):
            state.seats = newSeats
        case .reload:
            break // 필요시 구현
        }
    }
}
