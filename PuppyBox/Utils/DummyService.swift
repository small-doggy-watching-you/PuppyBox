
import Foundation

enum DummyService {
    
    // MARK: Methods
    // 최초 실행시 기본계정 생성
    static func createBasicAccount() {
        let key = "isBasicAccountExist"
        let defaults = UserDefaults.standard
        
        if !defaults.bool(forKey: key) { // key값이 false라면
            CoreDataManager.shared.createBasicAccount()
            defaults.set(true, forKey: key)
        }
    }
}
