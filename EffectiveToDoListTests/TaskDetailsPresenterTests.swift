import XCTest
@testable import EffectiveToDoList

final class TaskDetailsPresenterTests: XCTestCase {

    // MARK: - Properties
    var presenter: (TaskDetailsPresenterProtocol & TaskDetailsInteractorOutputProtocol)!
    var mockInteractor: MockTaskDetailsInteractor!
    var mockRouter: MockTaskDetailsRouter!
    var mockView: MockTaskDetailsView!
    var mockDelegate: MockTaskDetailsDelegate!

    // MARK: - Setup
    override func setUp() {
        super.setUp()
        
        mockInteractor = MockTaskDetailsInteractor()
        mockRouter = MockTaskDetailsRouter()
        mockView = MockTaskDetailsView()
        mockDelegate = MockTaskDetailsDelegate()
        
        presenter = TaskDetailsPresenter(interactor: mockInteractor,
                                         router: mockRouter,
                                         view: mockView,
                                         delegate: mockDelegate)
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockRouter = nil
        mockInteractor = nil
        
        super.tearDown()
    }

    // MARK: - Tests TaskDetailsPresenterProtocol
    func testDidChangeTitle() {
        let title = "never gonna give ur up"
        presenter.didChangeTitle(with: title)
        XCTAssertTrue(mockView.didUpdateTitleCalled)
        XCTAssertEqual(mockView.updatedString, title)
    }
    
    func testDidChangeDescription() {
        let description = "Never gonna let you down"
        presenter.didChangeDescription(with: description)
        XCTAssertTrue(mockView.didUpdateDescription)
        XCTAssertEqual(mockView.updatedString, description)
    }
    
    func testDidTapBackButton() {
        let task = Task(id: 1, title: "test", dateCreated: Date.now, isCompleted: true)
        let taskViewModel = TaskListViewModel(task: task)
        presenter.didTapBackButton(task: taskViewModel)
        XCTAssertTrue(mockInteractor.didSaveAndNavigationBackCalled)
        XCTAssertEqual(mockInteractor.fetchedTask?.id, task.id)
        XCTAssertEqual(mockInteractor.fetchedTask?.title, task.title)
        XCTAssertEqual(mockInteractor.fetchedTask?.isCompleted, task.isCompleted)
    }
    
    func testDidTapBackButton_withWhitespaces() {
        let taskViewModel = TaskListViewModel(task: Task(id: 1, title: "  test  ", description: "  description ", dateCreated: Date.now, isCompleted: true))
        let expectedTask = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        presenter.didTapBackButton(task: taskViewModel)
        XCTAssertTrue(mockInteractor.didSaveAndNavigationBackCalled)
        XCTAssertEqual(mockInteractor.fetchedTask?.id, expectedTask.id)
        XCTAssertEqual(mockInteractor.fetchedTask?.title, expectedTask.title)
        XCTAssertEqual(mockInteractor.fetchedTask?.isCompleted, expectedTask.isCompleted)
    }
    
    // MARK: - Tests TaskDetailsInteractorOutputProtocol
    /*
     
     func delegateAndNavigateBack(_ task: Task) {
         delegate?.didUpdateTask(task)
         router?.navigateBack()
     }
     
     */
    
    func testDidFetchTask() {
        let task = Task(id: 1, title: "test", dateCreated: Date.now, isCompleted: true)
        presenter.didFetchTask(task)
        XCTAssertTrue(mockView.didShowTaskDetailsCalled)
        XCTAssertEqual(mockView.fetchedTask?.id, task.id)
        XCTAssertEqual(mockView.fetchedTask?.title, task.title)
        XCTAssertEqual(mockView.fetchedTask?.isCompleted, task.isCompleted)
    }
    
    func testNavigateBack() {
        presenter.navigateBack()
        XCTAssertTrue(mockRouter.didNavigateBackCalled)
    }
    
    func testDelegateAndNavigateBack() {
        let task = Task(id: 1, title: "test", dateCreated: Date.now, isCompleted: true)
        presenter.delegateAndNavigateBack(task)
        XCTAssertTrue(mockRouter.didNavigateBackCalled)
        XCTAssertTrue(mockDelegate.didUpdateTaskCalled)
        XCTAssertEqual(mockDelegate.fetchedTask?.id, task.id)
        XCTAssertEqual(mockDelegate.fetchedTask?.title, task.title)
        XCTAssertEqual(mockDelegate.fetchedTask?.isCompleted, task.isCompleted)
    }
}

class MockTaskDetailsInteractor: TaskDetailsInteractorProtocol {
    var didSaveAndNavigationBackCalled = false
    var fetchedTask: Task?
    
    func saveAndNavigationBack(_ task: Task) {
        didSaveAndNavigationBackCalled = true
        fetchedTask = task
    }
}

class MockTaskDetailsRouter: TaskDetailsRouterProtocol {
    var didNavigateBackCalled = false
    
    func navigateBack() {
        didNavigateBackCalled = true
    }
}

class MockTaskDetailsView: TaskDetailsViewProtocol {
    var presenter: TaskDetailsPresenterProtocol?
    
    var didShowTaskDetailsCalled = false
    var didUpdateTitleCalled = false
    var didUpdateDescription = false
    var updatedString = ""
    var fetchedTask: TaskListViewModel?
    
    func showTaskDetails(_ task: TaskListViewModel) {
        didShowTaskDetailsCalled = true
        fetchedTask = task
    }
    
    func updateTitle(with text: String) {
        didUpdateTitleCalled = true
        updatedString = text
    }
    
    func updateDescription(with text: String) {
        didUpdateDescription = true
        updatedString = text
    }
}

class MockTaskDetailsDelegate: TaskDetailsDelegate {
    var didUpdateTaskCalled = false
    var fetchedTask: Task?
    
    func didUpdateTask(_ task: Task) {
        didUpdateTaskCalled = true
        fetchedTask = task
    }
}
