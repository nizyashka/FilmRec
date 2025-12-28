import UIKit

final class LockedOptionsTabCell: UITableViewCell {
    lazy var optionsTabNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var pickedOptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    static let reuseIdentifier = "lockedOptionsTabCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(optionsTabNameLabel)
        contentView.addSubview(pickedOptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            optionsTabNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionsTabNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
           
            pickedOptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            pickedOptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
