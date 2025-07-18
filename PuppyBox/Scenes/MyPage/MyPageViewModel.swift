
import Foundation

final class MyPageViewModel: ViewModelProtocol {
    enum Action {
    }
    struct State {
        let userData: UserData
    }
    private(set) var state: State {
        didSet { onStateChanged?(state) }
    }

    var onStateChanged: ((State) -> Void)?
    
    init(userData: UserData) {
        state = State(userData: userData)
    }
    
    func action(_ action: Action) {

    }

    
    
}

extension MyPageViewModel {
}
