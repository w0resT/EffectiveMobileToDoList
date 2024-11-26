import Foundation

protocol NetworkManagerProtocol {
    func fetchTasks(urlString: String, completion: @escaping (Result<TaskListDTO, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Properties
    private var networkService: NetworkServiceProtocol
    
    // MARK: - Initializers
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - NetworkManagerProtocol
    func fetchTasks(urlString: String, completion: @escaping (Result<TaskListDTO, Error>) -> Void) {
        networkService.fetchTasks(urlString: urlString) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let taskListResult = self.decode(from: data)
                    completion(taskListResult)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

// MARK: - Helper
private extension NetworkManager {
    func decode(from data: Data) -> Result<TaskListDTO, Error> {
        do {
            let decodedData = try JSONDecoder().decode(TaskListDTO.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }
}
