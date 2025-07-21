
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
        if let account = fetchCurrentUserAccount() {
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
            if let account = fetchCurrentUserAccount() {
                state = State(userData: updateUserData(from: account))
            }
        }
    }
}

// 현재 유저 정보 획득
private func fetchCurrentUserAccount() -> Account? {
    @UserSetting(key: UDKey.userId, defaultValue: "")
    var userId: String
    return CoreDataManager.shared.fetchAccount(userId: userId)
}

// 유저 정보객체에 업데이트
private func updateUserData(from account: Account) -> UserData {
    let reservations: [MyMovie]
    
    if let movies = account.reservation as? Set<Reservation> {
        reservations = movies.map {
            MyMovie(
                movieId: Int($0.movieId),
                movieName: $0.movieName,
                posterImagePath: ImagePathService.makeImagePath(size: .w92, posterPath: $0.posterImagePath ?? ""),
                screeningDate: DateFormat.dateToString($0.screeningDate),
            )
        }.sorted {
            $0.screeningDate < $1.screeningDate // 예매정보는 오래된 순 (볼 순서 대로 배치)
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
            $0.screeningDate > $1.screeningDate // 관람기록은 최신순 (나중에 본 것이 최상단)
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
