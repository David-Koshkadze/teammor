defmodule Teammor.Teams.TeamMember do
  use Ash.Resource,
    domain: Teammor.Teams,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "team_members"
    repo Teammor.Repo
  end

  code_interface do
    define :create
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

      change set_attribute(:team_id, arg(:team_id))
      change set_attribute(:user_id, arg(:user_id))
    end

    read :read do
      primary? true
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :role, :atom do
      constraints one_of: [:member, :manager]
      default :member
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :team, Teammor.Teams.Team do
      attribute_writable? true
      allow_nil? false
      source_attribute :team_id
      destination_attribute :id
    end

    belongs_to :user, Teammor.Accounts.User do
      attribute_writable? true
      allow_nil? false
    end
  end
end
