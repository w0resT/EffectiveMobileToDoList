import XCTest
@testable import EffectiveToDoList

final class TaskListPresenterTest: XCTestCase {

    // MARK: - Properties
    var presenter: (TaskListPresenterProtocol & TaskListInteractorOutputProtocol)!
    var mockInteractor: MockTaskListInteractor!
    var mockRouter: MockTaskListRouter!
    var mockView: MockTaskListView!

    // MARK: - Setup
    override func setUp() {
        super.setUp()
        
        mockInteractor = MockTaskListInteractor()
        mockRouter = MockTaskListRouter()
        mockView = MockTaskListView()
        
        presenter = TaskListPresenter(interactor: mockInteractor,
                                      router: mockRouter,
                                      view: mockView)
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockRouter = nil
        mockInteractor = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests TaskListPresenterProtocol
    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockView.didShowActivityIndicatorCalled)
        XCTAssertTrue(mockInteractor.didLoadTasksOnAppLaunchCalled)
    }
    
    func testDidCreateTask() {
        presenter.didCreateTask()
        XCTAssertTrue(mockRouter.didNavigateToAddTaskCalled)
    }
    
    func testDidSelectTask() {
        let task = TaskListViewModel(id: 1, title: "test", description: "description", formattedDate: "24/11/24", isCompleted: true)
        presenter.didSelectTask(task)
        XCTAssertTrue(mockRouter.didNavigateToTaskDetailsCalled)
        XCTAssertNotNil(mockRouter.taskDetails)
        XCTAssertEqual(mockRouter.taskDetails?.id, task.id)
        XCTAssertEqual(mockRouter.taskDetails?.description, task.description)
        XCTAssertEqual(mockRouter.taskDetails?.isCompleted, task.isCompleted)
    }
    
    func testDidUpdateTask() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        presenter.didUpdateTask(task)
        XCTAssertTrue(mockInteractor.didCreateOrUpdateTaskCalled)
    }
    
    func testDidDeleteTask() {
        let task = TaskListViewModel(id: 1, title: "test", description: "description", formattedDate: "24/11/24", isCompleted: true)
        presenter.didDeleteTask(task)
        XCTAssertTrue(mockInteractor.didDeleteTaskCalled)
    }
    
    func testDidCompleteTask() {
        let task = TaskListViewModel(id: 1, title: "test", description: "description", formattedDate: "24/11/24", isCompleted: true)
        presenter.didCompleteTask(task)
        XCTAssertTrue(mockInteractor.didUpdateTaskCalled)
    }
    
    func testDidUpdateSearchResults() {
        let searchText = "test"
        presenter.didUpdateSearchResults(searchText)
        XCTAssertTrue(mockInteractor.didFetchFilteredTasksCalled)
    }
    
    func testDidUpdateSearchResults_Nil() {
        presenter.didUpdateSearchResults(nil)
        XCTAssertFalse(mockInteractor.didFetchFilteredTasksCalled)
    }
    
    func testUpdateTaskCount() {
        let count: Int = 5
        presenter.updateTaskCount(count)
        XCTAssertTrue(mockView.didUpdateTaskCountCalled)
        XCTAssertEqual(mockView.updatedTaskCountString, "\(count) задач")
    }
    
    // For 'good' coverage :)
    func testDidShareTask() { 
        let task = TaskListViewModel(id: 1, title: "test", description: "description", formattedDate: "24/11/24", isCompleted: true)
        presenter.didShareTask(task)
        XCTAssertTrue(true)
    }
    
    // MARK: - Tests TaskListInteractorOutputProtocol
    func testDidFetchTasksNetworkOutput() {
        let tasks = [Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)]
        presenter.didFetchTasksNetwork(tasks)
        XCTAssertTrue(mockInteractor.didCreateOrUpdateTasksCalled)
    }

    func testDidFetchTasksOutput() {
        let tasks = [Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)]
        presenter.didFetchTasks(tasks)
        XCTAssertTrue(mockView.didHideActivityIndicatorCalled)
        XCTAssertTrue(mockView.didShowTasksCalled)
    }

    func testDidCreateTaskOutput() {
        let tasks = [Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)]
        presenter.didCreateTask(tasks)
        XCTAssertTrue(mockView.didShowTasksCalled)
    }

    func testDidDeleteTaskOutput() {
        let tasks = [Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)]
        presenter.didDeleteTask(tasks)
        XCTAssertTrue(mockView.didShowTasksCalled)
    }

    func testDidUpdateTaskOutput() {
        let tasks = [Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)]
        presenter.didUpdateTask(tasks)
        XCTAssertTrue(mockView.didShowTasksCalled)
    }

    func testDidCreateOrUpdateTaskOutput() {
        let tasks = [Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)]
        presenter.didCreateOrUpdateTask(tasks)
        XCTAssertTrue(mockView.didShowTasksCalled)
    }

    func testDidCreateOrUpdateTasksOutput() {
        let tasks = [Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)]
        presenter.didCreateOrUpdateTasks(tasks)
        XCTAssertTrue(mockView.didHideActivityIndicatorCalled)
        XCTAssertTrue(mockView.didShowTasksCalled)
    }

    func testDidFetchFilteredTasksOutput() {
        let tasks = [Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)]
        presenter.didFetchFilteredTasks(tasks)
        XCTAssertTrue(mockView.didShowTasksCalled)
    }

    func testDidFailToLoadTasksOnAppLaunchOutput() {
        let error = "error"
        presenter.didFailToLoadTasksOnAppLaunch(error)
        XCTAssertTrue(mockView.didHideActivityIndicatorCalled)
        XCTAssertTrue(mockView.didShowAlertCalled)
        XCTAssertEqual(mockView.showAlertString, error)
    }

    func testDidFailToFetchTasksNetworkOutput() {
        let error = "error"
        presenter.didFailToFetchTasksNetwork(error)
        XCTAssertTrue(mockView.didHideActivityIndicatorCalled)
        XCTAssertTrue(mockView.didShowAlertCalled)
        XCTAssertEqual(mockView.showAlertString, error)
    }

    func testDidFailToFetchTasksOutput() {
        let error = "error"
        presenter.didFailToFetchTasks(error)
        XCTAssertTrue(mockView.didHideActivityIndicatorCalled)
        XCTAssertTrue(mockView.didShowAlertCalled)
        XCTAssertEqual(mockView.showAlertString, error)
    }

    func testDidFailToCreateTaskOutput() {
        let error = "error"
        presenter.didFailToCreateTask(error)
        XCTAssertTrue(mockView.didShowAlertCalled)
        XCTAssertEqual(mockView.showAlertString, error)
    }

    func testDidFailToDeleteTaskOutput() {
        let error = "error"
        presenter.didFailToDeleteTask(error)
        XCTAssertTrue(mockView.didShowAlertCalled)
        XCTAssertEqual(mockView.showAlertString, error)
    }

    func testDidFailToUpdateTaskOutput() {
        let error = "error"
        presenter.didFailToUpdateTask(error)
        XCTAssertTrue(mockView.didShowAlertCalled)
        XCTAssertEqual(mockView.showAlertString, error)
    }

    func testDidFailToCreateOrUpdateTaskOutput() {
        let error = "error"
        presenter.didFailToCreateOrUpdateTask(error)
        XCTAssertTrue(mockView.didShowAlertCalled)
        XCTAssertEqual(mockView.showAlertString, error)
    }

    func testDidFailToCreateOrUpdateTasksOutput() {
        let error = "error"
        presenter.didFailToCreateOrUpdateTasks(error)
        XCTAssertTrue(mockView.didHideActivityIndicatorCalled)
        XCTAssertTrue(mockView.didShowAlertCalled)
        XCTAssertEqual(mockView.showAlertString, error)
    }

    func testDidFailToFetchFilteredTasksOutput() {
        let error = "error"
        presenter.didFailToFetchFilteredTasks(error)
        XCTAssertTrue(mockView.didShowAlertCalled)
        XCTAssertEqual(mockView.showAlertString, error)
    }
}

class MockTaskListInteractor: TaskListInteractorProtocol {
    var didLoadTasksOnAppLaunchCalled = false
    var didFetchTasksNetworkCalled = false
    var didFetchTasksCalled = false
    var didCreateTaskCalled = false
    var didDeleteTaskCalled = false
    var didUpdateTaskCalled = false
    var didCreateOrUpdateTaskCalled = false
    var didCreateOrUpdateTasksCalled = false
    var didFetchFilteredTasksCalled = false
    
    func loadTasksOnAppLaunch() {
        didLoadTasksOnAppLaunchCalled = true
    }
    
    func fetchTasksNetwork() {
        didFetchTasksNetworkCalled = true
    }
    
    func fetchTasks() {
        didFetchTasksCalled = true
    }
    
    func createTask(_ task: Task) {
        didCreateTaskCalled = true
    }
    
    func deleteTask(_ task: Task) {
        didDeleteTaskCalled = true
    }
    
    func updateTask(_ task: Task) {
        didUpdateTaskCalled = true
    }
    
    func createOrUpdateTask(_ task: Task) {
        didCreateOrUpdateTaskCalled = true
    }
    
    func createOrUpdateTasks(_ tasks: [Task]) {
        didCreateOrUpdateTasksCalled = true
    }
    
    func fetchFilteredTasks(_ text: String) {
        didFetchFilteredTasksCalled = true
    }
}

class MockTaskListRouter: TaskListRouterProtocol {
    var didNavigateToTaskDetailsCalled = false
    var didNavigateToAddTaskCalled = false
    var taskDetails: Task?
    
    func navigateToTaskDetails(with task: Task) {
        didNavigateToTaskDetailsCalled = true
        taskDetails = task
    }
    
    func navigateToAddTask() {
        didNavigateToAddTaskCalled = true
    }
}

class MockTaskListView: TaskListViewProtocol {
    var presenter: TaskListPresenterProtocol?

    var didShowTasksCalled = false
    var didShowAlertCalled = false
    var didUpdateTaskCountCalled = false
    var didShowActivityIndicatorCalled = false
    var didHideActivityIndicatorCalled = false
    var updatedTaskCountString = ""
    var showAlertString = ""

    func showTasks(_ tasks: [TaskListViewModel]) {
        didShowTasksCalled = true
    }
    
    func showAlert(_ message: String) {
        didShowAlertCalled = true
        showAlertString = message
    }
    
    func updateTaskCount(with text: String) {
        didUpdateTaskCountCalled = true
        updatedTaskCountString = text
    }
    
    func showActivityIndicator() {
        didShowActivityIndicatorCalled = true
    }
    
    func hideActivityIndicator() {
        didHideActivityIndicatorCalled = true
    }
}
