
import UIKit

import SnapKit
import Then

final class MyPageSectionHeaderView: UICollectionReusableView {
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .label
    }

    let moreButton = UIButton(configuration: .filled()).then {
        $0.tintColor = .systemBackground
        $0.configuration?.title = "더보기"
        $0.configuration?.baseForegroundColor = .systemGray2
        $0.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
