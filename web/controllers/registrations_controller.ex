defmodule Chatroom.RegistrationsController do
  use Chatroom.Web, :controller
  alias Chatroom.User

  @doc """
  Landing page that shows the form to register
  """
  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  @doc """
  This will actually register the user
  """
  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Chatroom.User.create(changeset, Chatroom.Repo) do
      {:ok, changeset} ->
        #Sign the user in
        conn
        |> put_session(:current_user, changeset.id)
        |> put_flash(:info, "Your account was created")
        |> redirect(to: "/")
      {:error, changeset} ->
        #Render the same page and show error.
        conn
        |> put_flash(:error, "Unable to create account")
        |> render("new.html", changeset: changeset)
    end
  end
end
