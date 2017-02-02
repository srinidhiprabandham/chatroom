defmodule Chatroom.Plugs.Authentication do
  @behaviour Plug
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, _default) do
    current_user = get_session(conn, :current_user)
    if current_user do
      assign(conn, :current_user, current_user)
    else
      conn
      |> put_flash(:error, 'You need to be signed in to view this page')
      |> redirect(to: "/login")
    end
  end
end
