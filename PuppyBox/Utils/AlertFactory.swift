
import UIKit

enum AlertFactory {
    static func userIdNotPossibleAlert() -> UIAlertController {
        let alert = UIAlertController(title: "오류", message: "중복된 아이디 입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .destructive))
        return alert
    }
    
    static func userIdPossibleAlert() -> UIAlertController {
        let alert = UIAlertController(title: "확인", message: "사용 가능한 아이디입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        return alert
    }
    
    static func signUpNotPossible(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .destructive))
        return alert
    }
    
    static func signUpPossible(completion: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "확인", message: "회원 가입이 완료되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default){ _ in
            completion()
        })
        return alert
    }
    
    
    
}
