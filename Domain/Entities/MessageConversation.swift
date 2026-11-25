import Foundation

struct MessageConversation: Identifiable, Equatable {
    let id: String
    let username: String
    var latestMessage: String
    var lastUpdated: Date
    var unreadCount: Int
}

enum MessageSender {
    case currentUser
    case other
}

struct ChatMessage: Identifiable {
    let id: UUID
    let text: String
    let sender: MessageSender
    let sentAt: Date

    init(id: UUID = UUID(), text: String, sender: MessageSender, sentAt: Date = Date()) {
        self.id = id
        self.text = text
        self.sender = sender
        self.sentAt = sentAt
    }

    var isOutgoing: Bool {
        sender == .currentUser
    }
}