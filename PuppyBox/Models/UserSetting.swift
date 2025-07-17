
import Foundation

// UserDefault의 다른 값을 하나로 관리하기 위해 @propertyWrapper 사용
@propertyWrapper
struct UserDefault<T> { // Wrapper로 쌀 내용
    let key: String
    let defaultValue: T
    let userDefaults: UserDefaults

    init(key: String, defaultValue: T, userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get { // 유저디폴트 값 획득
            userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set { // 유저디폴트 값 할당
            userDefaults.set(newValue, forKey: key)
        }
    }
}

// 유저 디폴트 키값을 String 형태로 저장
enum UDKey {
    static let isBasicAccountExist = "isBasicAccountExist" // 첫 로그인 판별
    static let userId = "userId" // 유저 아이디
    static let password = "password" // 유저 패스워드
    static let isLogined = "isLogined" // 로그인 했었는지 여부
}

/*
 UserDefault 사용할 때 쓸 변수
 사용법
 get : UserSetting.userID
 set : UserSEtting.userId = "userId"
 */
enum UserSetting {
    @UserDefault(key: UDKey.isBasicAccountExist, defaultValue: false)
    static var isBasicAccountExist: Bool

    @UserDefault(key: UDKey.userId, defaultValue: "")
    static var userId: String

    @UserDefault(key: UDKey.password, defaultValue: "")
    static var password: String

    @UserDefault(key: UDKey.isLogined, defaultValue: false)
    static var isLogined: Bool
}
