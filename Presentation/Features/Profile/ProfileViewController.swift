import UIKit

final class ProfileViewController: UIViewController {
    private let user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("ProfileViewController is created in code")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = user.name ?? "Profile"
        navigationItem.largeTitleDisplayMode = .never
        buildProfile()
    }

    private func buildProfile() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let content = UIStackView()
        content.axis = .vertical
        content.spacing = 20
        content.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(content)

        let summary = UIStackView()
        summary.axis = .horizontal
        summary.alignment = .center
        summary.distribution = .equalSpacing

        let avatar = UIImageView(image: UIImage(named: user.storyData.first?.image ?? AppImages.person))
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 42
        avatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 84),
            avatar.heightAnchor.constraint(equalToConstant: 84)
        ])
        summary.addArrangedSubview(avatar)

        let stats = UIStackView(arrangedSubviews: [
            makeStat(value: "0", title: "posts"),
            makeStat(value: "0", title: "followers"),
            makeStat(value: "0", title: "following")
        ])
        stats.axis = .horizontal
        stats.spacing = 22
        summary.addArrangedSubview(stats)
        content.addArrangedSubview(summary)

        let details = UIStackView()
        details.axis = .vertical
        details.spacing = 4
        let nameLabel = UILabel()
        nameLabel.text = user.name ?? "Kalyani"
        nameLabel.font = .boldSystemFont(ofSize: 15)
        details.addArrangedSubview(nameLabel)
        if let address = user.address, !address.isEmpty {
            let addressLabel = UILabel()
            addressLabel.text = address
            addressLabel.font = .systemFont(ofSize: 14)
            details.addArrangedSubview(addressLabel)
        }
        if let phone = user.mob_number, !phone.isEmpty {
            let phoneLabel = UILabel()
            phoneLabel.text = phone
            phoneLabel.font = .systemFont(ofSize: 14)
            phoneLabel.textColor = .secondaryLabel
            details.addArrangedSubview(phoneLabel)
        }
        content.addArrangedSubview(details)

        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit profile", for: .normal)
        editButton.setTitleColor(.label, for: .normal)
        editButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        editButton.backgroundColor = .secondarySystemBackground
        editButton.layer.cornerRadius = 7
        editButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        content.addArrangedSubview(editButton)

        let divider = UIView()
        divider.backgroundColor = .separator
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        content.addArrangedSubview(divider)

        let emptyState = UIStackView()
        emptyState.axis = .vertical
        emptyState.alignment = .center
        emptyState.spacing = 8
        let camera = UIImageView(image: UIImage(systemName: "camera"))
        camera.tintColor = .label
        camera.contentMode = .scaleAspectFit
        camera.heightAnchor.constraint(equalToConstant: 38).isActive = true
        camera.widthAnchor.constraint(equalToConstant: 38).isActive = true
        let emptyTitle = UILabel()
        emptyTitle.text = "No posts yet"
        emptyTitle.font = .boldSystemFont(ofSize: 18)
        emptyState.addArrangedSubview(camera)
        emptyState.addArrangedSubview(emptyTitle)
        content.addArrangedSubview(emptyState)
        emptyState.heightAnchor.constraint(equalToConstant: 150).isActive = true

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 18),
            content.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func makeStat(value: String, title: String) -> UIStackView {
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .boldSystemFont(ofSize: 17)
        valueLabel.textAlignment = .center
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.textAlignment = .center
        let stack = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        stack.axis = .vertical
        stack.spacing = 3
        return stack
    }
}
