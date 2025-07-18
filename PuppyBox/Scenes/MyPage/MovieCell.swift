
import UIKit
import SnapKit

final class MovieCell: UICollectionViewCell {
    static let identifier = String(describing: MovieCell.self)
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBrown
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        
    }
}
