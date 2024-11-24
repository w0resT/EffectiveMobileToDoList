import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var isCompleted: Bool

}

extension TaskEntity : Identifiable {

}
