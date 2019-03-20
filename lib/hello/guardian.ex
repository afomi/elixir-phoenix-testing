defmodule Hello.Guardian do
  use Guardian, otp_app: :hello

  alias Hello.{Repo, User}

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    {:ok, Repo.get!(User, claims["sub"])}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end

  defmodule Pipeline do
    use Guardian.Plug.Pipeline, otp_app: :hello,
                                module: Hello.Guardian,
                                error_handler: Hello.Guardian.AuthErrorHandler

    # plug Guardian.Plug.VerifySession
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  defmodule AuthErrorHandler do
    import Plug.Conn

    def auth_error(conn, {type, reason}, _opts) do
      case Phoenix.Controller.get_format(conn) do
        "json" ->
          # body = Jason.encode!(%{message: type, reason: reason})
          body = Jason.encode!(%{message: to_string(type)})
          conn
          |> send_resp(401, body)
          |> halt()
        "html" ->
          conn # Let front end handle
      end
    end
  end
end
