import Foundation

final class MessagesViewModel {
    private let fetchConversations: FetchConversationsUseCase

    init(fetchConversations: FetchConversationsUseCase) {
        self.fetchConversations = fetchConversations
    }

    func conversations(matching query: String) -> [MessageConversation] {
        let allConversations = fetchConversations.execute()
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedQuery.isEmpty else { return allConversations }

        return allConversations.filter {
            $0.username.localizedCaseInsensitiveContains(normalizedQuery)
        }
    }
}

final class ConversationViewModel {
    let conversation: MessageConversation
    private let fetchMessages: FetchMessagesUseCase
    private let sendMessage: SendMessageUseCase

    init(
        conversation: MessageConversation,
        fetchMessages: FetchMessagesUseCase,
        sendMessage: SendMessageUseCase
    ) {
        self.conversation = conversation
        self.fetchMessages = fetchMessages
        self.sendMessage = sendMessage
    }

    var messages: [ChatMessage] {
        fetchMessages.execute(for: conversation.id)
    }

    func send(_ text: String) {
        sendMessage.execute(text, to: conversation.id)
    }
}

enum MessagingFeatureFactory {
    private static let repository: MessageRepository = InMemoryMessageRepository()

    static func makeMessagesViewModel() -> MessagesViewModel {
        MessagesViewModel(fetchConversations: FetchConversationsUseCase(repository: repository))
    }

    static func makeConversationViewModel(for conversation: MessageConversation) -> ConversationViewModel {
        ConversationViewModel(
            conversation: conversation,
            fetchMessages: FetchMessagesUseCase(repository: repository),
            sendMessage: SendMessageUseCase(repository: repository)
        )
    }
}