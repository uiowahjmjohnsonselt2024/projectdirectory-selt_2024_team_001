// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "@rails/actioncable"
import "controllers"

// Enable Turbo Drive
Turbo.session.drive = true

// Stimulus Setup
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-loading"

const application = Application.start()
const context = require.context("controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

// Action Cable Consumer
import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer("/cable")

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
