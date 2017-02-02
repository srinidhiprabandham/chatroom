defmodule Chatroom.Router do
  use Chatroom.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Chatroom.Plugs.Authentication
  end

  scope "/", Chatroom do
    pipe_through :browser # Use the default browser stack

    #These things don't require a user to be logged in
    get   "/registrations", RegistrationsController, :new
    post  "/registrations", RegistrationsController, :create

    get   "/login",         SessionsController,      :new
    post  "/login",         SessionsController,      :create
  end

  scope "/", Chatroom do
    pipe_through [:browser, :authenticated]

    get    "/",              PageController,          :index
    delete "/logout",        SessionsController,      :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Chatroom do
  #   pipe_through :api
  # end
end
