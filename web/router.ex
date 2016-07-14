defmodule FemiEducation.Router do
  use FemiEducation.Web, :router

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

  scope "/", FemiEducation do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/:topic", PageController, :topic
    get "/:topic/:article", PageController, :article
  end

  # Other scopes may use custom stacks.
  # scope "/api", FemiEducation do
  #   pipe_through :api
  # end
end
