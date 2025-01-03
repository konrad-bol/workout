defmodule WorkoutWeb.Constants do
  @internal_server_error "Internal Server Error"
  @ivalid_credentials "Invalid Credentials"
  @not_authenticated "Not Authenticated"
  @not_authorized "Not Authorized"
  @not_found "Not Found"
  def internal_server_error, do: @internal_server_error
  def ivalid_credentials, do: @ivalid_credentials
  def not_authenticated, do: @not_authenticated
  def not_authorized, do: @not_authorized
  def not_found, do: @not_found
end
