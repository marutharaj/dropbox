//
//  ContentsTableViewCell.swift
//  DropBox
//
//  Created by Marutharaj Kuppusamy on 3/14/19.
//

import UIKit

class ContentsTableViewCell: UITableViewCell {
    let contentImageView: UIImageView = {
        let contentImageView = UIImageView()
        contentImageView.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        contentImageView.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        contentImageView.clipsToBounds = true
        return contentImageView
    }()
    
    let contentTitleLabel: UILabel = {
        let contentTitleLabel = UILabel()
        contentTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentTitleLabel.textColor =  UIColor.black
        contentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return contentTitleLabel
    }()
    
    let contentDescriptionLabel: UILabel = {
        let contentDescriptionLabel = UILabel()
        contentDescriptionLabel.font = UIFont.boldSystemFont(ofSize: 14)
        contentDescriptionLabel.textColor =  UIColor.black
        contentDescriptionLabel.clipsToBounds = true
        contentDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentDescriptionLabel.numberOfLines = 0
        contentDescriptionLabel.lineBreakMode = .byWordWrapping
        return contentDescriptionLabel
    }()
    
    func addConstraint() {
            self.contentView.translatesAutoresizingMaskIntoConstraints = false
        contentImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        contentImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        contentImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        contentImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        contentImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        contentTitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        contentTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 68).isActive = true
        contentTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10).isActive = true
        contentTitleLabel.bottomAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 40).isActive = true
        contentTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        contentTitleLabel.widthAnchor.constraint(equalToConstant: self.contentView.frame.size.width - 10).isActive = true
        
        contentDescriptionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 30).isActive = true
        contentDescriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 68).isActive = true
        contentDescriptionLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        contentDescriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10).isActive = true
        contentDescriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10).isActive = true
        contentDescriptionLabel.widthAnchor.constraint(equalToConstant: self.contentView.frame.size.width - 10).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(contentImageView)
        self.contentView.addSubview(contentTitleLabel)
        self.contentView.addSubview(contentDescriptionLabel)
        addConstraint()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
