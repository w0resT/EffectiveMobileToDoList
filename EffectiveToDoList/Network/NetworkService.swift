import Foundation

protocol NetworkServiceProtocol {
    func fetchTasks(urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Properties
    private let session: URLSession
    
    // MARK: - Initializers
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - NetworkServiceProtocol
    func fetchTasks(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkServiceError.invalidUrl))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NetworkServiceError.badResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkServiceError.badData))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}

enum NetworkServiceError: Error {
    case invalidUrl
    case badResponse
    case badData
}
