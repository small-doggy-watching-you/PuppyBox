
import Foundation

// 마이페이지 출력용 영화정보 객체
struct MyMovie: Hashable {
    let movieId: Int
    let movieName: String
    let posterImagePath: String
    let screeningDate: String
}
