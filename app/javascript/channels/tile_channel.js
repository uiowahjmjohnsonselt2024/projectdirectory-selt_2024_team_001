// app/javascript/channels/tile_channel.js
import consumer from "./consumer";

let tileSubscription;

export const subscribeToTile = (tileId) => {
    if (tileSubscription) {
        tileSubscription.unsubscribe(); // Unsubscribe from the previous tile channel
    }

    tileSubscription = consumer.subscriptions.create(
        { channel: "TileChannel", tile_id: tileId },
        {
            received(data) {
                // Handle incoming messages (e.g., ping notifications)
                alert(data.message); // Display the ping message
            },
        }
    );
};
