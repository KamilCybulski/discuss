defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  def init(_) do end

  def call(conn, _) do
    user_id = get_session(conn, :user_id)
    user = user_id && Repo.get(User, user_id)
    
    process_call(conn, user)
  end

  defp process_call(conn, nil) do
    assign(conn, :user, nil)
  end

  defp process_call(conn, user) do
    assign(conn, :user, user)
  end
end