//
//  MovieDetailInfoView.swift
//  PuppyBox
//
//  Created by 김우성 on 7/17/25.
//

import SnapKit
import Then
import UIKit

class MovieDetailInfoView: UIView {
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .heavy)
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.text = "나루토 VS 사스케"
    }
    
    private let adultIconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "18.circle.fill")
        $0.tintColor = .systemRed
        $0.isHidden = false
    }
    
    private let metaInfoLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.text = "2025.07.16 개봉 | 2시간 35분 | 액션, 애니메이션, 장르명"
    }
    
    private let metaDetailStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fillEqually
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private let overviewTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.text = "줄거리"
    }
    
    private let overviewLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.textAlignment = .natural
        $0.text = "미안하다 이거 보여주려고 어그로끌었다.. 나루토 사스케 싸움수준 ㄹㅇ실화냐? 진짜 세계관최강자들의 싸움이다.. 그찐따같던 나루토가 맞나? 진짜 나루토는 전설이다..진짜옛날에 맨날나루토봘는데 왕같은존재인 호카게 되서 세계최강 전설적인 영웅이된나루토보면 진짜내가다 감격스럽고 나루토 노래부터 명장면까지 가슴울리는장면들이 뇌리에 스치면서 가슴이 웅장해진다.. 그리고 극장판 에 카카시앞에 운석날라오는 거대한 걸 사스케가 갑자기 순식간에 나타나서 부숴버리곤 개간지나게 나루토가 없다면 마을을 지킬 자는 나밖에 없다 라며 바람처럼 사라진장면은 진짜 나루토처음부터 본사람이면 안울수가없더라 진짜 너무 감격스럽고 보루토를 최근에 알았는데 미안하다.. 지금20화보는데 진짜 나루토세대나와서 너무 감격스럽고 모두어엿하게 큰거보니 내가 다 뭔가 알수없는 추억이라해야되나 그런감정이 이상하게 얽혀있다.. 시노는 말이많아진거같다 좋은선생이고..그리고 보루토왜욕하냐 귀여운데 나루토를보는것같다 성격도 닮았어 그리고버루토에 나루토사스케 둘이싸워도 이기는 신같은존재 나온다는게 사실임?? 그리고인터닛에 쳐봣는디 이거 ㄹㅇㄹㅇ 진짜팩트냐?? 저적이 보루토에 나오는 신급괴물임?ㅡ 나루토사스케 합체한거봐라 진짜 ㅆㅂ 이거보고 개충격먹어가지고 와 소리 저절로 나오더라 ;; 진짜 저건 개오지는데.. 저게 ㄹㅇ이면 진짜 꼭봐야돼 진짜 세계도 파괴시키는거아니야 .. 와 진짜 나루토사스케가 저렇게 되다니 진짜 눈물나려고했다.. 버루토그라서 계속보는중인데 저거 ㄹㅇ이냐..? 하.. ㅆㅂ 사스케 보고싶다..  진짜언제 이렇게 신급 최강들이 되었을까 옛날생각나고 나 중딩때생각나고 뭔가 슬프기도하고 좋기도하고 감격도하고 여러가지감정이 복잡하네.. 아무튼 나루토는 진짜 애니중최거명작임.."
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        for item in [titleLabel, adultIconImageView, metaInfoLabel, metaDetailStackView, separatorView, overviewTitleLabel, overviewLabel] {
            addSubview(item)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().inset(20)
        }
        
        adultIconImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.width.height.equalTo(15)
        }
        
        metaInfoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        [
            setupMetaDetailContent(symbol: "globe", title: "언어", value: "일본어"),
            setupMetaDetailContent(symbol: "star.leadinghalf.filled", title: "평점", value: "7.3"),
            setupMetaDetailContent(symbol: "chart.line.uptrend.xyaxis", title: "인기도", value: "750.3586"),
            
        ].forEach { metaDetailStackView.addArrangedSubview($0) }
        
        metaDetailStackView.snp.makeConstraints {
            $0.top.equalTo(metaInfoLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(metaDetailStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        overviewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.top.equalTo(overviewTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    private func setupMetaDetailContent(symbol: String, title: String, value: String) -> UIStackView {
        let hStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .leading
        }
        
        let iconImageView = UIImageView().then {
            $0.image = UIImage(systemName: symbol)
            $0.tintColor = .white
        }
        
        let vStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 1
            $0.alignment = .leading
        }
        
        let titleLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 8, weight: .bold)
            $0.textColor = .systemGray2
            $0.numberOfLines = 1
            $0.textAlignment = .left
            $0.text = title
        }
        
        let valueLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 8, weight: .regular)
            $0.textColor = .white
            $0.numberOfLines = 1
            $0.textAlignment = .left
            $0.text = value
        }
        
        [titleLabel, valueLabel].forEach { vStackView.addArrangedSubview($0) }
        [iconImageView, vStackView].forEach { hStackView.addArrangedSubview($0) }
        
        return hStackView
    }
}
