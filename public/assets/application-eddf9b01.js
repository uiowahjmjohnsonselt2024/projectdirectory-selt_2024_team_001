import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

// Stimulus setup
const application = Application.start()

// Automatic controller loading (alternative)
import { registerControllers } from "stimulus-vite-helpers"
import * as controllers from "controllers"
registerControllers(application, controllers)

// ActionCable setup
import { createConsumer } from "@rails/actioncable"
window.App || (window.App = {})
window.App.cable = createConsumer()
