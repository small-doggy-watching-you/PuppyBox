
import UIKit

import SnapKit
import Then

final class MovieCell: UICollectionViewCell {
    static let identifier = String(describing: MovieCell.self)
    
    private let moviePosterView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let movieNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.textColor = .label
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .appPrimary
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBrown
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movie: MyMovie){
        
        stackView.addArrangedSubview(movieNameLabel)
        stackView.addArrangedSubview(dateLabel)
        
        contentView.addSubview(moviePosterView)
        contentView.addSubview(stackView)
        
        movieNameLabel.text = movie.movieName
        dateLabel.text = movie.screeningDate
        
        moviePosterView.snp.makeConstraints {
            $0.top.bottom.leading.edges.equalToSuperview()
            $0.width.equalTo(92)
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(moviePosterView).offset(20)
        }
        
    }
}
