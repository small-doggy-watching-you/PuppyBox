//
//  MovieDetailViewModel.swift
//  PuppyBox
//
//  Created by 김우성 on 7/16/25.
//

import Foundation

// MARK: - 영화 상세 뷰모델

final class MovieDetailViewModel: ViewModelProtocol {
    // MARK: - 상태

    private(set) var state = State() {
        didSet { onStateChanged?(state) }
    }

    // MARK: - 상태 변경 콜백

    var onStateChanged: ((State) -> Void)? {
        didSet { onStateChanged?(state) }
    }

    // MARK: - 초기화

    init(movie: MovieResults) {
        state.movie = movie
    }

    // MARK: - 액션 처리

    func action(_ action: Action) {
        switch action {
        case .configure(let movie):
            state.movie = movie
        }
    }
}

// MARK: - Action 정의

extension MovieDetailViewModel {
    enum Action {
        case configure(MovieResults)
    }
}

// MARK: - State 정의

extension MovieDetailViewModel {
    struct State {
        var movie: MovieResults? = nil
    }
}
