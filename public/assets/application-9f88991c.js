// app/javascript/application.js

import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Stimulus setup
const application = Application.start()
import { definitionsFromContext } from "@hotwired/stimulus-loading"
const context = require.context("controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

// Initialize ActionCable
window.App || (window.App = {})
window.App.cable = createConsumer()

console.log("Application.js loaded successfully")
