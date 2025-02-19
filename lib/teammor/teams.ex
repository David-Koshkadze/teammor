defmodule Teammor.Teams do
  use Ash.Domain

  resources do
    resource Teammor.Teams.Team
    resource Teammor.Teams.TeamMember
  end
end
