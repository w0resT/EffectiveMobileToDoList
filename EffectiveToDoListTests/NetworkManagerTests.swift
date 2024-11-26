import XCTest
@testable import EffectiveToDoList

final class NetworkManagerTests: XCTestCase {

    // MARK: - Properties
    var networkManager: NetworkManagerProtocol!
    var mockNetworkService: MockNetworkService!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        
        mockNetworkService = MockNetworkService()
        networkManager = NetworkManager(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        networkManager = nil
        mockNetworkService = nil
        
        super.tearDown()
    }

    // MARK: - Tests
    func testFetchTasksNetwork_Success() {
        let expectedTaskList = TaskListDTO(todos: [TaskDTO(id: 1, todo: "Test task", completed: false, userId: 1)])
        let mockData = try! JSONEncoder().encode(expectedTaskList)
        let urlString = "www.youtube.com/watch?v=dQw4w9WgXcQ"
        mockNetworkService.mockData = mockData
        
        let expectation = XCTestExpectation(description: "Fetch tasks successfully")
        
        networkManager.fetchTasks(urlString: urlString) { result in
            switch result {
            case .success(let taskList):
                XCTAssertEqual(taskList.todos.count, expectedTaskList.todos.count)
                XCTAssertEqual(taskList.todos.first?.id, expectedTaskList.todos.first?.id)
                XCTAssertEqual(taskList.todos.first?.todo, expectedTaskList.todos.first?.todo)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but received failure")
            }
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockNetworkService.didFetchTasksCalled)
    }
    
    func testFetchTasksNetwork_Failure() {
        let urlString = "www.youtube.com/watch?v=dQw4w9WgXcQ"
        mockNetworkService.shouldReturnError = true
        
        let expectation = XCTestExpectation(description: "Fetch tasks failed")
        
        networkManager.fetchTasks(urlString: urlString) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but received success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockNetworkService.didFetchTasksCalled)
    }
    
    func testFetchTasksNetwork_InvalidData() {
        let urlString = "www.youtube.com/watch?v=dQw4w9WgXcQ"
        let invalidData = "Very Bad Response".data(using: .utf8)!
        mockNetworkService.mockData = invalidData
        
        let expectation = XCTestExpectation(description: "Fetch tasks with invalid data")
        
        networkManager.fetchTasks(urlString: urlString) { result in
            switch result {
            case .success:
                XCTFail("Expected failure due to invalid data but received success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockNetworkService.didFetchTasksCalled)
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var didFetchTasksCalled = false
    var shouldReturnError = false
    var mockData: Data?

    func fetchTasks(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        didFetchTasksCalled = true
        if shouldReturnError {
            completion(.failure(NSError(domain: "Network error", code: 500)))
        } else if let data = mockData {
            completion(.success(data))
        } else {
            completion(.failure(NSError(domain: "Data error", code: 500)))
        }
    }
}
