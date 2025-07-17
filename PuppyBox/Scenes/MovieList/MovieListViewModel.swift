//
//  MovieListViewModel.swift
//  PuppyBox
//
//  Created by 노가현 on 7/16/25.
//

import Foundation

final class MovieListViewModel: ViewModelProtocol {
    enum Action {
        case fetchAll
    }

    struct State {
        var movieChart: [MovieResults] = []
        var nowPlaying: [MovieResults] = []
        var upcoming: [MovieResults] = []
    }

    private(set) var state: State = State() {
        didSet { onDataUpdated?(state) }
    }

    private let dataService = DataService()
    var onDataUpdated: ((State) -> Void)?

    init() {}

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
