defmodule Discuss.Plugs.RequireAuth do
  import Plug.Conn, only: [halt: 1]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  
  alias Discuss.Router.Helpers

  def init(_params) do end

  def call(conn, _params) do
    call(conn)
  end

  defp call(%{assigns: %{user: nil}} = conn) do
    conn
    |> put_flash(:error, "You must be logged in")
    |> redirect(to: Helpers.topic_path(conn, :index))
    |> halt()
  end

  defp call(%{assigns: %{user: user}} = conn) do
    conn
  end
end