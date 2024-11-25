import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Properties
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data")
            }
        }
        
        return container
    }()
    
    private var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    // MARK: - Operations
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        performOperationAndFetchAll(operation: nil, completion: completion)
    }
    
    func createTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        performOperationAndFetchAll(operation: { context in
            let taskEntity = TaskEntity(context: context)
            taskEntity.id = Int64(task.id)
            taskEntity.title = task.title
            taskEntity.descriptionText = task.description
            taskEntity.dateCreated = task.dateCreated
            taskEntity.isCompleted = task.isCompleted
            try context.save()
        }, completion: completion)
    }
    
    func updateTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        performOperationAndFetchAll(operation: { context in
            let fetchRequest = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
            
            guard let taskEntity = try context.fetch(fetchRequest).first else {
                throw CoreDataManagerError.taskNotFound
            }
            
            taskEntity.title = task.title
            taskEntity.descriptionText = task.description
            taskEntity.dateCreated = task.dateCreated
            taskEntity.isCompleted = task.isCompleted
            
            try context.save()
        }, completion: completion)
    }
    
    func deleteTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        performOperationAndFetchAll(operation: { context in
            let fetchRequest = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
            
            guard let taskEntity = try context.fetch(fetchRequest).first else {
                throw CoreDataManagerError.taskNotFound
            }
            
            context.delete(taskEntity)
            try context.save()
        }, completion: completion)
    }
    
    func createOrUpdateTask(_ task: Task, completion: @escaping (Result<[Task], Error>) -> Void) {
        performOperationAndFetchAll(operation: { context in
            let fetchRequest = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
            
            // Изменяем запись если она существует, или создаем новую
            if let taskEntity = try context.fetch(fetchRequest).first {
                taskEntity.title = task.title
                taskEntity.descriptionText = task.description
                taskEntity.dateCreated = task.dateCreated
                taskEntity.isCompleted = task.isCompleted
            } else {
                // TODO: Заменить на UUID
                let taskId: Int64
                if task.id == 0 {
                    fetchRequest.predicate = NSPredicate(format: "id == max(id)")
                    
                    // Если есть запись, то ставим "ID = ID + 1", если нет - "ID = 1"
                    taskId = (try context.fetch(fetchRequest).first?.id ?? 0) + 1
                } else {
                    taskId = Int64(task.id)
                }
                
                let newTask = TaskEntity(context: context)
                newTask.id = taskId
                newTask.title = task.title
                newTask.descriptionText = task.description
                newTask.dateCreated = task.dateCreated
                newTask.isCompleted = task.isCompleted
            }
            try context.save()
        }, completion: completion)
    }
    
    func fetchFilteredTasks(_ text: String, completion: @escaping (Result<[Task], Error>) -> Void) {
        let context = backgroundContext
        context.perform {
            do {
                let fetchRequest = TaskEntity.fetchRequest()
                
                // Фильтр не чувствителен к регистру и к диакритическим знакам
                fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
                
                let taskEntities = try context.fetch(fetchRequest)
                let tasks = taskEntities.map {
                    Task(
                        id: Int($0.id),
                        title: $0.title ?? "",
                        description: $0.descriptionText,
                        dateCreated: $0.dateCreated ?? Date.now,
                        isCompleted: $0.isCompleted)
                }
                
                completion(.success(tasks))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private init() { }
}

// MARK: - Helpers
private extension CoreDataManager {
    func performOperationAndFetchAll(operation: ((NSManagedObjectContext) throws -> Void)? = nil,
                                     completion: @escaping (Result<[Task], Error>) -> Void) {
        let context = backgroundContext
        context.perform {
            do {
                if let operation = operation {
                    try operation(context)
                }
                
                let fetchRequest = TaskEntity.fetchRequest()
                let taskEntities = try context.fetch(fetchRequest)
                let tasks = taskEntities.map {
                    Task(
                        id: Int($0.id),
                        title: $0.title ?? "",
                        description: $0.descriptionText,
                        dateCreated: $0.dateCreated ?? Date.now,
                        isCompleted: $0.isCompleted)
                }
                
                completion(.success(tasks))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

enum CoreDataManagerError: Error {
    case taskNotFound
}
