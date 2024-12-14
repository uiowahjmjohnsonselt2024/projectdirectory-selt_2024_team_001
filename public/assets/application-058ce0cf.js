import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-loading"
import { createConsumer } from "@rails/actioncable"

// Stimulus setup
const application = Application.start()
const context = require.context("controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

// Initialize ActionCable
window.App || (window.App = {})
window.App.cable = createConsumer()
