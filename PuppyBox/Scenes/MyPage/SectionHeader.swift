
import UIKit

import SnapKit
import Then

final class MyPageSectionHeaderView: UICollectionReusableView {
    let titleLabel = UILabel().then {
        $0.font = .plusJakarta(size: 22, weight: .bold)
        $0.textColor = .label
    }
    
    let moreButton = UIButton(configuration: .plain()).then {
        $0.configuration?.title = "더보기"
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 8, weight: .bold)
        $0.configuration?.image = UIImage(systemName: "chevron.forward", withConfiguration: symbolConfig)
        $0.configuration?.imagePadding = 4  // 텍스트와 아이콘 간 간격
        $0.semanticContentAttribute = .forceRightToLeft
        $0.configuration?.baseForegroundColor = UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1.0)
        $0.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .plusJakarta(size: 12, weight: .bold)
            return outgoing
        }
    }

    var onTapMoreButton: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        addSubview(moreButton)

        moreButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.onTapMoreButton?()
        }, for: .touchUpInside)

        titleLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }

        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
