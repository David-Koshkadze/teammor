defmodule TeammorWeb.CheckinLive.Form do
  use TeammorWeb, :live_view

  on_mount {TeammorWeb.LiveUserAuth, :live_user_required}

  def mount(_params, _session, socket) do
    user =
      socket.assigns.current_user |> Ash.load!(:team_members) |> Ash.load!(team_members: :team)

    IO.inspect(user, label: "user")

    teams = user.team_members |> Enum.map(& &1.team)

    IO.inspect(teams, label: "teams for current_user")

    case teams do
      [] ->
        {:ok,
         socket
         |> put_flash(:error, "You need to be part of a team to submit check-ins")
         |> redirect(to: ~p"/")}

      [team] ->
        {:ok,
         assign(socket,
           team: team,
           teams: teams,
           form:
             to_form(%{
               "mood_score" => 3,
               "stress_level" => 3,
               "workload_level" => 3,
               "notes" => "",
               "team_id" => team.id
             })
         )}

      _multiple_teams ->
        {:ok,
         assign(socket,
           teams: teams,
           form:
             to_form(%{
               "mood_score" => 3,
               "stress_level" => 3,
               "workload_level" => 3,
               "notes" => "",
               "team_id" => List.first(teams).id
             })
         )}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto py-8">
      <h1 class="text-2xl font-bold mb-6">Daily Check-in</h1>

      <.form for={@form} phx-submit="save" class="space-y-6">
        <%= if length(@teams) > 1 do %>
          <div>
            <label class="block text-sm font-medium mb-2">Team</label>
            <select name="team_id" class="w-full rounded-md border-gray-300 shadow-sm">
              <%= for team <- @teams do %>
                <option value={team.id}>{team.name}</option>
              <% end %>
            </select>
          </div>
        <% else %>
          <input type="hidden" name="team_id" value={@form[:team_id].value} />
        <% end %>

        <div>
          <label class="block text-sm font-medium mb-2">How are you feeling today?</label>
          <div class="flex space-x-4">
            <%= for score <- 1..5 do %>
              <label class="flex flex-col items-center">
                <input
                  type="radio"
                  name="mood_score"
                  value={score}
                  class="mb-2"
                  checked={@form[:mood_score].value == score}
                />
                <span>{mood_emoji(score)}</span>
              </label>
            <% end %>
          </div>
        </div>

        <div>
          <label class="block text-sm font-medium mb-2">Stress Level</label>
          <input
            type="range"
            name="stress_level"
            min="1"
            max="5"
            value={@form[:stress_level].value}
            class="w-full"
          />
        </div>

        <div>
          <label class="block text-sm font-medium mb-2">Workload Level</label>
          <input
            type="range"
            name="workload_level"
            min="1"
            max="5"
            value={@form[:workload_level].value}
            class="w-full"
          />
        </div>

        <div>
          <label class="block text-sm font-medium mb-2">Any additional notes? (optional)</label>
          <textarea name="notes" class="w-full rounded-md border-gray-300 shadow-sm" rows="3"><%= @form[:notes].value %></textarea>
        </div>

        <button type="submit" class="w-full bg-blue-500 text-white rounded-md py-2">
          Submit Check-in
        </button>
      </.form>
    </div>
    """
  end

  def handle_event("save", params, socket) do
    current_user = socket.assigns.current_user

    case Teammor.Checkins.Checkin.create(%{
           user_id: current_user.id,
           team_id: params["team_id"],
           mood_score: String.to_integer(params["mood_score"]),
           stress_level: String.to_integer(params["stress_level"]),
           workload_level: String.to_integer(params["workload_level"]),
           notes: params["notes"]
         }) do
      {:ok, _checkin} ->
        {:noreply,
         socket
         |> put_flash(:info, "Check-in submitted successfully!")
         |> redirect(to: ~p"/dashboard")}

      {:error, changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error submitting check-in: #{error_to_string(changeset)}")}
    end
  end

  defp mood_emoji(1), do: "😢"
  defp mood_emoji(2), do: "😕"
  defp mood_emoji(3), do: "😐"
  defp mood_emoji(4), do: "🙂"
  defp mood_emoji(5), do: "😄"

  defp error_to_string(changeset) do
    Enum.map(changeset.errors, fn {field, {message, _opts}} ->
      "#{field} #{message}"
    end)
    |> Enum.join(", ")
  end
end
