// Configure your import map in config/importmap.rb
import "@hotwired/turbo-rails"
import "controllers"
import { createConsumer } from "@rails/actioncable"

// Initialize Action Cable consumer
window.addEventListener("load", () => {
    const consumer = createConsumer()
})