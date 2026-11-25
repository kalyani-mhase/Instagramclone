import Foundation

struct FetchConversationsUseCase {
    private let repository: MessageRepository

    init(repository: MessageRepository) {
        self.repository = repository
    }

    func execute() -> [MessageConversation] {
        repository.fetchConversations()
    }
}

struct FetchMessagesUseCase {
    private let repository: MessageRepository

    init(repository: MessageRepository) {
        self.repository = repository
    }

    func execute(for conversationID: String) -> [ChatMessage] {
        repository.fetchMessages(for: conversationID)
    }
}

struct SendMessageUseCase {
    private let repository: MessageRepository

    init(repository: MessageRepository) {
        self.repository = repository
    }

    func execute(_ text: String, to conversationID: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        repository.sendMessage(trimmedText, to: conversationID)
    }
}