// app/javascript/channels/server_channel.js
import { createConsumer } from "@rails/actioncable"

export function initializeServerChat(serverId, currentUserId) {
    const consumer = createConsumer()

    const subscription = consumer.subscriptions.create(
        {
            channel: "ServerChannel",
            server_id: serverId
        },
        {
            connected() {
                console.log(`Connected to server ${serverId} chat`)
            },

            disconnected() {
                console.log(`Disconnected from server ${serverId} chat`)
            },

            received(data) {
                const chatMessages = document.getElementById('server-chat-messages')
                if (chatMessages) {
                    const messageElement = document.createElement('div')
                    messageElement.classList.add('chat-message')
                    messageElement.innerHTML = `
            <span class="message-user">${data.user_id}</span>
            <span class="message-text">${data.message}</span>
            <span class="message-time">${new Date(data.timestamp).toLocaleTimeString()}</span>
          `
                    chatMessages.appendChild(messageElement)
                    chatMessages.scrollTop = chatMessages.scrollHeight
                }
            }
        }
    )

    return {
        sendMessage(message) {
            subscription.send({
                server_id: serverId,
                user_id: currentUserId,
                message: message
            })
        }
    }
}