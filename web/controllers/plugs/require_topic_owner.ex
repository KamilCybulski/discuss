defmodule Discuss.Plugs.RequireTopicOwner do
  import Plug.Conn, only: [halt: 1]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias Discuss.Router.Helpers
  alias Discuss.Repo
  alias Discuss.Topic

  def init(_params) do end

  def call(%{params: %{"id" => topic_id}} = conn, _) do
    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "It's not your's, don't touch it")
      |> redirect(to: Helpers.topic_path(conn, :index))
    end
  end
end