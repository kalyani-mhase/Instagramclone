import UIKit

final class TopNavigationBar: UIView {
    let topHeader = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private let messageButton = UIButton(type: .system)

    var onFavoriteTap: (() -> Void)?
    var onMessageTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .systemBackground

        topHeader.textColor = .label
        topHeader.font = .systemFont(ofSize: 26, weight: .bold)
        topHeader.textAlignment = .left
        topHeader.setContentCompressionResistancePriority(.required, for: .horizontal)

        configure(favoriteButton, symbol: "heart")
        configure(messageButton, symbol: "paperplane")

        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        messageButton.addTarget(self, action: #selector(messageTapped), for: .touchUpInside)

        [topHeader, favoriteButton, messageButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            topHeader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            topHeader.centerYAnchor.constraint(equalTo: centerYAnchor),

            messageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            messageButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageButton.widthAnchor.constraint(equalToConstant: 44),
            messageButton.heightAnchor.constraint(equalToConstant: 44),

            favoriteButton.trailingAnchor.constraint(equalTo: messageButton.leadingAnchor, constant: -4),
            favoriteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func configure(_ button: UIButton, symbol: String) {
        button.setImage(UIImage(systemName: symbol), for: .normal)
        button.setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: 21, weight: .regular),
            forImageIn: .normal
        )
        button.tintColor = .label
    }

    @objc private func favoriteTapped() {
        onFavoriteTap?()
    }

    @objc private func messageTapped() {
        onMessageTap?()
    }
}
