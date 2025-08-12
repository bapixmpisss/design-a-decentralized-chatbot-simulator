import Foundation

// Node structure for the decentralized network
struct Node {
    let id: UUID
    var isConnected: Bool = false
    var chatHistory: [Message] = []
    var neighbors: [Node] = []
}

// Message structure
struct Message {
    let content: String
    let senderId: UUID
    let timestamp: Date
}

// Decentralized chatbot simulator
class DecentChatSimulator {
    private var nodes: [Node] = []
    private let numberOfNodes: Int
    private let connectionProbability: Double

    init(numberOfNodes: Int, connectionProbability: Double) {
        self.numberOfNodes = numberOfNodes
        self.connectionProbability = connectionProbability
        createNodes()
        establishConnections()
    }

    private func createNodes() {
        for _ in 1...numberOfNodes {
            let newNode = Node(id: UUID())
            nodes.append(newNode)
        }
    }

    private func establishConnections() {
        for i in 0..<nodes.count {
            for j in i+1..<nodes.count {
                if Double.random(in: 0.0...1.0) < connectionProbability {
                    nodes[i].neighbors.append(nodes[j])
                    nodes[j].neighbors.append(nodes[i])
                    nodes[i].isConnected = true
                    nodes[j].isConnected = true
                }
            }
        }
    }

    func broadcastMessage(_ message: Message) {
        for node in nodes {
            node.chatHistory.append(message)
            for neighbor in node.neighbors {
                if neighbor.isConnected {
                    neighbor.chatHistory.append(message)
                }
            }
        }
    }

    func simulateConversation() {
        let chatbots: [Chatbot] = nodes.map { Chatbot(node: $0) }
        for _ in 1...10 {
            for chatbot in chatbots {
                let message = chatbot.generateMessage()
                broadcastMessage(message)
            }
        }
    }
}

// Chatbot AI
class Chatbot {
    let node: Node
    let aiModel: AIModel

    init(node: Node) {
        self.node = node
        aiModel = AIModel()
    }

    func generateMessage() -> Message {
        let response = aiModel.respond(to: node.chatHistory)
        return Message(content: response, senderId: node.id, timestamp: Date())
    }
}

// Simple AI model for demonstration purposes
class AIModel {
    func respond(to chatHistory: [Message]) -> String {
        let randomResponse = ["Hello!", "Hi!", "Hey!"]
        return randomResponse.randomElement() ?? ""
    }
}

let simulator = DecentChatSimulator(numberOfNodes: 10, connectionProbability: 0.5)
simulator.simulateConversation()