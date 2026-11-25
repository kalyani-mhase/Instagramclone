import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var storyView: UIView!

    var storyName: String = "" {
        didSet {
            nameLabel.text = storyName
        }
    }

    private let nameLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: storyView.bottomAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 14)
        ])

        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        storyView.layer.cornerRadius = storyView.bounds.height / 2
        storyView.layer.borderWidth = 2
        img.layer.cornerRadius = img.bounds.height / 2
    }
}
