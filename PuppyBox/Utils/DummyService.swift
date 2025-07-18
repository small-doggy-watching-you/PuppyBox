
import Foundation

enum DummyService {
    // MARK: Methods

    // 최초 실행시 기본계정 생성
    static func createBasicAccount() {
        @UserSetting(key: UDKey.isBasicAccountExist, defaultValue: false)
        var isBasicAccountExist: Bool
        
        if !isBasicAccountExist { // key값이 false라면
            CoreDataManager.shared.createBasicAccount()
            isBasicAccountExist = true
        }
    }
}
