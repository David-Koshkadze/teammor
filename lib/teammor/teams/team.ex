defmodule Teammor.Teams.Team do
  use Ash.Resource, domain: Teammor.Teams, data_layer: AshPostgres.DataLayer

  alias Teammor.Teams.TeamMember

  postgres do
    table "teams"
    repo Teammor.Repo
  end

  code_interface do
    define :create_team, action: :create, args: [:name]
    define :list_teams, action: :read
    define :update_name, action: :update_name
    define :get_user_teams, action: :get_user_teams
    define :add_user, action: :add_user
  end

  actions do
    create :create do
      primary? true

      argument :name, :string do
        allow_nil? false
      end
    end

    create :add_user do
      argument :user_id, :uuid
      argument :team_id, :uuid

      # ensure team exists
      change manage_relationship(:team_id, :members, on_no_match: :error)

      # create the TeamMember record
      change fn changeset, _ ->
        case TeamMember.create(%{
          team_id: changeset.arguments.team_id,
          user_id: changeset.arguments.user_id
        }) do
          {:ok, _team_member} ->
            {:ok, changeset}

          {:error, errors} ->
            {:error, errors}
        end
      end
    end

    read :read do
      primary? true
    end

    read :get_user_teams do
      argument :user_id, :uuid

      filter expr(user_id == ^arg(:user_id))
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
    has_many :members, Teammor.Teams.TeamMember do
      source_attribute :id
      destination_attribute :team_id
    end
    has_many :checkins, Teammor.Checkins.Checkin
  end
end
