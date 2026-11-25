import UIKit

final class CommentsViewController: UIViewController {
    private var comments: [Comments]
    var onCommentsChanged: (([Comments]) -> Void)?

    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let composerView = UIView()
    private let commentField = UITextField()
    private let postButton = UIButton(type: .system)

    init(comments: [Comments]) {
        self.comments = comments
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        comments = []
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHeader()
        setupComposer()
        setupTableView()
        updateEmptyState()
    }

    private func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "Comments"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center

        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .label
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        [headerView, titleLabel, closeButton].forEach(view.addSubview)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 48),

            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            closeButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CommentRowCell.self, forCellReuseIdentifier: CommentRowCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: composerView.topAnchor)
        ])
    }

    private func setupComposer() {
        composerView.translatesAutoresizingMaskIntoConstraints = false
        commentField.translatesAutoresizingMaskIntoConstraints = false
        postButton.translatesAutoresizingMaskIntoConstraints = false

        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .separator

        commentField.borderStyle = .roundedRect
        commentField.placeholder = "Add a comment..."
        commentField.returnKeyType = .send
        commentField.addTarget(self, action: #selector(commentTextChanged), for: .editingChanged)
        commentField.delegate = self

        postButton.setTitle("Post", for: .normal)
        postButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        postButton.isEnabled = false
        postButton.addTarget(self, action: #selector(postTapped), for: .touchUpInside)

        [composerView, separator, commentField, postButton].forEach(view.addSubview)

        NSLayoutConstraint.activate([
            composerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            composerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            composerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            composerView.heightAnchor.constraint(equalToConstant: 60),

            separator.topAnchor.constraint(equalTo: composerView.topAnchor),
            separator.leadingAnchor.constraint(equalTo: composerView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: composerView.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5),

            commentField.leadingAnchor.constraint(equalTo: composerView.leadingAnchor, constant: 16),
            commentField.centerYAnchor.constraint(equalTo: composerView.centerYAnchor),
            commentField.trailingAnchor.constraint(equalTo: postButton.leadingAnchor, constant: -12),
            commentField.heightAnchor.constraint(equalToConstant: 38),

            postButton.trailingAnchor.constraint(equalTo: composerView.trailingAnchor, constant: -16),
            postButton.centerYAnchor.constraint(equalTo: composerView.centerYAnchor),
            postButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
    }

    private func updateEmptyState() {
        guard comments.isEmpty else {
            tableView.backgroundView = nil
            return
        }

        let label = UILabel()
        label.text = "No comments yet"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        tableView.backgroundView = label
    }

    private func saveComments() {
        onCommentsChanged?(comments)
        updateEmptyState()
    }

    private func toggleReaction(at indexPath: IndexPath) {
        guard comments.indices.contains(indexPath.row) else { return }

        comments[indexPath.row].isLiked.toggle()
        comments[indexPath.row].likeCount = max(
            0,
            comments[indexPath.row].likeCount + (comments[indexPath.row].isLiked ? 1 : -1)
        )
        saveComments()
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    private func canDeleteComment(at indexPath: IndexPath) -> Bool {
        guard comments.indices.contains(indexPath.row) else { return false }
        return DataSource.isCurrentUser(comments[indexPath.row].user_name)
    }

    private func deleteComment(at indexPath: IndexPath) {
        guard canDeleteComment(at: indexPath) else { return }

        comments.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveComments()
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func commentTextChanged() {
        postButton.isEnabled = !(commentField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    }

    @objc private func postTapped() {
        guard let text = commentField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            return
        }

        comments.append(Comments(user_name: DataSource.currentUserName, comment_msg: text))
        commentField.text = nil
        postButton.isEnabled = false
        saveComments()
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: comments.count - 1, section: 0), at: .bottom, animated: true)
    }
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        canDeleteComment(at: indexPath)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        deleteComment(at: indexPath)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentRowCell.reuseIdentifier,
            for: indexPath
        ) as? CommentRowCell else {
            return UITableViewCell()
        }

        cell.configure(
            with: comments[indexPath.row],
            onReact: { [weak self] in self?.toggleReaction(at: indexPath) },
            onDelete: { [weak self] in self?.deleteComment(at: indexPath) },
            canDelete: canDeleteComment(at: indexPath)
        )
        return cell
    }
}

extension CommentsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard canDeleteComment(at: indexPath) else { return nil }

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.deleteComment(at: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension CommentsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postTapped()
        return true
    }
}

private final class CommentRowCell: UITableViewCell {
    static let reuseIdentifier = "CommentRowCell"

    private let avatarView = UIImageView()
    private let usernameLabel = UILabel()
    private let messageLabel = UILabel()
    private let textStack = UIStackView()
    private let reactionButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)
    private var onReact: (() -> Void)?
    private var onDelete: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.image = UIImage(named: AppImages.person)
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 18

        usernameLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        usernameLabel.textColor = .label

        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = .label
        messageLabel.numberOfLines = 0

        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.spacing = 3
        textStack.addArrangedSubview(usernameLabel)
        textStack.addArrangedSubview(messageLabel)

        reactionButton.translatesAutoresizingMaskIntoConstraints = false
        reactionButton.tintColor = .secondaryLabel
        reactionButton.titleLabel?.font = .systemFont(ofSize: 11)
        reactionButton.addTarget(self, action: #selector(reactTapped), for: .touchUpInside)

        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .systemRed
        deleteButton.accessibilityLabel = "Delete comment"
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)

        [avatarView, textStack, reactionButton, deleteButton].forEach(contentView.addSubview)

        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            avatarView.widthAnchor.constraint(equalToConstant: 36),
            avatarView.heightAnchor.constraint(equalToConstant: 36),

            textStack.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: reactionButton.leadingAnchor, constant: -4),
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            reactionButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -2),
            reactionButton.centerYAnchor.constraint(equalTo: textStack.centerYAnchor),
            reactionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 36),
            reactionButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),

            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            deleteButton.centerYAnchor.constraint(equalTo: textStack.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 36),
            deleteButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    func configure(
        with comment: Comments,
        onReact: @escaping () -> Void,
        onDelete: @escaping () -> Void,
        canDelete: Bool
    ) {
        usernameLabel.text = comment.user_name.isEmpty ? "user" : comment.user_name
        messageLabel.text = comment.comment_msg
        self.onReact = onReact
        self.onDelete = onDelete
        deleteButton.isHidden = !canDelete

        let heartImage = comment.isLiked ? "heart.fill" : "heart"
        reactionButton.setImage(UIImage(systemName: heartImage), for: .normal)
        reactionButton.tintColor = comment.isLiked ? .systemRed : .secondaryLabel
        reactionButton.setTitle(comment.likeCount > 0 ? " \(comment.likeCount)" : nil, for: .normal)
        reactionButton.accessibilityLabel = comment.isLiked ? "Unlike comment" : "Like comment"
    }

    @objc private func reactTapped() {
        onReact?()
    }

    @objc private func deleteTapped() {
        onDelete?()
    }
}
