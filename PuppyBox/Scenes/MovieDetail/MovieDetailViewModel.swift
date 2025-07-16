//
//  MovieDetailViewModel.swift
//  PuppyBox
//
//  Created by 김우성 on 7/16/25.
//

import Foundation

final class MovieDetailViewModel: ViewModelProtocol {
    private(set) var state: State {
        didSet { onStateChanged?(state) }
    }
    
    var onStateChanged: ((State) -> Void)?
    
    init() {
        state = State()
    }
    
    func action(_ action: Action) {
        switch action {
        case .configure(let movie):
            state.movie = movie
        case .changeAdultCount(let count):
            state.adultCount = max(0, state.adultCount + count)
        case .changeChildCount(let count):
            state.childCount = max(0, state.childCount + count)
        case .selectTime(let time):
            state.selectedTime = time
        case .selectDate(let date):
            state.selectedDate = date
        }
    }
}

extension MovieDetailViewModel {
    enum Action {
        case configure(MovieResults)
        case changeAdultCount(Int)
        case changeChildCount(Int)
        case selectTime(String)
        case selectDate(Date)
    }
    
    struct State {
        var movie: MovieResults? = nil
        var selectedDate: Date? = nil
        var selectedTime: String? = nil
        var adultCount: Int = 0
        var childCount: Int = 0
    }
}
