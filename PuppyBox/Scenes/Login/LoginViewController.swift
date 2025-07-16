
import UIKit

import SnapKit
import Then

final class LoginViewController: UIViewController {
    // MARK: - Properties

    private let logoOriginSize: CGFloat = 131 / 512 // 비율용 로고 원본 사이즈
    private let logoWidth: CGFloat = 150 // 로고 너비 설정상수

    // MARK: - UI Components

    // 로고 이미지
    private let logoImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "PuppyBoxLabel")
    }

    // 로그인 글자 라벨 (이미지 하단)
    private let loginLabel = UILabel().then {
        $0.text = "로그인"
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = .label
    }

    // 아이디 글자 라벨
    private let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .label
    }

    // 아이디 입력란
    private let idTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "아이디를 입력해주세요."
    }

    // 비밀번호 글자 라벨
    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .label
    }

    // 비밀번호 입력 란
    private let passwordLabelTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.isSecureTextEntry = true
        $0.placeholder = "비밀번호를 입력해주세요."
    }

    // 비밀번호 잘못 입력시 출력할 라벨
    private let wrongPasswordLabel = UILabel().then {
        $0.text = "비밀번호를 잘못 입력했습니다."
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .red
    }

    // 회원가입 글자 좌측
    private let alreadyAccountLabel = UILabel().then {
        $0.text = "아직 회원가입을 안하셨나요?"
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .secondaryLabel
    }

    // 회원가입 글자 |
    private let deviderLabel = UILabel().then {
        $0.text = "|"
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .secondaryLabel
    }

    // 회원가입 글자 우측
    private let joinLabel = UILabel().then {
        $0.text = "회원가입"
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .secondaryLabel
    }

    // 로그인 버튼
    private let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.systemBackground, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .appPrimary
    }

    // 아직 회원가입을 안하셨나요? | 회원가입 담을 스택뷰
    private let joinStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
    }

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureUI() // UI 생성
        DummyService.createBasicAccount() // 더미생성 함수
    }

    private func configureUI() {
        // 뷰에 주입
        let itemList = [
            logoImage,
            loginLabel,
            idLabel,
            idTextField,
            passwordLabel,
            passwordLabelTextField,
            wrongPasswordLabel,
            joinStackView,
            loginButton,
        ]

        for item in itemList {
            view.addSubview(item)
        }

        joinStackView.addArrangedSubview(alreadyAccountLabel)
        joinStackView.addArrangedSubview(deviderLabel)
        joinStackView.addArrangedSubview(joinLabel)

        // 오토 레이아웃 적용
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

        idLabel.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(50)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        idTextField.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(10)
            $0.leading.equalTo(idLabel)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }

        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(25)
            $0.leading.equalTo(idLabel)
        }

        passwordLabelTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(10)
            $0.leading.equalTo(idLabel)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }

        wrongPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(passwordLabelTextField.snp.bottom).offset(5)
            $0.left.equalTo(idLabel)
        }

        joinStackView.snp.makeConstraints {
            $0.top.equalTo(passwordLabelTextField.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
        }

        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(50)
        }
    }
}
