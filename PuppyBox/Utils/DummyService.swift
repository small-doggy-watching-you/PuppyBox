
import Foundation

enum DummyService {
    // MARK: Methods

    // 최초 실행시 기본계정 생성
    static func createBasicAccount() {
        if !UserSetting.isBasicAccountExist { // key값이 false라면
            CoreDataManager.shared.createBasicAccount()
            UserSetting.isBasicAccountExist = true
        }
    }
}
