
import Foundation

struct UserData: Hashable {
    
    let nickname: String
    let userId: String
    let email: String
    
    let reservedMovie: [MyMovie]
    let seenMovie: [MyMovie]
}
