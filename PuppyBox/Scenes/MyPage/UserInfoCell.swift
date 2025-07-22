
import UIKit

import SnapKit
import Then

// 유저정보 셀
final class UserInfoCell: UICollectionViewCell {
    // MARK: - Properties

    static let identifier = String(describing: UserInfoCell.self)

    // MARK: - UI Components

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 50
    }

    private let nicknameLabel = UILabel().then {
        $0.font = .plusJakarta(size: 20, weight: .semibold)
        $0.textColor = .label
    }

    private let userIdLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .appPrimary
    }

    private let emailLabel = UILabel().then {
        $0.font = .plusJakarta(size: 14, weight: .regular)
        $0.textColor = .appPrimary
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        // 뷰에 주입
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(userIdLabel)
        contentView.addSubview(emailLabel)

        // 오토 레이아웃
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(27)
            $0.height.width.equalTo(100)
        }

        nicknameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
        }

        userIdLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(9)
            $0.height.equalTo(24)
        }
        emailLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userIdLabel.snp.bottom)
            $0.height.equalTo(24)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup Methods

    func configure(with userInfo: UserInfo) {
        nicknameLabel.text = userInfo.nickname
        profileImageView.image = UIImage(named: userInfo.profileImagePath)
        userIdLabel.text = "ID : \(userInfo.userId)"
        emailLabel.text = userInfo.email
    }
}
