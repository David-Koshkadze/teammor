defmodule Teammor.Checkins.Checkin do
  use Ash.Resource, domain: Teammor.Checkins, data_layer: AshPostgres.DataLayer

  postgres do
    table "checkins"
    repo Teammor.Repo
  end

  code_interface do
    define :create, action: :create
    define :list_checkins, action: :read
  end

  actions do
    create :create do
      primary? true

      argument :user_id, :uuid, allow_nil?: false
      argument :team_id, :uuid, allow_nil?: false
      argument :mood_score, :integer, allow_nil?: false
      argument :stress_level, :integer, allow_nil?: false
      argument :workload_level, :integer, allow_nil?: false
      argument :notes, :string, allow_nil?: true

      accept [:user_id, :team_id, :mood_score, :stress_level, :workload_level, :notes]

      # change manage_relationship(:user_id, :user, type: :append_and_remove)
      # change manage_relationship(:team_id, :team, type: :append_and_remove)

      change set_attribute(:user_id, arg(:user_id))
      change set_attribute(:team_id, arg(:team_id))
      change set_attribute(:mood_score, arg(:mood_score))
      change set_attribute(:stress_level, arg(:stress_level))
      change set_attribute(:workload_level, arg(:workload_level))
      change set_attribute(:notes, arg(:notes))
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
