import { Socket } from "phoenix";

const socket = new Socket("/socket", {params: {token: window.userToken}});
socket.connect();

const createSocket = (topicId) => {
  const channel = socket.channel(`comments:${topicId}`, {});
  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) });
}


window.createSocket = createSocket;
