//
//  MovieDetailView.swift
//  PuppyBox
//
//  Created by 김우성 on 7/16/25.
//

import UIKit
import Then

class MovieDetailView: UIView {
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray5
    }
    
    private let overviewLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .lightText
        $0.numberOfLines = 0
    }
    

    override init(frame: CGRect) {
      super.init(frame: frame)
      configureUI()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
    }
}
