import Alamofire
import Foundation

final class DataService {
    func fetchData(endpoint: String, pageNum: Int = 1, completion: @escaping (Result<MovieData, Error>) -> Void) {
        let url = "https://api.themoviedb.org/3/movie/\(endpoint)"
        let parameters: Parameters = [
            "language": "ko-kr",
            "page": pageNum
        ]

        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": Secrets.accessToken,
        ]

        AF.request(url, method: .get, parameters: parameters, headers: headers)
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
