defmodule HelloWeb.UserSocket do
  use Phoenix.Socket

  channel "users:*", HelloWeb.UserChannel
  channel "boards:*", HelloWeb.BoardChannel

  def connect(%{"token" => token}, socket) do
    case Hello.Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        case Hello.Guardian.resource_from_claims(claims) do
          {:ok, user} ->
            {:ok, assign(socket, :current_user, user)}
          {:error, _reason} ->
            :error
        end
      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket), do: :error

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  # def connect(_params, socket, _connect_info) do
  #   {:ok, socket}
  # end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     HelloWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  # def id(_socket), do: nil
  # def id(socket) do
  #   IEx.pry
  #   "users_socket:#{Guardian.Phoenix.Socket.current_resource(socket).id}"
  # end

  def id(socket), do: "users_socket:#{socket.assigns.current_user.id}"

end
