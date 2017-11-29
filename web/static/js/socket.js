import { Socket } from "phoenix";

const renderComments =  (comments) => {
  const renderedComments = comments.map(c => (
    `<li class="collection-item">
      ${c.content}
    </li>`
  ));
  document.getElementById('comment-list').innerHTML = renderedComments.join('');
};

const socket = new Socket("/socket", {params: {token: window.userToken}});
socket.connect();

const createSocket = (topicId) => {
  const channel = socket.channel(`comments:${topicId}`, {});
  channel.join()
    .receive("ok", resp => { renderComments(resp.comments); })
    .receive("error", resp => { console.log("Unable to join", resp) });

  document.getElementById('add-comment-btn').addEventListener('click', () => {
    const content = document.getElementById('comment-content').value

    channel.push('comment:add', { content: content })
  });
};


window.createSocket = createSocket;
