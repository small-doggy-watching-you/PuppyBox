
import UIKit

import SnapKit
import Then

final class LoginViewController: UIViewController {
    // MARK: - Properties

    private let logoOriginSize: CGFloat = 131 / 512 // 비율용 로고 원본 사이즈
    private let logoWidth: CGFloat = 150 // 로고 너비 설정상수
    let defaults = UserDefaults.standard // 유저 디폴트

    @UserSetting(key: UDKey.userId, defaultValue: "")
    var userId: String

    @UserSetting(key: UDKey.password, defaultValue: "")
    var password: String

    @UserSetting(key: UDKey.isLogined, defaultValue: false)
    var isLogined: Bool

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
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
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
        $0.autocapitalizationType = .none // 자동 대문자 변환 무시
        $0.autocorrectionType = .no // 자동 수정 무시
        $0.smartQuotesType = .no // 스마트 구두점 무시
        $0.textContentType = .username
    }

    // 비밀번호 글자 라벨
    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .label
    }

    // 비밀번호 입력 란
    private let passwordTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.isSecureTextEntry = true
        $0.placeholder = "비밀번호를 입력해주세요."
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.smartQuotesType = .no
        $0.textContentType = .password
    }

    // 비밀번호 잘못 입력시 출력할 라벨
    private let wrongPasswordLabel = UILabel().then {
        $0.text = "비밀번호를 잘못 입력했습니다."
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .red
        $0.isHidden = true
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
    private let signUpLabel = UILabel().then {
        $0.text = "회원가입"
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .secondaryLabel
        $0.isUserInteractionEnabled = true // 터치이벤트 받기 위한 속성
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

    // 스크롤뷰
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "로그인"

        configureUI() // UI 생성
        DummyService.createBasicAccount() // 더미생성 함수

        // 로그인 버튼액션
        loginButton.addAction(UIAction { [weak self] _ in
            guard let self,
                  let userId = self.idTextField.text,
                  let password = self.passwordTextField.text
            else { return }
            self.handleLogin(userId: userId, password: password)
        }, for: .touchUpInside)

        // 회원가입 라벨에 액션주입
        let tapSignUp = UITapGestureRecognizer(target: self, action: #selector(didTapSignUpLabel))
        signUpLabel.addGestureRecognizer(tapSignUp)

        let tapDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapDismissKeyboard)
    }

    override func viewDidAppear(_: Bool) {
        if isLogined { // 로그인한적이 있다면
            idTextField.text = userId
            passwordTextField.text = password
        }
    }

    private func configureUI() {
        // 뷰에 주입
        let itemList = [
            logoImage,
            loginLabel,
            idLabel,
            idTextField,
            passwordLabel,
            passwordTextField,
            wrongPasswordLabel,
            joinStackView,
            loginButton,
        ]

        for item in itemList {
            contentView.addSubview(item)
        }

        joinStackView.addArrangedSubview(alreadyAccountLabel)
        joinStackView.addArrangedSubview(deviderLabel)
        joinStackView.addArrangedSubview(signUpLabel)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // 오토 레이아웃 적용
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }

        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.height.equalTo(scrollView.safeAreaLayoutGuide).priority(.low)
        }

        contentView.snp.makeConstraints {
            $0.top.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(20) // 수직 스크롤으로 고정
            $0.width.equalTo(scrollView.contentLayoutGuide)
        }

        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
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
            $0.leading.equalToSuperview()
        }

        idTextField.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(25)
            $0.leading.equalToSuperview()
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        wrongPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(5)
            $0.left.equalToSuperview()
        }

        joinStackView.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
        }

        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(joinStackView.snp.bottom).offset(25).priority(249)
            $0.top.greaterThanOrEqualTo(joinStackView.snp.bottom).offset(25).priority(251)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
    }

    // 로그인 제어
    func handleLogin(userId: String, password: String) {
        // 패스워드가 만는지 파별
        let isLoginSuccess = CoreDataManager.shared.loginVerification(userId: userId, password: password)

        if isLoginSuccess { // 로그인 한 적이 있으면
            // 유저 디폴트 값 저장
            isLogined = true
            self.userId = userId
            self.password = password

            // 페이지 이동
            let movieListVC = MovieListViewController()
            movieListVC.modalPresentationStyle = .fullScreen
            present(movieListVC, animated: true)

        } else {
            // "비밀번호를 잘못 입력했습니다"의 히든 해제
            wrongPasswordLabel.isHidden = false
        }
    }

    // 회원가입 라벨 탭할 경우 화면 이동
    @objc
    private func didTapSignUpLabel() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }

    // 키보드 내리는 액션
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}
