
import UIKit
import SnapKit

final class SectionHeaderView: UICollectionReusableView {
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .label
    }

    private let moreButton = UIButton(configuration: .filled()).then {
        $0.setTitleColor(.systemGray3, for: .normal)
        $0.tintColor = .systemBackground
        $0.configuration?.title = "더보기"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
    
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
