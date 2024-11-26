import XCTest
@testable import EffectiveToDoList

final class TaskDetailsInteractorTests: XCTestCase {
    
    // MARK: - Properties
    var interactor: TaskDetailsInteractorProtocol!
    var mockPresenter: MockTaskDetailsInteractorOutput!

    // MARK: - Setup
    override func setUp() {
        super.setUp()
        
        mockPresenter = MockTaskDetailsInteractorOutput()
        interactor = TaskDetailsInteractor(presenter: mockPresenter)
    }
    
    override func tearDown() {
        interactor = nil
        mockPresenter = nil
 
        super.tearDown()
    }
    
    // MARK: - Tests
    func testSaveAndNavigationBack_EmptyTask() {
        let task = Task(id: 1, title: "", description: nil, dateCreated: Date.now, isCompleted: true)
        interactor.saveAndNavigationBack(task)
        XCTAssertTrue(mockPresenter.didNavigateBackCalled)
    }
    
    func testSaveAndNavigationBack_Delegate() {
        let task = Task(id: 1, title: "test", description: "description", dateCreated: Date.now, isCompleted: true)
        interactor.saveAndNavigationBack(task)
        XCTAssertTrue(mockPresenter.didDelegateAndNavigateBack)
    }
}

class MockTaskDetailsInteractorOutput: TaskDetailsInteractorOutputProtocol {
    var didNavigateBackCalled = false
    var didDelegateAndNavigateBack = false

    func didFetchTask(_ task: Task) {}
    
    func navigateBack() {
        didNavigateBackCalled = true
    }
    
    func delegateAndNavigateBack(_ task: Task) {
        didDelegateAndNavigateBack = true
    }
}
