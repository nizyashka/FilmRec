import UIKit

final class RequestCell: UITableViewCell {
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    static let reuseIdentifier = "RequestCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    private func setupUI() {
        configureCell()
        
        contentView.addSubview(nameLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func configureCell() {
        contentView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.63)
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
    }
}
