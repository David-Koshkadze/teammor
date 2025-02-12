defmodule Teammor.Teams.Team do
  use Ash.Resource, domain: Teammor.Teams, data_layer: AshPostgres.DataLayer

  postgres do
    table "teams"
    repo Teammor.Repo
  end

  code_interface do
    define :create_team, action: :create, args: [:name]
    define :list_teams, action: :read
    define :update_name, action: :update_name
  end

  actions do
    create :create do
      primary? true

      argument :name, :string do
        allow_nil? false
      end
    end

    read :read do
      primary? true
    end

    update :update_name do
      primary? true
      accept [:name]
      change set_attribute(:name, arg(:name))
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      constraints max_length: 100
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :members, Teammor.Teams.TeamMember
    # has_many :users, through: [:members, :user]
    has_many :checkins, Teammor.Checkins.Checkin
  end
end
