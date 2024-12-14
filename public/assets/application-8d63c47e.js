import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-loading"

// Stimulus setup
const application = Application.start()
const context = require.context("controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

// Import ActionCable Consumer
import { createConsumer } from "@rails/actioncable"

// ActionCable setup
const consumer = createConsumer()

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
