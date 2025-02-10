defmodule Teammor.Accounts do
  use Ash.Domain, otp_app: :teammor, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Teammor.Accounts.Token
    resource Teammor.Accounts.User
  end
end
