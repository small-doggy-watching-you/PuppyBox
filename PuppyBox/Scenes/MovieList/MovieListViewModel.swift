
import Foundation

final class MovieListViewModel: ViewModelProtocol {
    struct State {
        var movieData: MovieData?
    }

    private(set) var state: State {
        didSet {
            onDataUpdated?(state)
        }
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

    private let dataService = DataService()
    var onDataUpdated: ((State) -> Void)?
    var pageNum = 1

    init() {
        state = State(
            //            movieData: nil,
        )
    }

    private func fetchData() {
        dataService.fetchData(pageNum: pageNum) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(moviedata):
                self.state.movieData = moviedata
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }
}
