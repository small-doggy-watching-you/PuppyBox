
import Foundation

final class MyPageViewModel: ViewModelProtocol {
    enum Action {
        case fetchUserData
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
        if let account = CoreDataManager.shared.fetchAccount(userId: userId){
            self.state = State(userData: makeUserData(from: account))
        } else {
            self.state = State(userData:
                                UserData(
                                    nickname: "",
                                    userId: "",
                                    email: "",
                                    profileImageUrl: "defaultProfile",
                                    reservedMovies: [],
                                    watchedMovies: [])
            )
        }
    }
    
    
    
    func action(_ action: Action) {
        
    }
    
    
}

private func makeUserData(from account: Account) -> UserData {
    let watched: [MyMovie]
    
    if let movies = account.watchedMovies as? Set<WatchedMovie>{
        watched = movies.map{
            MyMovie(
                movieId: Int($0.movieId),
                movieName: $0.movieName,
                posterImagePath: $0.posterImagePath ?? "",
                screeningDate: DateFormat.dateToString($0.screeningDate),
            )
        }
    } else {
        watched = []
    }
    
    let reservations: [MyMovie]
    
    if let movies = account.reservation as? Set<WatchedMovie>{
        reservations = movies.map{
            MyMovie(
                movieId: Int($0.movieId),
                movieName: $0.movieName,
                posterImagePath: $0.posterImagePath ?? "",
                screeningDate: DateFormat.dateToString($0.screeningDate),
            )
        }
    } else {
        reservations = []
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
