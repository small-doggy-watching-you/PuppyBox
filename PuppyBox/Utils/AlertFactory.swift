
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
    
    static func paymentConfirmAlert(totalPrice: Int, completion: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(
            title: "결제 확인",
            message: "총 \(totalPrice)원을 결제하시겠습니까?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "승인", style: .default) { _ in
            completion()
        })
        return alert
    }
    
    static func duplicateReservationAlert(completion: (() -> Void)? = nil) -> UIAlertController {
            let alert = UIAlertController(
                title: "이미 예약됨",
                message: "해당 상영에 대한 예약이 이미 존재합니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                completion?()
            })
            return alert
        }
}
