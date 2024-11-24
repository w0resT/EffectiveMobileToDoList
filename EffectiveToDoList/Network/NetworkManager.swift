import Foundation

protocol NetworkManagerProtocol {
    func fetchTasks(completion: @escaping (Result<TaskListDTO, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Properties
    private var networkService: NetworkServiceProtocol
    private var baseUrl: String
    
    // MARK: - Initializers
    init(networkService: NetworkServiceProtocol, baseUrl: String = APIConstants.baseUrl) {
        self.networkService = networkService
        self.baseUrl = baseUrl
    }
    
    // MARK: - NetworkManagerProtocol
    func fetchTasks(completion: @escaping (Result<TaskListDTO, Error>) -> Void) {
        let urlString = getTodosUrl()
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
    func getTodosUrl() -> String {
        return APIConstants.baseUrl + APIConstants.todosEndpoint
    }
    
    func decode(from data: Data) -> Result<TaskListDTO, Error> {
        do {
            let decodedData = try JSONDecoder().decode(TaskListDTO.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }
}
