
import UIKit

import SnapKit
import Then

final class UserInfoCell: UICollectionViewCell {
    static let identifier = String(describing: UserInfoCell.self)
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .label
    }
    
    private let userIdLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .appPrimary
    }
    
    private let emailLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .appPrimary
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with userInfo: UserInfo) {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(userIdLabel)
        contentView.addSubview(emailLabel)
        
        nicknameLabel.text = userInfo.nickname
        profileImageView.image = UIImage(named: userInfo.profileImagePath)
        userIdLabel.text = "ID : \(userInfo.userId)"
        emailLabel.text = userInfo.email
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
            $0.height.width.equalTo(100)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
        }
        
        userIdLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
        }
        
        emailLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userIdLabel.snp.bottom).offset(10)
        }
    }
}
