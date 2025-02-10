defmodule Teammor.Health.Checkin do
  use Ash.Resource, domain: Teammor.Health, data_layer: AshPostgres.DataLayer

  postgres do
    table "checkins"
    repo Teammor.Repo
  end

  actions do
    create :create do
      primary? true

      argument :user_id, :uuid do
        allow_nil? false
      end

      argument :team_id, :uuid do
        allow_nil? false
      end

      change manage_relationship(:user_id, :user)
      change manage_relationship(:team_id, :team_id)
    end

    read :read do
      primary? true
    end

    read :by_team do
      argument :team_id, :uuid do
        allow_nil? false
      end

      filter expr(team_id == ^arg(:team_id))
    end

    read :by_user do
      argument :user_id, :uuid do
        allow_nil? false
      end

      filter expr(user_id == ^arg(:user_id))
    end
  end

  attributes do
    uuid_primary_key :id

    # 1=😞 5=😊
    attribute :mood_score, :integer, constraints: [min: 1, max: 5]
    attribute :stress_level, :integer, constraints: [min: 1, max: 5]
    attribute :workload_level, :integer, constraints: [min: 1, max: 5]

    attribute :notes, :string do
      constraints max_length: 500
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :user, Teammor.Accounts.User do
      attribute_writable? true
      allow_nil? false
    end

    belongs_to :team, Teammor.Teams.Team do
      attribute_writable? true
      allow_nil? false
    end
  end
end
