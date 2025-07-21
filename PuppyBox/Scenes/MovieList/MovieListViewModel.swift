//
//  MovieListViewModel.swift
//  PuppyBox
//
//  Created by 노가현 on 7/16/25.
//

import Foundation

// MARK: - MovieListViewModel

final class MovieListViewModel: ViewModelProtocol {
    // MARK: - Types

    enum Action {
        case fetchAll
    }

    struct State {
        var movieChart: [MovieResults] = [] // 무비 차트 데이터
        var nowPlaying: [MovieResults] = [] // 현재 상영작
        var upcoming: [MovieResults] = [] // 상영 예정작
    }

    // MARK: - Properties

    private(set) var state: State = .init() {
        didSet { onDataUpdated?(state) }
    }

    private let dataService = DataService()
    var onDataUpdated: ((State) -> Void)?

    // MARK: - Initialization

    init() {}

    // MARK: - Public Methods

    func action(_ action: Action) {
        switch action {
        case .fetchAll:
            fetchAllData()
        }
    }

    func fetchAllData() {
        fetchMovieChart()
        fetchNowPlaying()
        fetchUpcoming()
    }

    // MARK: - Private Methods

    private func fetchMovieChart() {
        dataService.fetchData(endpoint: "popular") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.state.movieChart = data.results
            case .failure(let error):
                print("Error fetching popular: \(error)")
            }
        }
    }

    private func fetchNowPlaying() {
        dataService.fetchData(endpoint: "now_playing") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.state.nowPlaying = data.results
            case .failure(let error):
                print("Error fetching now_playing: \(error)")
            }
        }
    }

    private func fetchUpcoming() {
        dataService.fetchData(endpoint: "upcoming") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.state.upcoming = data.results
            case .failure(let error):
                print("Error fetching upcoming: \(error)")
            }
        }
    }
}
