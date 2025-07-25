
import Foundation

// 마이페이지 출력용 유저 데이터 객체
struct UserData: Hashable {
    let nickname: String
    let userId: String
    let email: String
    let profileImageUrl: String

    let reservedMovies: [MyMovie]
    let watchedMovies: [MyMovie]
}

// 유저데이터중 사용할 것만 섹션으로 쓰기 위해 별도 객체로 생성
struct UserInfo: Hashable {
    let nickname: String
    let userId: String
    let email: String
    let profileImagePath: String
}
