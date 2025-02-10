defmodule Teammor.Teams do
  use Ash.Domain

  resources do
    resource Teammor.Teams.Team
  end
end
