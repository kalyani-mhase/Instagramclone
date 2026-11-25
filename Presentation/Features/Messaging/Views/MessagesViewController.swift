import UIKit

final class MessagesViewController: UIViewController {
    private let viewModel: MessagesViewModel
    private let makeConversationViewModel: (MessageConversation) -> ConversationViewModel
    private let searchField = UITextField()
    private let notesScrollView = UIScrollView()
    private let notesStack = UIStackView()
    private let sectionHeader = UIView()
    private let requestsButton = UIButton(type: .system)
    private let tableView = UITableView(frame: .zero, style: .plain)

    init(
        viewModel: MessagesViewModel,
        makeConversationViewModel: @escaping (MessageConversation) -> ConversationViewModel
    ) {
        self.viewModel = viewModel
        self.makeConversationViewModel = makeConversationViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.overrideUserInterfaceStyle = .dark
        title = "kalyanimhase1"
        view.backgroundColor = .black
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        navigationItem.leftBarButtonItem?.accessibilityLabel = "Back"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "video"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(
                image: UIImage(systemName: "square.and.pencil"),
                style: .plain,
                target: self,
                action: #selector(newMessageTapped)
            )
        ]
        navigationItem.rightBarButtonItem?.accessibilityLabel = "New message"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white

        setupSearch()
        setupNotes()
        setupSectionHeader()
        setupTable()
    }

    private func setupSearch() {
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = "Search"
        searchField.borderStyle = .roundedRect
        searchField.backgroundColor = UIColor(white: 0.14, alpha: 1)
        searchField.textColor = .white
        searchField.tintColor = .white
        searchField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .lightGray
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.frame = CGRect(x: 0, y: 0, width: 34, height: 18)
        searchField.leftView = searchIcon
        searchField.leftViewMode = .always
        searchField.clearButtonMode = .whileEditing
        searchField.returnKeyType = .search
        searchField.addTarget(self, action: #selector(searchChanged), for: .editingChanged)
        view.addSubview(searchField)

        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupNotes() {
        notesScrollView.translatesAutoresizingMaskIntoConstraints = false
        notesScrollView.showsHorizontalScrollIndicator = false
        notesStack.translatesAutoresizingMaskIntoConstraints = false
        notesStack.axis = .horizontal
        notesStack.spacing = 18
        notesScrollView.addSubview(notesStack)
        view.addSubview(notesScrollView)

        let noteItems = ["Your note", "Shruti", "Nidhi", "Pankaj", "Swati", "Shreya"]
        for (index, name) in noteItems.enumerated() {
            let note = NoteAvatarView()
            note.configure(name: name, isOwnNote: index == 0)
            notesStack.addArrangedSubview(note)
        }

        NSLayoutConstraint.activate([
            notesScrollView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 12),
            notesScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notesScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notesScrollView.heightAnchor.constraint(equalToConstant: 108),

            notesStack.leadingAnchor.constraint(equalTo: notesScrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            notesStack.trailingAnchor.constraint(equalTo: notesScrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            notesStack.topAnchor.constraint(equalTo: notesScrollView.contentLayoutGuide.topAnchor),
            notesStack.bottomAnchor.constraint(equalTo: notesScrollView.contentLayoutGuide.bottomAnchor),
            notesStack.heightAnchor.constraint(equalTo: notesScrollView.frameLayoutGuide.heightAnchor)
        ])
    }

    private func setupSectionHeader() {
        sectionHeader.translatesAutoresizingMaskIntoConstraints = false
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Messages"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .white

        requestsButton.translatesAutoresizingMaskIntoConstraints = false
        requestsButton.setTitle("Requests", for: .normal)
        requestsButton.setTitleColor(.systemBlue, for: .normal)
        requestsButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        requestsButton.addTarget(self, action: #selector(requestsTapped), for: .touchUpInside)

        [titleLabel, requestsButton].forEach(sectionHeader.addSubview)
        view.addSubview(sectionHeader)
        NSLayoutConstraint.activate([
            sectionHeader.topAnchor.constraint(equalTo: notesScrollView.bottomAnchor, constant: 2),
            sectionHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sectionHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sectionHeader.heightAnchor.constraint(equalToConstant: 32),

            titleLabel.leadingAnchor.constraint(equalTo: sectionHeader.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: sectionHeader.centerYAnchor),

            requestsButton.trailingAnchor.constraint(equalTo: sectionHeader.trailingAnchor),
            requestsButton.centerYAnchor.constraint(equalTo: sectionHeader.centerYAnchor)
        ])
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MessagePreviewCell.self, forCellReuseIdentifier: MessagePreviewCell.reuseIdentifier)
        tableView.rowHeight = 68
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.keyboardDismissMode = .onDrag
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: sectionHeader.bottomAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func searchChanged() {
        tableView.reloadData()
    }

    @objc private func requestsTapped() {
        let alert = UIAlertController(title: "Requests", message: "You’re all caught up.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default))
        present(alert, animated: true)
    }

    @objc private func newMessageTapped() {
        let alert = UIAlertController(
            title: "New message",
            message: "Choose a conversation to start.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private var filteredConversations: [MessageConversation] {
        viewModel.conversations(matching: searchField.text ?? "")
    }
}

extension MessagesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredConversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MessagePreviewCell.reuseIdentifier,
            for: indexPath
        ) as! MessagePreviewCell
        cell.configure(with: filteredConversations[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = filteredConversations[indexPath.row]
        let conversationViewModel = makeConversationViewModel(selected)
        let conversation = ConversationViewController(viewModel: conversationViewModel)
        navigationController?.pushViewController(conversation, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private final class NoteAvatarView: UIView {
    private let avatar = UIImageView()
    private let noteBubble = UILabel()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.image = UIImage(named: AppImages.person)
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 28
        avatar.layer.borderWidth = 2
        avatar.layer.borderColor = UIColor(white: 0.3, alpha: 1).cgColor

        noteBubble.translatesAutoresizingMaskIntoConstraints = false
        noteBubble.text = "Note..."
        noteBubble.font = .systemFont(ofSize: 11)
        noteBubble.textColor = .white
        noteBubble.textAlignment = .center
        noteBubble.backgroundColor = UIColor(white: 0.18, alpha: 1)
        noteBubble.layer.cornerRadius = 12
        noteBubble.clipsToBounds = true

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 11)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.lineBreakMode = .byTruncatingTail

        [avatar, noteBubble, nameLabel].forEach(addSubview)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 58),
            heightAnchor.constraint(equalToConstant: 100),
            avatar.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            avatar.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 56),
            avatar.heightAnchor.constraint(equalToConstant: 56),
            noteBubble.leadingAnchor.constraint(equalTo: leadingAnchor),
            noteBubble.topAnchor.constraint(equalTo: topAnchor),
            noteBubble.widthAnchor.constraint(equalToConstant: 48),
            noteBubble.heightAnchor.constraint(equalToConstant: 28),
            nameLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configure(name: String, isOwnNote: Bool) {
        nameLabel.text = name
        noteBubble.isHidden = !isOwnNote
    }
}

private final class MessagePreviewCell: UITableViewCell {
    static let reuseIdentifier = "MessagePreviewCell"

    private let avatar = UIImageView()
    private let nameLabel = UILabel()
    private let previewLabel = UILabel()
    private let timeLabel = UILabel()
    private let unreadDot = UIView()
    private let cameraView = UIImageView(image: UIImage(systemName: "camera"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        selectionStyle = .none
        backgroundColor = .black
        contentView.backgroundColor = .black
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.image = UIImage(named: AppImages.person)
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 27

        nameLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        nameLabel.textColor = .white
        previewLabel.font = .systemFont(ofSize: 12)
        previewLabel.textColor = UIColor(white: 0.65, alpha: 1)
        previewLabel.lineBreakMode = .byTruncatingTail
        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.textColor = UIColor(white: 0.65, alpha: 1)
        cameraView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        cameraView.tintColor = UIColor(white: 0.75, alpha: 1)
        cameraView.contentMode = .scaleAspectFit
        accessoryView = cameraView
        unreadDot.backgroundColor = .systemBlue
        unreadDot.layer.cornerRadius = 4

        let textStack = UIStackView(arrangedSubviews: [nameLabel, previewLabel])
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.spacing = 5

        [avatar, textStack, timeLabel, unreadDot].forEach(contentView.addSubview)
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 54),
            avatar.heightAnchor.constraint(equalToConstant: 54),

            textStack.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -8),

            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),

            unreadDot.widthAnchor.constraint(equalToConstant: 8),
            unreadDot.heightAnchor.constraint(equalToConstant: 8),
            unreadDot.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: -2),
            unreadDot.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8)
        ])
    }

    func configure(with conversation: MessageConversation) {
        nameLabel.text = conversation.username
        previewLabel.text = conversation.latestMessage
        timeLabel.text = Self.relativeTime(for: conversation.lastUpdated)
        unreadDot.isHidden = conversation.unreadCount == 0
        nameLabel.font = .systemFont(
            ofSize: 14,
            weight: conversation.unreadCount > 0 ? .semibold : .regular
        )
    }

    private static func relativeTime(for date: Date) -> String {
        let seconds = max(0, Int(Date().timeIntervalSince(date)))
        if seconds < 60 { return "\(seconds)s" }
        if seconds < 3_600 { return "\(seconds / 60)m" }
        if seconds < 86_400 { return "\(seconds / 3_600)h" }
        return "\(seconds / 86_400)d"
    }
}

final class ConversationViewController: UIViewController {
    private let viewModel: ConversationViewModel
    private var messages: [ChatMessage] {
        viewModel.messages
    }
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let composer = UIView()
    private let messageField = UITextField()
    private let sendButton = UIButton(type: .system)

    init(viewModel: ConversationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.conversation.username
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "video"), style: .plain, target: nil, action: nil)
        ]
        setupComposer()
        setupTable()
        tableView.reloadData()
        scrollToLatestMessage()
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.register(ChatBubbleCell.self, forCellReuseIdentifier: ChatBubbleCell.reuseIdentifier)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: composer.topAnchor)
        ])
    }

    private func setupComposer() {
        composer.translatesAutoresizingMaskIntoConstraints = false
        composer.backgroundColor = .systemBackground
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .separator

        messageField.translatesAutoresizingMaskIntoConstraints = false
        messageField.placeholder = "Message..."
        messageField.borderStyle = .roundedRect
        messageField.backgroundColor = .secondarySystemBackground
        messageField.returnKeyType = .send
        messageField.delegate = self

        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = .systemBlue
        sendButton.accessibilityLabel = "Send message"
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)

        [composer, separator, messageField, sendButton].forEach(view.addSubview)
        NSLayoutConstraint.activate([
            composer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            composer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            composer.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            composer.heightAnchor.constraint(equalToConstant: 60),

            separator.topAnchor.constraint(equalTo: composer.topAnchor),
            separator.leadingAnchor.constraint(equalTo: composer.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: composer.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5),

            messageField.leadingAnchor.constraint(equalTo: composer.leadingAnchor, constant: 16),
            messageField.centerYAnchor.constraint(equalTo: composer.centerYAnchor),
            messageField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
            messageField.heightAnchor.constraint(equalToConstant: 38),

            sendButton.trailingAnchor.constraint(equalTo: composer.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: composer.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            sendButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func sendTapped() {
        guard let text = messageField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            return
        }
        viewModel.send(text)
        messageField.text = nil
        tableView.reloadData()
        scrollToLatestMessage()
    }

    private func scrollToLatestMessage() {
        guard !messages.isEmpty else { return }
        tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
    }
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatBubbleCell.reuseIdentifier,
            for: indexPath
        ) as? ChatBubbleCell else {
            return UITableViewCell()
        }
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}

extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTapped()
        return true
    }
}

private final class ChatBubbleCell: UITableViewCell {
    static let reuseIdentifier = "ChatBubbleCell"
    private let bubble = UIView()
    private let messageLabel = UILabel()
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.layer.cornerRadius = 18
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = .systemFont(ofSize: 15)
        messageLabel.numberOfLines = 0

        contentView.addSubview(bubble)
        bubble.addSubview(messageLabel)
        leadingConstraint = bubble.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        trailingConstraint = bubble.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)

        NSLayoutConstraint.activate([
            bubble.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            bubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            bubble.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.76),
            leadingConstraint,
            trailingConstraint,

            messageLabel.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -14)
        ])
    }

    func configure(with message: ChatMessage) {
        messageLabel.text = message.text
        bubble.backgroundColor = message.isOutgoing ? .systemBlue : .secondarySystemBackground
        messageLabel.textColor = message.isOutgoing ? .white : .label
        leadingConstraint.isActive = !message.isOutgoing
        trailingConstraint.isActive = message.isOutgoing
    }
}
