
import CoreData
import UIKit

final class CoreDataManager {
    // MARK: - Initializers

    private init() {}

    // MARK: - Properties

    // 싱글톤 패턴을 사용해서 어디서든 CoreDataManager.shared로 접근할 수 있게 함
    static let shared = CoreDataManager()

    // CoreData의 저장소(= 데이터베이스)를 앱에 로드함, 이 안에는 SQLite 백엔드가 자동으로 설정됨
    private lazy var persistentContainer: NSPersistentContainer = {
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

    // 모든 데이터 추출함수
    func fetchAllAccount() -> [Account] {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return (try? context.fetch(fetchRequest)) ?? []
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

    // 생성가능한 유저 아이디인지 확인
    func userIdVerfication(userId: String) -> Bool {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)
        guard ((try? context.fetch(fetchRequest))?.first) != nil else {
            // 일치하는 데이터가 없을 경우 true(생성 가능)
            return true
        }
        // 일치하는 데이터 존재할 경우 false(생성불가)
        return false
    }

    // 회원 정보 추가
    func createUser(userId: String, name: String, password: String, email: String?, phone: String?) {
        let guest = Account(context: context)
        guest.id = UUID()
        guest.userId = userId
        guest.name = name
        guest.password = password
        guest.email = email ?? ""
        guest.phone = phone ?? ""
        guest.profile = "defaultProfile"
        guest.isAdmin = false

        saveContext()
    }

    // 로그인 된 아이디의 정보 획득
    func fetchAccount(userId: String) -> Account? {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)
        fetchRequest.fetchLimit = 1

        return try? context.fetch(fetchRequest).first
    }

    // 특정 영화 예약이 이미 존재하는지 검사
    func reservationExists(for account: Account, movieId: Int32, screeningDate: Date) -> Bool {
        let fetchRequest: NSFetchRequest<Reservation> = Reservation.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "user == %@", account),
            NSPredicate(format: "movieId == %d", movieId),
            NSPredicate(format: "screeningDate == %@", screeningDate as NSDate)
        ])
        fetchRequest.fetchLimit = 1
        let count = (try? context.count(for: fetchRequest)) ?? 0
        return count > 0
    }

    // 영화 예약 추가
    func addReservation(for account: Account, movieId: Int32, movieName: String, posterImagePath: String, screeningDate: Date) -> Bool {
        if reservationExists(for: account, movieId: movieId, screeningDate: screeningDate) {
            print("⚠️ 동일한 예약이 이미 존재하므로 추가하지 않습니다.")
            return false
        }
        
        let reservation = Reservation(context: context)
        reservation.movieId = movieId
        reservation.movieName = movieName
        reservation.posterImagePath = posterImagePath
        reservation.screeningDate = screeningDate
        reservation.userId = account.userId
        reservation.user = account

        saveContext()
        return true
    }

    // 관람 기록 호출
    func fetchWatchedMovies(for account: Account) -> [WatchedMovie] {
        let fetchRequest: NSFetchRequest<WatchedMovie> = WatchedMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "owner == %@", account)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "screeningDate", ascending: false)]

        return (try? context.fetch(fetchRequest)) ?? []
    }

    // 실행시 날짜가 지나면 예매기록에서 관람 기록으로 이동하는 함수 (근데 이거 원래 서버쪽에서...)
    func moveExpiredReservationsToWatched(for account: Account) {
        let now = Date()
        let fetchRequest: NSFetchRequest<Reservation> = Reservation.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "user == %@", account),
            NSPredicate(format: "screeningDate < %@", now as NSDate)
        ])

        guard let expiredReservations = try? context.fetch(fetchRequest) else { return }

        for reservation in expiredReservations {
            let watched = WatchedMovie(context: context)
            watched.movieId = reservation.movieId
            watched.movieName = reservation.movieName
            watched.posterImagePath = reservation.posterImagePath ?? ""
            watched.screeningDate = reservation.screeningDate
            watched.owner = account

            context.delete(reservation)
        }

        saveContext()
    }
}

extension CoreDataManager {
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
        admin.profile = "adminProfile"
        admin.isAdmin = true

        // 게스트 계정 생성
        let guest = Account(context: context)
        guest.id = UUID()
        guest.userId = "guest"
        guest.name = "게스트"
        guest.password = "guest123"
        guest.email = "guest@example.com"
        guest.phone = "010-0001-0002"
        guest.profile = "defaultProfile"
        guest.isAdmin = false

        addDummyWatchedMovies(to: guest)

        saveContext()
        print("기본 계정 생성 완료")
    }

    // 더미 관람기록 추가
    func addDummyWatchedMovies(to account: Account) {
        let sampleMovies: [(Int32, String, String, String)] = [
            (1, "가라데 키드: 레전드", "https://image.tmdb.org/t/p/w92/AEgggzRr1vZCLY86MAp93li43z.jpg", "2025-07-01 20:00"),
            (2, "쥬라기 월드: 새로운 시작", "https://image.tmdb.org/t/p/w92/ygr4hE8Qpagv8sxZbMw1mtYkcQE.jpg", "2025-07-03 18:30"),
            (3, "브링 허 백", "https://image.tmdb.org/t/p/w92/A4W0yRN7Xy6JLIhRymIh5plK2Zj.jpg", "2025-07-05 17:00"),
            (4, "판타스틱 4: 새로운 출발", "https://image.tmdb.org/t/p/w92/sHgIQvDlk5188wo9jM8IKFeyJUd.jpg", "2025-07-07 16:30"),
            (5, "스머프", "https://image.tmdb.org/t/p/w92/1lQHA18T32JyIonQUkSWhMwinjm.jpg", "2025-07-09 19:20")
        ]

        for (id, name, image, dateStr) in sampleMovies {
            let movie = WatchedMovie(context: context)
            movie.movieId = id
            movie.movieName = name
            movie.posterImagePath = image
            movie.screeningDate = DateFormat.stringToDate(dateStr)!
            movie.owner = account
        }

        saveContext()
    }

    // 기본 데이터 삭제함수 (필요시 호출해서 계정정보 삭제)
    func resetAllAccounts() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        do {
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            let objectIDs = result?.result as? [NSManagedObjectID] ?? []
            let changes = [NSDeletedObjectsKey: objectIDs]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            try context.save()
            print("모든 계정 삭제 완료")
        } catch {
            print("계정 삭제 실패: \(error)")
        }

        @UserSetting(key: UDKey.isBasicAccountExist, defaultValue: false)
        var isBasicAccountExist
        isBasicAccountExist = false
        print("UserDefaults 상태 초기화 완료")
    }
}
