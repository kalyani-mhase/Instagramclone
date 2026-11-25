import Foundation

protocol MessageRepository {
    func fetchConversations() -> [MessageConversation]
    func fetchMessages(for conversationID: String) -> [ChatMessage]
    func sendMessage(_ text: String, to conversationID: String)
}