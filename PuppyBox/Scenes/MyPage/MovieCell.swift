
import UIKit

import Kingfisher
import SnapKit
import Then

final class MovieCell: UICollectionViewCell {
    static let identifier = String(describing: MovieCell.self)

    private let moviePosterView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    private let backgroundPosterView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .systemGray5
        $0.clipsToBounds = true
        $0.alpha = 0.4
    }

    private let movieNameLabel = UILabel().then {
        $0.font = .plusJakarta(size: 16, weight: .medium)
        $0.textColor = .label
    }

    private let dateLabel = UILabel().then {
        $0.font = .plusJakarta(size: 12, weight: .medium)
        $0.textColor = .appPrimary
    }

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
        
        stackView.addArrangedSubview(movieNameLabel)
        stackView.addArrangedSubview(dateLabel)
        
        contentView.addSubview(backgroundPosterView)
        contentView.addSubview(moviePosterView)
        contentView.addSubview(stackView)
        
        backgroundPosterView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(56)
        }
        
       
        moviePosterView.snp.makeConstraints {
            $0.directionalEdges.equalTo(backgroundPosterView)
        }

        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(moviePosterView.snp.trailing).offset(16)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: MyMovie) {

        movieNameLabel.text = movie.movieName
        dateLabel.text = movie.screeningDate
        // Kf downloadImage
        if let url = URL(string: movie.posterImagePath) {
            moviePosterView.kf.setImage(with: url)
            backgroundPosterView.kf.setImage(with: url)
        }

      

    }
}
