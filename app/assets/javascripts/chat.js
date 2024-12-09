document.addEventListener("DOMContentLoaded", () => {
    const chatMessages = document.getElementById("chat-messages");
    const chatInput = document.getElementById("chat-input");
    const sendButton = document.getElementById("send-btn");

    // Initialize WebSocket connection
    const webSocket = new WebSocket("ws://localhost:3000/cable");

    webSocket.onopen = () => {
        console.log("WebSocket connected.");
    };

    webSocket.onmessage = (event) => {
        const data = JSON.parse(event.data);
        if (data.type === "ping") return; // Ignore server pings

        if (data.message) {
            chatMessages.insertAdjacentHTML("beforeend", data.message);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
    };

    webSocket.onerror = (error) => {
        console.error("WebSocket Error:", error);
    };

    sendButton.addEventListener("click", () => {
        const message = chatInput.value.trim();
        if (message) {
            webSocket.send(
                JSON.stringify({
                    command: "message",
                    identifier: JSON.stringify({
                        channel: "ChatChannel",
                        room: "general",
                    }),
                    data: JSON.stringify({
                        action: "speak",
                        message: message,
                    }),
                })
            );
            chatInput.value = "";
        }
    });
});
