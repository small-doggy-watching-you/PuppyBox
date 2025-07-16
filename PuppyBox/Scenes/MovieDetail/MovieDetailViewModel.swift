//
//  MovieDetailViewModel.swift
//  PuppyBox
//
//  Created by 김우성 on 7/16/25.
//

final class MovieDetailViewModel: ViewModelProtocol {
    private(set) var state: State {
        didSet { onStateChanged?(state) }
    }
    
    var onStateChanged: ((State) -> Void)?
    
    init() {
        state = State()
    }
    
    func action(_ action: Action) {
        
    }
    
    
    
}

extension MovieDetailViewModel {
    enum Action {
        
    }
    
    struct State {
        
    }
}
