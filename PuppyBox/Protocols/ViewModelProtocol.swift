
protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State

    var state: State { get }
    func action(_ action: Action)
}
