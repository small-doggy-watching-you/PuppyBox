
import CoreData
import UIKit

final class CoreDataManager {
    
    // MARK: - Properties
    // 싱글톤 패턴을 사용해서 어디서든 CoreDataManager.shared로 접근할 수 있게 함
    static let shared = CoreDataManager()
    
    // MARK: - Initializers
    private init() {}
    
    // CoreData의 저장소(= 데이터베이스)를 앱에 로드함, 이 안에는 SQLite 백엔드가 자동으로 설정됨
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PuppyBox") // ← .xcdatamodeld 파일명
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("failed to load persistent stores: \(error)")
            }
        }
        return container
    }()

    // 앱 전역에서 사용할 컨텍스트를 간편하게 접근할 수 있도록 별도 프로퍼티로 노출
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // 컨텍스트 저장
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("falied to save context: \(error)")
            }
        }
    }
    
}
