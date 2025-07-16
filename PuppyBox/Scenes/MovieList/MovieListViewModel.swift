//
//  MovieListViewModel.swift
//  PuppyBox
//
//  Created by 노가현 on 7/16/25.
//

import Foundation

final class MovieListViewModel: ViewModelProtocol {
    struct State {
        var movieData: MovieData? = nil
    }

    private(set) var state: State {
        didSet { onDataUpdated?(state) }
    }

    private let dataService = DataService()
    var onDataUpdated: ((State) -> Void)?
    var pageNum = 1

    init() {
        state = State(
            // movieData: nil,
        )
    }

    enum Action {
        case fetchData
    }

    func action(_ action: Action) {
        switch action {
        case .fetchData:
            fetchData()
        }
    }

    private func fetchData() {
        dataService.fetchData(pageNum: pageNum) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let moviedata):
                self.state.movieData = moviedata
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    private func updateMovieData(_ data: MovieData) {
        state.movieData = data
    }
}
