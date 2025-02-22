defmodule TeammorWeb.DashboardLive.Index do
  use TeammorWeb, :live_view

  on_mount {TeammorWeb.LiveUserAuth, :live_user_required}

  def on_mount(_params, _session, socket) do
    checkins = Teammor.Checkins.Checkin.list_checkins()

    {:ok, assign(socket, checkins: checkins)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-bold mb-2">Dashboard</h1>

    <p>
      Welcome, <strong><%= @current_user.email %></strong>!
    </p>

    <%!-- two graphs circles yet for analytics --%>
    <div class="grid grid-cols-2 gap-4 mt-4">
      <div class="bg-white p-4 rounded shadow">
        <h2 class="text-lg font-semibold mb-2">Check-ins</h2>
        <div class="flex items-center">
          <span class="text-2xl font-bold mr-2">12</span>
          <span class="text-sm text-gray-600">Today</span>
        </div>

        <%= for checkin <- @checkins do %>
          <div class="flex items-center mt-2">
            <span class="text-sm text-gray-600 mr-2"><%= checkin.date %></span>
            <span class="text-sm text-gray-600"><%= checkin.mood_score %></span>
          </div>
        <% end %>
      </div>

      <div class="bg-white p-4 rounded shadow">
        <h2 class="text-lg font-semibold mb-2">Average Stress Level</h2>
        <div class="flex items-center">
          <span class="text-2xl font-bold mr-2">4.5</span>
          <span class="text-sm text-gray-600">Last 7 days</span>
        </div>
      </div>

      <%!-- trend graph aggregated data --%>
      <div>
        <h2 class="text-lg font-semibold mb-2">Trend</h2>
        <div class="bg-white p-4 rounded shadow">
          <canvas id="trend-chart"></canvas>
        </div>
      </div>
    </div>
    """
  end
end
