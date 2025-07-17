//
//  MovieDetailViewModel.swift
//  PuppyBox
//
//  Created by 김우성 on 7/16/25.
//

import Foundation

final class MovieDetailViewModel: ViewModelProtocol {
    private(set) var state = State() {
        didSet { onStateChanged?(state) }
    }

    var onStateChanged: ((State) -> Void)? {
        didSet { onStateChanged?(state) }
    }

    init(movie: MovieResults) {
        state.movie = movie
    }

    func action(_ action: Action) {
        switch action {
        case .configure(let movie):
            state.movie = movie
        }
    }
}

extension MovieDetailViewModel {
    // 액션
    enum Action {
        case configure(MovieResults)
    }

    // 상태
    struct State {
        var movie: MovieResults? = nil
    }
}
