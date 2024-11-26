import XCTest
@testable import EffectiveToDoList

final class StorageManagerTests: XCTestCase {

    // MARK: - Properties
    var storageManager: StorageManager!
    var mockCoreDataManager: MockCoreDataManager!

    // MARK: - Setup
    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager()
        storageManager = StorageManager(coreDataManager: mockCoreDataManager)
    }
    
    override func tearDown() {
        storageManager = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func testHasTasks_Success() {
        mockCoreDataManager.hasTasksResult = .success(true)

        let expectation = XCTestExpectation(description: "hasTasks completion called")
        
        storageManager.hasTasks { result in
            switch result {
            case .success(let hasTasks):
                XCTAssertTrue(hasTasks)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchTasks_Success() {
        let expectedTasks = [Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)]
        mockCoreDataManager.fetchTasksResult = .success(expectedTasks)
        
        let expectation = XCTestExpectation(description: "fetchTasks completion called")
        
        storageManager.fetchTasks { result in
            switch result {
            case .success(let tasks):
                XCTAssertEqual(tasks.count, expectedTasks.count)
                XCTAssertEqual(tasks.first, expectedTasks.first)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCreateTask_Failure() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        mockCoreDataManager.createTaskResult = .failure(NSError(domain: "Test error", code: 500))
        
        let expectation = XCTestExpectation(description: "createTask completion called")
        
        storageManager.createTask(task) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateTask_Success() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        let expectedTasks = [task]
        mockCoreDataManager.updateTaskResult = .success(expectedTasks)
        
        let expectation = XCTestExpectation(description: "updateTask completion called")

        storageManager.updateTask(task) { result in
            switch result {
            case .success(let tasks):
                XCTAssertEqual(tasks.count, expectedTasks.count)
                XCTAssertEqual(tasks.first, expectedTasks.first)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDeleteTask_Success() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        let expectedTasks = [Task(id: 2, title: "not test", description: "not description", dateCreated: Date.now, isCompleted: false)]
        mockCoreDataManager.deleteTaskResult = .success(expectedTasks)
        
        let expectation = XCTestExpectation(description: "deleteTask completion called")

        storageManager.deleteTask(task) { result in
            switch result {
            case .success(let tasks):
                XCTAssertEqual(tasks.count, expectedTasks.count)
                XCTAssertEqual(tasks.first, expectedTasks.first)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testDeleteTask_Failure() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        mockCoreDataManager.deleteTaskResult = .failure(NSError(domain: "Test error", code: 500))
        
        let expectation = XCTestExpectation(description: "deleteTask completion called")

        storageManager.deleteTask(task) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testCreateOrUpdateTask_Success() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        let expectedTasks = [task]
        mockCoreDataManager.createOrUpdateTaskResult = .success(expectedTasks)
        
        let expectation = XCTestExpectation(description: "createOrUpdateTask completion called")

        storageManager.createOrUpdateTask(task) { result in
            switch result {
            case .success(let tasks):
                XCTAssertEqual(tasks.count, expectedTasks.count)
                XCTAssertEqual(tasks.first, expectedTasks.first)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testCreateOrUpdateTask_Failure() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        mockCoreDataManager.createOrUpdateTaskResult = .failure(NSError(domain: "Test error", code: 500))
        
        let expectation = XCTestExpectation(description: "createOrUpdateTask completion called")

        storageManager.createOrUpdateTask(task) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testCreateOrUpdateTasks_Success() {
        let tasks = [
            Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true),
            Task(id: 2, title: "not test", description: "not description", dateCreated: Date.now, isCompleted: false)
        ]
        mockCoreDataManager.createOrUpdateTasksResult = .success(tasks)
        
        let expectation = XCTestExpectation(description: "createOrUpdateTasks completion called")

        storageManager.createOrUpdateTasks(tasks) { result in
            switch result {
            case .success(let updatedTasks):
                XCTAssertEqual(updatedTasks.count, tasks.count)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
 
        wait(for: [expectation], timeout: 1.0)
    }

    func testCreateOrUpdateTasks_Failure() {
        let tasks = [
            Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true),
            Task(id: 2, title: "not test", description: "not description", dateCreated: Date.now, isCompleted: false)
        ]
        mockCoreDataManager.createOrUpdateTasksResult = .failure(NSError(domain: "Test error", code: 500))
        
        let expectation = XCTestExpectation(description: "createOrUpdateTasks completion called")

        storageManager.createOrUpdateTasks(tasks) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchFilteredTasks_EmptyResult() {
        let searchText = "Free cookies"
        mockCoreDataManager.fetchFilteredTasksResult = .success([])
        
        let expectation = XCTestExpectation(description: "fetchFilteredTasks completion called")
 
        storageManager.fetchFilteredTasks(searchText) { result in
            switch result {
            case .success(let tasks):
                XCTAssertTrue(tasks.isEmpty)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockCoreDataManager: CoreDataManagerProtocol {
    var hasTasksResult: Result<Bool, Error>?
    var fetchTasksResult: Result<[Task], Error>?
    var createTaskResult: Result<[Task], Error>?
    var updateTaskResult: Result<[Task], Error>?
    var deleteTaskResult: Result<[Task], Error>?
    var createOrUpdateTaskResult: Result<[Task], Error>?
    var createOrUpdateTasksResult: Result<[Task], Error>?
    var fetchFilteredTasksResult: Result<[Task], Error>?
    
    func hasTasks(completion: @escaping (Result<Bool, Error>) -> Void) {
        if let result = hasTasksResult {
            completion(result)
        }
    }
    
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        if let result = fetchTasksResult {
            completion(result)
        }
    }
    
    func createTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        if let result = createTaskResult {
            completion(result)
        }
    }
    
    func updateTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        if let result = updateTaskResult {
            completion(result)
        }
    }
    
    func deleteTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        if let result = deleteTaskResult {
            completion(result)
        }
    }
    
    func createOrUpdateTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        if let result = createOrUpdateTaskResult {
            completion(result)
        }
    }
    
    func createOrUpdateTasks(_ tasks: [Task], completion: @escaping (Result<[Task], Error>) -> Void) {
        if let result = createOrUpdateTasksResult {
            completion(result)
        }
    }
    
    func fetchFilteredTasks(_ text: String, completion: @escaping (Result<[Task], Error>) -> Void) {
        if let result = fetchFilteredTasksResult {
            completion(result)
        }
    }
}
