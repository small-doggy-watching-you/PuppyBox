
import CoreData
import UIKit

final class CoreDataManager {
    // MARK: - Initializers

    private init() {}

    // MARK: - Properties

    // 싱글톤 패턴을 사용해서 어디서든 CoreDataManager.shared로 접근할 수 있게 함
    static let shared = CoreDataManager()

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

    // MARK: Methods

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

    // 기본계정 생성
    func createBasicAccount() {
        // 관리자 계정 생성
        let admin = Account(context: context)
        admin.id = UUID()
        admin.userId = "admin"
        admin.name = "관리자"
        admin.password = "admin123"
        admin.email = "admin@example.com"
        admin.phone = "010-0001-0001"
        admin.profile = "AdminProfile"
        admin.isAdmin = true

        // 게스트 계정 생성
        let guest = Account(context: context)
        guest.id = UUID()
        guest.userId = "guest"
        guest.name = "게스트"
        guest.password = "guest123"
        guest.email = "guest@example.com"
        guest.phone = "010-0001-0002"
        guest.profile = "GuestProfile"
        guest.isAdmin = false

        saveContext()
        print("기본 계정 생성 완료")
    }

    // 모든 데이터 추출함수
    func fetchAllAccount() -> [Account] {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return (try? context.fetch(fetchRequest)) ?? []
    }

    // 기본 데이터 삭제함수 (필요시 호출해서 계정정보 삭제)
    func resetAllAccounts() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Account.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("모든 계정 삭제 완료")
        } catch {
            print("계정 삭제 실패: \(error)")
        }

        // UserDefaults 키 초기화
        @UserSetting(key: UDKey.isBasicAccountExist, defaultValue: false)
        var isBasicAccountExist
        isBasicAccountExist = false
        print(" UserDefaults 상태 초기화 완료")
    }

    // 비밀번호 획득 함수
    func loginVerification(userId: String, password: String) -> Bool {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userId) // 유저 id와 일치하는 데이터 검색
        fetchRequest.fetchLimit = 1 // 1건만 (성능향상)

        guard let account = (try? context.fetch(fetchRequest))?.first else { // 일치하는 데이터가 없을 경우 false
            return false
        }

        // 입력한 패스워드와 일치하면 true 다를경우 false
        return account.password == password ? true : false
    }
}
