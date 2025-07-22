
import Foundation

enum ImagePathService {
    /*
      size는 Models/ImageSize 사용
      호출 예제
       ImagePathService.makeImagePath(size: .w500, posterPath: path)
     */

    static func makeImagePath(size: ImageSize, posterPath: String) -> String {
        let baseURL = "https://image.tmdb.org/t/p/"
        return baseURL + size.rawValue + posterPath
    }
}
