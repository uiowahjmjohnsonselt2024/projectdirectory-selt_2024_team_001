import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

consumer.subscriptions.create("ChatChannel", {
    connected() {
        console.log("Connected to ChatChannel")
    },

    disconnected() {
        console.log("Disconnected from ChatChannel")
    },

    received(data) {
        // Handle incoming messages
        const messagesContainer = document.getElementById('messages')
        if (messagesContainer) {
            const messageElement = document.createElement('div')
            messageElement.classList.add('message')
            messageElement.textContent = data.message
            messagesContainer.appendChild(messageElement)
        }
    }
})