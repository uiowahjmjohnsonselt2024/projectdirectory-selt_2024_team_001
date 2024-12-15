// app/javascript/channels/index.js

import { createConsumer } from "@rails/actioncable"

// Create a shared consumer
const consumer = createConsumer()

// Auto-load all channels ending with `_channel.js`
const channels = require.context(".", true, /_channel\.js$/)
channels.keys().forEach((filename) => channels(filename).default)

export default consumer
