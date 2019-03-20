defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Hello.Guardian.Pipeline
  end

  # Other scopes may use custom stacks.
  scope "/api", HelloWeb do
    pipe_through :api

    scope "/v1" do
      post "/registrations", RegistrationController, :create

      post "/sessions", SessionController, :create
      delete "/sessions", SessionController, :delete

      get "/current_user", CurrentUserController, :show

      resources "/boards", BoardController, only: [:index, :create] do
        resources "/cards", CardController, only: [:show]
      end
    end
  end

  scope "/", HelloWeb do
    pipe_through :browser

    get "/hello/", SiteController, :index
    get "/hello/:id", SiteController, :show
    resources "/users", UserController
    get "/*path", PageController, :index
  end
end
