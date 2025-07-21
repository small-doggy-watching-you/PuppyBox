
import Foundation

final class MyPageViewModel: ViewModelProtocol {
    enum Action {
        case updateUserData
    }

    struct State {
        var userData: UserData
    }

    private(set) var state: State {
        didSet { onStateChanged?(state) }
    }

    var onStateChanged: ((State) -> Void)?

    init() {
        @UserSetting(key: UDKey.userId, defaultValue: "")
        var userId: String
        if let account = CoreDataManager.shared.fetchAccount(userId: userId) {
            state = State(userData: updateUserData(from: account))
        } else {
            state = State(userData:
                UserData(
                    nickname: "",
                    userId: "",
                    email: "",
                    profileImageUrl: "defaultProfile",
                    reservedMovies: [],
                    watchedMovies: []
                )
            )
        }
    }

    func action(_ action: Action) {
        switch action {
        case .updateUserData:
            @UserSetting(key: UDKey.userId, defaultValue: "")
            var userId: String
            let account = CoreDataManager.shared.fetchAccount(userId: userId)!
            state = State(userData: updateUserData(from: account))
        }
    }
}

private func updateUserData(from account: Account) -> UserData {
    let reservations: [MyMovie]

    if let movies = account.reservation as? Set<Reservation> {
        reservations = movies.map {
            MyMovie(
                movieId: Int($0.movieId),
                movieName: $0.movieName,
                posterImagePath: $0.posterImagePath ?? "",
                screeningDate: DateFormat.dateToString($0.screeningDate),
            )
        }.sorted {
            $0.screeningDate < $1.screeningDate
        }
    } else {
        reservations = []
    }

    let watched: [MyMovie]

    if let movies = account.watchedMovies as? Set<WatchedMovie> {
        watched = movies.map {
            MyMovie(
                movieId: Int($0.movieId),
                movieName: $0.movieName,
                posterImagePath: $0.posterImagePath ?? "",
                screeningDate: DateFormat.dateToString($0.screeningDate),
            )
        }.sorted {
            $0.screeningDate > $1.screeningDate
        }
    } else {
        watched = []
    }

    return UserData(
        nickname: account.name,
        userId: account.userId,
        email: account.email ?? "",
        profileImageUrl: account.profile ?? "defaultProfile",
        reservedMovies: reservations,
        watchedMovies: watched
    )
}
