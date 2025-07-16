
import UIKit

import SnapKit
import Then

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private let logoOriginSize:CGFloat = 131 / 512 // 로고 원본 사이즈
    private let logoWidth:CGFloat = 200
    
    // MARK: - UI Components
    private let logoImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "PuppyBoxLogo")
    }
    
    private let loginLabel = UILabel().then {
        $0.text = "로그인"
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = .label
    }
    
    private let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .label
    }
    
    private let idTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "아이디를 입력해주세요."
    }
    
    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .label
    }
    
    private let passwordLabelTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.isSecureTextEntry = true 
        $0.placeholder = "비밀번호를 입력해주세요."
    }
    
    private let wrongPasswordLabel = UILabel().then {
        $0.text = "비밀번호를 잘못 입력했습니다."
        $0.font = .systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .red
    }
    
    private let alreadyAccountLabel = UILabel().then {
        $0.text = "아직 회원가입을 안하셨나요?"
        $0.font = .systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .secondaryLabel
    }
    
    private let joinLabel = UILabel().then {
        $0.text = "회원가입"
        $0.font = .systemFont(ofSize: 10, weight: .bold)
        $0.textColor = .secondaryLabel
    }
    
    private let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.systemBackground, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .appPrimary
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoImage)
        view.addSubview(loginLabel)
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(logoWidth)
            $0.height.equalTo(logoWidth * logoOriginSize) // 비율 계산
        }
        
        loginLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }

    
}


