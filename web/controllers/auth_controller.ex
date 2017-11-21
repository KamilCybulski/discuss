defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth

  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    %{"provider" => provider} = params
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: provider
    }
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Hello!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Oooops, something went really wrong. Try again.")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    Repo.get_by(User, email: changeset.changes.email)
    |> process_query_result(changeset)
  end

  defp process_query_result(nil, changeset) do
    Repo.insert(changeset)
  end

  defp process_query_result(user, _changeset) do
    {:ok, user}
  end
end