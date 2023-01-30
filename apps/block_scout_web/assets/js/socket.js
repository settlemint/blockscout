import { Socket } from "phoenix";
import { locale } from "./locale";

let websocketRootUrl = window.location.hostname.endsWith("settlemint.com")
  ? process.env.SOCKET_ROOT
  : `/insights/${window.location.pathname.split("/")[2]}`; // process.env.SOCKET_ROOT
if (!websocketRootUrl) {
  websocketRootUrl = "";
}
if (websocketRootUrl.endsWith("/")) {
  websocketRootUrl = websocketRootUrl.slice(0, -1);
}
console.log("WEBSOCKETROOTURL", websocketRootUrl);
const socket = new Socket(websocketRootUrl + "/socket", {
  /* logger: (kind, msg, data) => {
    console.log(`${kind}: ${msg}`, data);
  }, */
  params: { locale },
  transport: WebSocket,
});
socket.connect();

export default socket;

/**
 * Subscribes the client in the channel given the topic.
 *
 * This function will check if already exist a channel before creating one. This is useful because
 * when the client is attempting to create a duplicated subscription, the server will close the
 * existing subscription and create a new one.
 *
 * See more about it in https://hexdocs.pm/phoenix/js/#phoenix.
 *
 * Returns a Channel instance.
 */
export function subscribeChannel(topic) {
  const channel = socket.channels.find((channel) => channel.topic === topic);

  if (channel) {
    return channel;
  } else {
    const channel = socket.channel(topic, {});
    channel.join();
    return channel;
  }
}
