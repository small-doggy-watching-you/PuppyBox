
import Foundation

enum ImagePathService {
    /*
      size는 Models/ImageSize 사용
      호출 예제
       ImagePathService.makeImagePath(size: ImageSize.w500.rawValue, posterPath: path)
     */

    static func makeImagePath(size: String, posterPath: String) -> String {
        let baseURL = "https://image.tmdb.org/t/p/"
        return baseURL + size + posterPath
    }
}
