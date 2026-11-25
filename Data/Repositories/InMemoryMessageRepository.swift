import Foundation

final class InMemoryMessageRepository: MessageRepository {
    private var conversations: [MessageConversation]
    private var messagesByConversationID: [String: [ChatMessage]]

    init(now: Date = Date()) {
        conversations = [
            MessageConversation(id: "Shruti Pawar", username: "Shruti Pawar", latestMessage: "That looks amazing! ✨", lastUpdated: now.addingTimeInterval(-120), unreadCount: 1),
            MessageConversation(id: "Nidhi Agarwal", username: "Nidhi Agarwal", latestMessage: "See you tomorrow", lastUpdated: now.addingTimeInterval(-900), unreadCount: 1),
            MessageConversation(id: "Pankaj Kale", username: "Pankaj Kale", latestMessage: "Sent a photo", lastUpdated: now.addingTimeInterval(-3600), unreadCount: 0),
            MessageConversation(id: "Swati Kale", username: "Swati Kale", latestMessage: "Thank you 😊", lastUpdated: now.addingTimeInterval(-10800), unreadCount: 0),
            MessageConversation(id: "Shreya Patil", username: "Shreya Patil", latestMessage: "You: Sounds good!", lastUpdated: now.addingTimeInterval(-86400), unreadCount: 0),
            MessageConversation(id: "Mrunal Gade", username: "Mrunal Gade", latestMessage: "Liked a message", lastUpdated: now.addingTimeInterval(-172800), unreadCount: 0)
        ]

        let seedMessages = [
            ChatMessage(text: "Hey! How are you?", sender: .other, sentAt: now.addingTimeInterval(-3600)),
            ChatMessage(text: "I’m doing well, thanks! How about you?", sender: .currentUser, sentAt: now.addingTimeInterval(-3500)),
            ChatMessage(text: "Great! Did you see my latest post?", sender: .other, sentAt: now.addingTimeInterval(-3400)),
            ChatMessage(text: "Yes, it looks amazing ✨", sender: .currentUser, sentAt: now.addingTimeInterval(-3300))
        ]
        messagesByConversationID = Dictionary(
            uniqueKeysWithValues: conversations.map { ($0.id, seedMessages) }
        )
    }

    func fetchConversations() -> [MessageConversation] {
        conversations.sorted { $0.lastUpdated > $1.lastUpdated }
    }

    func fetchMessages(for conversationID: String) -> [ChatMessage] {
        messagesByConversationID[conversationID] ?? []
    }

    func sendMessage(_ text: String, to conversationID: String) {
        let message = ChatMessage(text: text, sender: .currentUser)
        messagesByConversationID[conversationID, default: []].append(message)

        guard let index = conversations.firstIndex(where: { $0.id == conversationID }) else { return }
        conversations[index].latestMessage = "You: \(text)"
        conversations[index].lastUpdated = message.sentAt
        conversations[index].unreadCount = 0
    }
}