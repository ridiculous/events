defmodule LavaWeb.Router do
  use LavaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LavaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :fetch_current_cart
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :events_explorer do
    plug :put_root_layout, {LavaWeb.LayoutView, :events_explorer}
  end

  pipeline :timeline do
    plug :fetch_timeline
  end

  scope "/", LavaWeb do
    pipe_through :browser
    resources "/incidents", IncidentsController
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show
    resources "/products", ProductController
    resources "/cart_items", CartItemController, only: [:create, :delete]
    get "/cart", CartController, :show
    put "/cart", CartController, :update
    resources "/orders", OrderController, only: [:create, :show]
    scope "/explorer" do
      pipe_through :events_explorer
      resources "/", EventsController
      resources "/timelines", TimelinesController do
        pipe_through :timeline
        resources "/events", EventsController
      end
    end
    get "/", IncidentsController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", LavaWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: LavaWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp fetch_current_user(conn, _) do
    if user_uuid = get_session(conn, :current_uuid) do
      assign(conn, :current_uuid, user_uuid)
    else
      new_uuid = Ecto.UUID.generate()
      conn |> assign(:current_uuid, new_uuid) |> put_session(:current_uuid, new_uuid)
    end
  end

  alias Lava.ShoppingCart

  def fetch_current_cart(conn, _opts) do
    if cart = ShoppingCart.get_cart_by_user_uuid(conn.assigns.current_uuid) do
      assign(conn, :cart, cart)
    else
      {:ok, new_cart} = ShoppingCart.create_cart(conn.assigns.current_uuid)
      assign(conn, :cart, new_cart)
    end
  end

  defp fetch_timeline(conn, _opts) do
    if conn.params["timelines_id"] do
      assign(conn, :timeline, Lava.Repo.get!(Lava.Events.Timeline, conn.params["timelines_id"]))
    end
  end
end
