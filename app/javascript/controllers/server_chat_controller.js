import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "messages"]

    connect() {
        console.log("Chat controller connected")
    }

    send(event) {
        event.preventDefault()
        const input = this.inputTarget
        const message = input.value.trim()

        if (message) {
            this.sendMessage(message)
            input.value = ''
        }
    }

    sendMessage(message) {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').content

        fetch('/chats', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': csrfToken
            },
            body: JSON.stringify({ message: message })
        })
    }
}