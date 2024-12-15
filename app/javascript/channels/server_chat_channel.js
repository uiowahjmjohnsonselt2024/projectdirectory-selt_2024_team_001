// app/javascript/channels/server_chat_channel.js

import consumer from "channels/consumer"

consumer.subscriptions.create("Turbo::StreamsChannel", {
    connected() {
        console.log("Connected to Turbo Streams")
    },
    disconnected() {
        console.log("Disconnected from Turbo Streams")
    },
    received(data) {
        console.log("Received:", data)
    }
})
