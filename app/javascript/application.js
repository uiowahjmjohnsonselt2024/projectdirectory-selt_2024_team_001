// Entry point for Rails JavaScript

// ActionCable (for WebSockets)
console.log("Importing channels...");
import("./channels").then(() => console.log("Imported channels successfully!"));
//import "./channels"  // This imports `index.js` from `channels` automatically




