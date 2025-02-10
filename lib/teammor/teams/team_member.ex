defmodule Teammor.Teams.TeamMember do
  use Ash.Resource,
    domain: Teammor.Teams,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "team_members"
    repo Teammor.Repo
  end

  actions do
    create :create do
      primary? true

      argument :team_id, :uuid do
        allow_nil? false
      end

      argument :user_id, :uuid do
        allow_nil? false
      end

      change manage_relationship(:team_id, :team)
      change manage_relationship(:user_id, :user)
    end

    read :read do
      primary? true
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :role, :string do
      constraints one_of: ["member", "manager"]
      default "member"
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :team, Teammor.Teams.Team do
      attribute_writable? true
      allow_nil? false
    end

    belongs_to :user, Teammor.Accounts.User do
      attribute_writable? true
      allow_nil? false
    end
  end
end
