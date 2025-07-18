
import UIKit

import SnapKit
import Then

@available(iOS 17.0, *)
#Preview {
    SignUpViewController() // 자기가 볼 뷰컨트롤러로
}

final class SignUpViewController: UIViewController {
    // MARK: - Properties

    private let logoOriginSize: CGFloat = 131 / 512 // 비율용 로고 원본 사이즈
    private let logoWidth: CGFloat = 100 // 로고 너비 설정상수
    private var isCheckDuplicaiton: Bool = false

    // MARK: - UI Components

    // 로고 이미지
    private let logoImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "PuppyBoxLabel")
    }

    // 회원가입 글자 라벨
    private let signUpTextLabel = UILabel().then {
        $0.text = "회원가입"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
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
        $0.placeholder = "아이디"
        $0.autocapitalizationType = .none // 자동 대문자 변환 무시
        $0.autocorrectionType = .no // 자동 수정 무시
        $0.smartQuotesType = .no // 스마트 구두점 무시
        $0.textContentType = .username
    }

    // 중복확인 버튼
    private let checkDuplicationButton = UIButton().then {
        $0.setTitle("중복 확인", for: .normal)
        $0.isEnabled = false
        $0.setTitleColor(.systemGray3, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .systemGray6
    }

    // 닉네임 글자 라벨
    private let nickNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .label
    }

    // 닉네임 입력란
    private let nickNameTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "닉네임"
        $0.autocapitalizationType = .none // 자동 대문자 변환 무시
        $0.autocorrectionType = .no // 자동 수정 무시
        $0.smartQuotesType = .no // 스마트 구두점 무시
        $0.textContentType = .nickname
    }

    // 비밀번호 글자 라벨
    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .label
    }

    // 비밀번호 입력란
    private let passwordTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.isSecureTextEntry = true
        $0.placeholder = "비밀번호"
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.smartQuotesType = .no
        $0.textContentType = .newPassword
    }

    // 비밀번호 확인란
    private let passwordConfirmTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.isSecureTextEntry = true
        $0.placeholder = "비밀번호 확인"
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.smartQuotesType = .no
        $0.textContentType = .newPassword
    }

    // 이메일 주소 글자 라벨
    private let emailLabel = UILabel().then {
        $0.text = "이메일 주소"
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .label
    }

    // 닉네임 입력란
    private let emailTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "이메일 주소"
        $0.autocapitalizationType = .none // 자동 대문자 변환 무시
        $0.autocorrectionType = .no // 자동 수정 무시
        $0.smartQuotesType = .no // 스마트 구두점 무시
        $0.textContentType = .emailAddress
    }

    // 휴대폰 번호 글자 라벨
    private let phoneNumberLabel = UILabel().then {
        $0.text = "휴대폰 번호"
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .label
    }

    // 휴대폰 번호 입력란
    private let phoneNumberTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "휴대폰 번호"
        $0.autocapitalizationType = .none // 자동 대문자 변환 무시
        $0.autocorrectionType = .no // 자동 수정 무시
        $0.smartQuotesType = .no // 스마트 구두점 무시
        $0.textContentType = .telephoneNumber
    }

    // 회원가입 버튼
    private let signUpButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.setTitleColor(.systemBackground, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .appPrimary
    }

    // 스크롤뷰
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .appPrimary

        configureUI()

        // 아이디 입력란 감지액션 추가
        idTextField.addTarget(self, action: #selector(idTextFieldDidChange(_:)), for: .editingChanged)

        // 중복확인 버튼액션
        checkDuplicationButton.addAction(UIAction { [weak self] _ in
            guard let self,
                  let userId = self.idTextField.text
            else { return }

            let chk = CoreDataManager.shared.userIdVerfication(userId: userId)

            if chk { // 생성 가능한 Id일 경우
                let alert = AlertFactory.userIdPossibleAlert()
                present(alert, animated: true)
                isCheckDuplicaiton = true
                idTextField.isEnabled = false
            } else {
                let alert = AlertFactory.userIdNotPossibleAlert()
                present(alert, animated: true)
            }

        }, for: .touchUpInside)

        // 가입하기 버튼액션
        signUpButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            if checkValidaiton() { // 가능한 아이디일 경우 유저 등록
                CoreDataManager.shared.createUser(
                    userId: idTextField.text ?? "",
                    name: nickNameTextField.text ?? "",
                    password: passwordTextField.text ?? "",
                    email: emailTextField.text,
                    phone: phoneNumberTextField.text
                )
            }
        }, for: .touchUpInside)
    }

    // 로그인화면 키보드 레이아웃 버그 해결용
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    // 화면 진입시 첫 텍스트필드에 포커스
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        idTextField.becomeFirstResponder()
    }

    private func configureUI() {
        let itemList = [
            logoImage,
            signUpTextLabel,
            idLabel,
            idTextField,
            checkDuplicationButton,
            nickNameLabel,
            nickNameTextField,
            passwordLabel,
            passwordTextField,
            passwordConfirmTextField,
            emailLabel,
            emailTextField,
            phoneNumberLabel,
            phoneNumberTextField,
            signUpButton,
        ]

        for item in itemList {
            contentView.addSubview(item)
        }

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

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
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(logoWidth)
            $0.height.equalTo(logoWidth * logoOriginSize) // 비율 계산
        }

        signUpTextLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }

        idLabel.snp.makeConstraints {
            $0.top.equalTo(signUpTextLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview()
        }

        idTextField.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(10)
            $0.leading.equalTo(idLabel)
            $0.trailing.equalTo(checkDuplicationButton.snp.leading).offset(-20)
            $0.height.equalTo(40)
        }

        checkDuplicationButton.snp.makeConstraints {
            $0.top.equalTo(idTextField)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }

        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(25)
            $0.leading.equalTo(idLabel)
        }

        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            $0.leading.equalTo(idLabel)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(25)
            $0.leading.equalTo(idLabel)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(10)
            $0.leading.equalTo(idLabel)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        passwordConfirmTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(10)
            $0.leading.equalTo(idLabel)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        emailLabel.snp.makeConstraints {
            $0.top.equalTo(passwordConfirmTextField.snp.bottom).offset(25)
            $0.leading.equalTo(idLabel)
        }

        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(10)
            $0.leading.equalTo(idLabel)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        phoneNumberLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(25)
            $0.leading.equalTo(idLabel)
        }

        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(phoneNumberLabel.snp.bottom).offset(10)
            $0.leading.equalTo(idLabel)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        signUpButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(phoneNumberTextField.snp.bottom).offset(25).priority(249)
            $0.top.greaterThanOrEqualTo(phoneNumberTextField.snp.bottom).offset(25)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
    }

    // 텍스트 필드가 채워지면 버튼 활성화
    @objc
    private func idTextFieldDidChange(_: UITextField) {
        let input = idTextField.text ?? ""
        let inputtext = input.trimmingCharacters(in: .whitespacesAndNewlines)

        if input != inputtext { // 좌우에 공백이 들어오면 비활성화
            checkButtonDisable()
            return
        }

        if input.isEmpty { // 비어있으면 버튼 비활성화
            checkButtonDisable()
        } else { // 셀에 내용이 있으면 버튼 활성화
            checkButtonEnable()
        }
    }

    // 중복 확인 버튼 활성화
    private func checkButtonEnable() {
        checkDuplicationButton.isEnabled = true
        checkDuplicationButton.setTitleColor(.systemBackground, for: .normal)
        checkDuplicationButton.backgroundColor = .appPrimary
    }

    // 중복 확인 버튼 비활성화
    private func checkButtonDisable() {
        checkDuplicationButton.isEnabled = false
        checkDuplicationButton.setTitleColor(.systemGray3, for: .normal)
        checkDuplicationButton.backgroundColor = .systemGray6
    }

    // 유효성 검사
    private func checkValidaiton() -> Bool {
        var flg = true
        var errorMsgBox: [String] = []

        if !isCheckDuplicaiton { // 중복 확인을 눌렀는지
            flg = false
            errorMsgBox.append("아이디 중복 확인을 해주세요.")
        }

        if let nickNameTextField = nickNameTextField.text,
           nickNameTextField.isEmpty
        { // 닉네임을 채웠는지
            flg = false
            errorMsgBox.append("닉네임을 입력해주세요")
        }

        if let passwordTextField = passwordTextField.text,
           let passwordConfirmTextField = passwordConfirmTextField.text
        { // 패스워드 칸을 채웠는지
            if passwordTextField.isEmpty {
                flg = false
                errorMsgBox.append("비밀번호를 입력해주세요")
            }
            if passwordTextField != passwordConfirmTextField { // 일치한지
                flg = false
                errorMsgBox.append("비밀번호가 일치하지 않습니다")
            }
        }

        if flg { // 가능할경우 회원가입 완료 Alert 띄우고 팝
            let alert = AlertFactory.signUpPossible { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            present(alert, animated: true)
            return true
        } else { // 실패시 확인 메시지를 띄우고 추가
            let message = errorMsgBox.joined(separator: "\n")
            let alert = AlertFactory.signUpNotPossible(message: message)
            present(alert, animated: true)
            return false
        }
    }
}
