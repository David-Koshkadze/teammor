defmodule Teammor.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Teammor.Accounts.User, _opts) do
    Application.fetch_env(:teammor, :token_signing_secret)
  end
end
