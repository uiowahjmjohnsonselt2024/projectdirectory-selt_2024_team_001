import consumer from "@rails/actioncable";

export function openConnection() {
    const subscription = consumer.subscriptions.create("ChatChannel", {
        connected() {
            console.log("Connected to ChatChannel!");
        },
        disconnected() {
            console.log("Disconnected from ChatChannel!");
        },
        received(data) {
            console.log("Received:", data);
        },
    });

    return subscription;
}
