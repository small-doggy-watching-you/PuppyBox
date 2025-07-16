import Alamofire
import Foundation

final class DataService {
    private let upcomingURL = "https://api.themoviedb.org/3/movie/upcoming"
    func fetchData(pageNum: Int, completion: @escaping (Result<MovieData, Error>) -> Void) {
        let parameters: Parameters = [
            "language": "ko-kr",
            "page": pageNum,
        ]

        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": Secrets.accessToken,
        ]

        AF.request(upcomingURL, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: MovieData.self) { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
}
