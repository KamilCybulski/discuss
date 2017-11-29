import { Socket } from "phoenix";


//================================================================
// Helpers

const commentTemplate = (comment) => (
  `<li class="collection-item">
    ${comment.content}
  </li>`
);

const extractComment = (event) => event.comment;

const renderComments =  (comments) => {
  const renderedComments = comments.map(commentTemplate);
  document.getElementById('comment-list').innerHTML = renderedComments.join('');
};

const renderComment = (comment) => {
  const renderedComment = commentTemplate(comment);
  document.getElementById('comment-list').innerHTML += renderedComment;
};

const handleNewComment = (event) => renderComment(extractComment(event));



//================================================================
// Socket connection

const socket = new Socket("/socket", {params: {token: window.userToken}});
socket.connect();



//================================================================
// Socket config

const createSocket = (topicId) => {
  const channel = socket.channel(`comments:${topicId}`, {});
  channel.join()
    .receive("ok", resp => { renderComments(resp.comments); })
    .receive("error", resp => { console.log("Unable to join", resp) });

  channel.on(`comments:${topicId}:new`, handleNewComment)

  document.getElementById('add-comment-btn').addEventListener('click', () => {
    const content = document.getElementById('comment-content').value

    channel.push('comment:add', { content: content })
  });
};


window.createSocket = createSocket;
