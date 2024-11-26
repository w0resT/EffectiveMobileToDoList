import XCTest
@testable import EffectiveToDoList

final class TaskListInteractorTests: XCTestCase {

    // MARK: - Properties
    var interactor: TaskListInteractorProtocol!
    var mockPresenter: MockTaskListInteractorOutput!
    var mockNetworkManager: MockNetworkManager!
    var mockStorageManager: MockStorageManager!

    // MARK: - Setup
    override func setUp() {
        super.setUp()
        
        mockPresenter = MockTaskListInteractorOutput()
        mockNetworkManager = MockNetworkManager()
        mockStorageManager = MockStorageManager()
        interactor = TaskListInteractor(presenter: mockPresenter, 
                                        networkManager: mockNetworkManager,
                                        storageManager: mockStorageManager)
    }
    
    override func tearDown() {
        interactor = nil
        mockStorageManager = nil
        mockNetworkManager = nil
        mockPresenter = nil
 
        super.tearDown()
    }
    
    // MARK: - Tests
    func testLoadTasksOnAppLaunch_withNetworkFetch_Success() {
        mockStorageManager.hasTasksResult = .success(false)
        interactor.loadTasksOnAppLaunch()
        XCTAssertTrue(mockNetworkManager.didFetchTasksNetworkCalled)
    }
    
    func testLoadTasksOnAppLaunch_withStorageFetch_Success() {
        mockStorageManager.hasTasksResult = .success(true)
        interactor.loadTasksOnAppLaunch()
        XCTAssertTrue(mockStorageManager.didFetchTasksCalled)
    }
    
    func testLoadTasksOnAppLaunch_withStorageFetch_Failure() {
        mockStorageManager.hasTasksResult = .failure(NSError(domain: "Launch failed", code: 500))
        interactor.loadTasksOnAppLaunch()
        XCTAssertTrue(mockPresenter.didFailToLoadTasksOnAppLaunchCalled)
    }
    
    func testFetchTasksNetwork_Success() {
        let tasks = TaskListDTO(todos: [TaskDTO(id: 1, todo: "test", completed: false, userId: 2)])
        mockNetworkManager.fetchTasksResult = .success(tasks)
        
        interactor.fetchTasksNetwork()
        
        XCTAssertTrue(mockPresenter.didFetchTasksNetworkCalled)
        XCTAssertEqual(mockPresenter.didFetchResult.count, tasks.todos.count)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.id, tasks.todos.first!.id)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.title, tasks.todos.first!.todo)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.isCompleted, tasks.todos.first!.completed)
    }
    
    func testFetchTasksNetwork_Failure() {
        mockNetworkManager.fetchTasksResult = .failure(NSError(domain: "Network failed", code: 500))
        interactor.fetchTasksNetwork()
        XCTAssertTrue(mockPresenter.didFailToFetchTasksNetworkCalled)
    }
    
    func testFetchTasks_StorageFetch_Success() {
        let tasks = [Task(id: 1, title: "test", dateCreated: Date.now, isCompleted: true)]
        mockStorageManager.fetchTasksResult = .success(tasks)
        
        interactor.fetchTasks()
        
        XCTAssertTrue(mockPresenter.didFetchTasksCalled)
        XCTAssertEqual(mockPresenter.didFetchResult.count, tasks.count)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.id, tasks.first!.id)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.title, tasks.first!.title)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.dateCreated, tasks.first!.dateCreated)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.isCompleted, tasks.first!.isCompleted)
    }
    
    func testFetchTasks_StorageFetch_Failure() {
        mockStorageManager.fetchTasksResult = .failure(NSError(domain: "Storage failed", code: 500))
        interactor.fetchTasks()
        XCTAssertTrue(mockPresenter.didFailToFetchTasksCalled)
    }

    func testCreateTask_Success() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        mockStorageManager.fetchTasksResult = .success([task])
        
        interactor.createTask(task)
        
        XCTAssertTrue(mockStorageManager.didCreateTaskCalled)
        XCTAssertTrue(mockPresenter.didCreateTaskCalled)
        XCTAssertEqual(mockPresenter.didFetchResult.count, 1)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.id, task.id)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.title, task.title)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.description, task.description)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.dateCreated, task.dateCreated)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.isCompleted, task.isCompleted)
    }
    
    func testCreateTask_Failure() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        mockStorageManager.fetchTasksResult = .failure(NSError(domain: "Storage failed", code: 500))
        interactor.createTask(task)
        XCTAssertTrue(mockPresenter.didFailToCreateTaskCalled)
    }
    
    func testDeleteTask_Success() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        mockStorageManager.fetchTasksResult = .success([task])
        
        interactor.deleteTask(task)
        
        XCTAssertTrue(mockStorageManager.didDeleteTaskCalled)
        XCTAssertTrue(mockPresenter.didDeleteTaskCalled)
        XCTAssertEqual(mockPresenter.didFetchResult.count, 1)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.id, task.id)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.title, task.title)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.description, task.description)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.dateCreated, task.dateCreated)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.isCompleted, task.isCompleted)
    }
    
    func testDeleteTask_Failure() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        mockStorageManager.fetchTasksResult = .failure(NSError(domain: "Storage failed", code: 500))
        interactor.deleteTask(task)
        XCTAssertTrue(mockPresenter.didFailToDeleteTaskCalled)
    }

    func testUpdateTask_Success() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        mockStorageManager.fetchTasksResult = .success([task])
        
        interactor.updateTask(task)
        
        XCTAssertTrue(mockStorageManager.didUpdateTaskCalled)
        XCTAssertTrue(mockPresenter.didUpdateTaskCalled)
        XCTAssertEqual(mockPresenter.didFetchResult.count, 1)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.id, task.id)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.title, task.title)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.description, task.description)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.dateCreated, task.dateCreated)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.isCompleted, task.isCompleted)
    }
    
    func testUpdateTask_Failure() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        mockStorageManager.fetchTasksResult = .failure(NSError(domain: "Storage failed", code: 500))
        interactor.updateTask(task)
        XCTAssertTrue(mockPresenter.didFailToUpdateTaskCalled)
    }
    
    func testCreateOrUpdateTask_Success() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        mockStorageManager.fetchTasksResult = .success([task])
        
        interactor.createOrUpdateTask(task)
        
        XCTAssertTrue(mockStorageManager.didCreateOrUpdateTaskCalled)
        XCTAssertTrue(mockPresenter.didCreateOrUpdateTaskCalled)
        XCTAssertEqual(mockPresenter.didFetchResult.count, 1)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.id, task.id)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.title, task.title)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.description, task.description)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.dateCreated, task.dateCreated)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.isCompleted, task.isCompleted)
    }
    
    func testCreateOrUpdateTask_Failure() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        mockStorageManager.fetchTasksResult = .failure(NSError(domain: "Storage failed", code: 500))
        interactor.createOrUpdateTask(task)
        XCTAssertTrue(mockPresenter.didFailToCreateOrUpdateTaskCalled)
    }
    
    func testCreateOrUpdateTasks_Success() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        mockStorageManager.fetchTasksResult = .success([task])
        
        interactor.createOrUpdateTasks([task])
        
        XCTAssertTrue(mockStorageManager.didCreateOrUpdateTasksCalled)
        XCTAssertTrue(mockPresenter.didCreateOrUpdateTasksCalled)
        XCTAssertEqual(mockPresenter.didFetchResult.count, 1)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.id, task.id)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.title, task.title)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.description, task.description)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.dateCreated, task.dateCreated)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.isCompleted, task.isCompleted)
    }
    
    func testCreateOrUpdateTasks_Failure() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        mockStorageManager.fetchTasksResult = .failure(NSError(domain: "Storage failed", code: 500))
        interactor.createOrUpdateTasks([task])
        XCTAssertTrue(mockPresenter.didFailToCreateOrUpdateTasksCalled)
    }
    
    func testFetchFilteredTasks_Success() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        let filterText = "te"
        mockStorageManager.fetchTasksResult = .success([task])
        
        interactor.fetchFilteredTasks(filterText)
        
        XCTAssertTrue(mockStorageManager.didFetchFilteredTasksCalled)
        XCTAssertTrue(mockPresenter.didFetchFilteredTasksCalled)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.title, task.title)
    }
    
    func testFetchFilteredTasks_Failure() {
        let filterText = "filter"
        mockStorageManager.fetchTasksResult = .failure(NSError(domain: "Storage failed", code: 500))
        interactor.fetchFilteredTasks(filterText)
        XCTAssertTrue(mockPresenter.didFailToFetchFilteredTasksCalled)
    }
    
    func testFetchFilteredTasks_EmptyFilter_Success() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        let filterText = ""
        mockStorageManager.fetchTasksResult = .success([task])
        
        interactor.fetchFilteredTasks(filterText)
        
        XCTAssertFalse(mockStorageManager.didFetchFilteredTasksCalled)
        XCTAssertTrue(mockPresenter.didFetchFilteredTasksCalled)
        XCTAssertEqual(mockPresenter.didFetchResult.count, 1)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.id, task.id)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.title, task.title)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.description, task.description)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.dateCreated, task.dateCreated)
        XCTAssertEqual(mockPresenter.didFetchResult.first?.isCompleted, task.isCompleted)
    }
    
    func testFetchFilteredTasks_EmptyFilter_Failure() {
        let filterText = ""
        mockStorageManager.fetchTasksResult = .failure(NSError(domain: "Storage failed", code: 500))
        interactor.fetchFilteredTasks(filterText)
        XCTAssertTrue(mockPresenter.didFailToFetchFilteredTasksCalled)
    }
}

class MockTaskListInteractorOutput: TaskListInteractorOutputProtocol {
    var didFetchTasksNetworkCalled = false
    var didFetchTasksCalled = false
    var didCreateTaskCalled = false
    var didDeleteTaskCalled = false
    var didUpdateTaskCalled = false
    var didCreateOrUpdateTaskCalled = false
    var didCreateOrUpdateTasksCalled = false
    var didFetchFilteredTasksCalled = false
    
    var didFailToLoadTasksOnAppLaunchCalled = false
    var didFailToFetchTasksNetworkCalled = false
    var didFailToFetchTasksCalled = false
    var didFailToCreateTaskCalled = false
    var didFailToDeleteTaskCalled = false
    var didFailToUpdateTaskCalled = false
    var didFailToCreateOrUpdateTaskCalled = false
    var didFailToCreateOrUpdateTasksCalled = false
    var didFailToFetchFilteredTasksCalled = false
    
    var didFetchResult: [Task] = []
    
    
    func didFetchTasksNetwork(_ tasks: [Task]) {
        didFetchTasksNetworkCalled = true
        didFetchResult = tasks
    }
    
    func didFetchTasks(_ tasks: [Task]) {
        didFetchTasksCalled = true
        didFetchResult = tasks
    }
    
    func didCreateTask(_ tasks: [Task]) {
        didCreateTaskCalled = true
        didFetchResult = tasks
    }
    
    func didDeleteTask(_ tasks: [Task]) {
        didDeleteTaskCalled = true
        didFetchResult = tasks
    }
    
    func didUpdateTask(_ tasks: [Task]) {
        didUpdateTaskCalled = true
        didFetchResult = tasks
    }
    
    func didCreateOrUpdateTask(_ tasks: [Task]) {
        didCreateOrUpdateTaskCalled = true
        didFetchResult = tasks
    }
    
    func didCreateOrUpdateTasks(_ tasks: [Task]) {
        didCreateOrUpdateTasksCalled = true
        didFetchResult = tasks
    }
    
    func didFetchFilteredTasks(_ tasks: [Task]) {
        didFetchFilteredTasksCalled = true
        didFetchResult = tasks
    }
    
    func didFailToLoadTasksOnAppLaunch(_ error: String) {
        didFailToLoadTasksOnAppLaunchCalled = true
    }
    
    func didFailToFetchTasksNetwork(_ error: String) {
        didFailToFetchTasksNetworkCalled = true
    }
    
    func didFailToFetchTasks(_ error: String) {
        didFailToFetchTasksCalled = true
    }
    
    func didFailToCreateTask(_ error: String) {
        didFailToCreateTaskCalled = true
    }
    
    func didFailToDeleteTask(_ error: String) {
        didFailToDeleteTaskCalled = true
    }
    
    func didFailToUpdateTask(_ error: String) {
        didFailToUpdateTaskCalled = true
    }
    
    func didFailToCreateOrUpdateTask(_ error: String) {
        didFailToCreateOrUpdateTaskCalled = true
    }
    
    func didFailToCreateOrUpdateTasks(_ error: String) {
        didFailToCreateOrUpdateTasksCalled = true
    }
    
    func didFailToFetchFilteredTasks(_ error: String) {
        didFailToFetchFilteredTasksCalled = true
    }
}

class MockNetworkManager: NetworkManagerProtocol {
    var didFetchTasksNetworkCalled = false
    var fetchTasksResult: Result<TaskListDTO, Error>?

    func fetchTasks(urlString: String, completion: @escaping (Result<TaskListDTO, Error>) -> Void) {
        didFetchTasksNetworkCalled = true
        if let result = fetchTasksResult {
            completion(result)
        }
    }
}

class MockStorageManager: StorageManagerProtocol {
    var didHasTasksCalled = false
    var didFetchTasksCalled = false
    var didCreateTaskCalled = false
    var didUpdateTaskCalled = false
    var didDeleteTaskCalled = false
    var didFetchFilteredTasksCalled = false
    var didCreateOrUpdateTaskCalled = false
    var didCreateOrUpdateTasksCalled = false

    var hasTasksResult: Result<Bool, Error> = .success(false)
    var fetchTasksResult: Result<[Task], Error> = .success([])
    
    func hasTasks(completion: @escaping (Result<Bool, Error>) -> Void) {
        didHasTasksCalled = true
        completion(hasTasksResult)
    }

    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        didFetchTasksCalled = true
        completion(fetchTasksResult)
    }

    func createTask(_ task: EffectiveToDoList.Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        didCreateTaskCalled = true
        completion(fetchTasksResult)
    }

    func updateTask(_ task: EffectiveToDoList.Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        didUpdateTaskCalled = true
        completion(fetchTasksResult)
    }

    func deleteTask(_ task: EffectiveToDoList.Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        didDeleteTaskCalled = true
        completion(fetchTasksResult)
    }

    func fetchFilteredTasks(_ text: String, completion: @escaping (Result<[Task], Error>) -> Void) {
        didFetchFilteredTasksCalled = true
        completion(fetchTasksResult)
    }

    func createOrUpdateTask(_ task: EffectiveToDoList.Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        didCreateOrUpdateTaskCalled = true
        completion(fetchTasksResult)
    }

    func createOrUpdateTasks(_ tasks: [EffectiveToDoList.Task], completion: @escaping (Result<[Task], Error>) -> Void) {
        didCreateOrUpdateTasksCalled = true
        completion(fetchTasksResult)
    }
}
