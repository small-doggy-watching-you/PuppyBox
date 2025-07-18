
import UIKit
import SnapKit

final class UserInfoCell: UICollectionViewCell {
    static let identifier = String(describing: UserInfoCell.self)
    
    private let nicknameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemOrange
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure(with userInfo: UserInfo) {
        contentView.addSubview(nicknameLabel)
        nicknameLabel.text = userInfo.nickname
        
        
        nicknameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
        }
    }
}
