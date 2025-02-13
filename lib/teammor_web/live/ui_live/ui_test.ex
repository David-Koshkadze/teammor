defmodule TeammorWeb.UILive.UITest do
  use TeammorWeb, :live_view

  import TeammorWeb.Components.AlertDialog
  import TeammorWeb.Components.DropdownMenu
  import TeammorWeb.Components.Menu

  def mount(params, session, socket) do
    {:ok, socket, layout: false}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-[1128px] mx-auto p-4 sm:px-6 lg:px-8">
      <h1 class="text-2xl mb-4">Hello World</h1>

      <.alert_dialog :let={builder} id="alert-dialog-single-default">
        <.alert_dialog_trigger builder={builder}>
          <.button variant="outline">Show dialog</.button>
        </.alert_dialog_trigger>
        <.alert_dialog_content builder={builder}>
          <.alert_dialog_header>
            <.alert_dialog_title>Are you absolutely sure?</.alert_dialog_title>
            <.alert_dialog_description>
              this action cannot be undone. this will permanently delete your
              account and remove your data from our servers.
            </.alert_dialog_description>
          </.alert_dialog_header>
          <.alert_dialog_footer>
            <.alert_dialog_cancel builder={builder}>Cancel</.alert_dialog_cancel>
            <.alert_dialog_action phx-click={hide_alert_dialog(builder) |> JS.push("welcome")}>
              Continue
            </.alert_dialog_action>
          </.alert_dialog_footer>
        </.alert_dialog_content>
      </.alert_dialog>

      <div class="mt-4">
        <.dropdown_menu>
          <.dropdown_menu_trigger>
            <.button variant="outline">Click me</.button>
          </.dropdown_menu_trigger>
          <.dropdown_menu_content>
            <.menu class="w-56">
              <.menu_label>Account</.menu_label>
              <.menu_separator />
              <.menu_group>
                <.menu_item phx-click={JS.navigate("/sign-in")}>
                  <.icon name="hero-user" class="mr-2 h-4 w-4" />
                  <span>Profile</span>
                  <.menu_shortcut>⌘P</.menu_shortcut>
                </.menu_item>
                <.menu_item>
                  <.icon name="hero-banknotes" class="mr-2 h-4 w-4" />
                  <span>Billing</span>
                  <.menu_shortcut>⌘B</.menu_shortcut>
                </.menu_item>
                <.menu_item>
                  <.icon name="hero-cog-6-tooth" class="mr-2 h-4 w-4" />
                  <span>Settings</span>
                  <.menu_shortcut>⌘S</.menu_shortcut>
                </.menu_item>
              </.menu_group>
              <.menu_separator />
              <.menu_group>
                <.menu_item>
                  <.icon name="hero-users" class="mr-2 h-4 w-4" />
                  <span>Team</span>
                </.menu_item>
                <.menu_item disabled>
                  <.icon name="hero-plus" class="mr-2 h-4 w-4" />
                  <span>New team</span>
                  <.menu_shortcut>⌘T</.menu_shortcut>
                </.menu_item>
              </.menu_group>
            </.menu>
          </.dropdown_menu_content>
        </.dropdown_menu>
      </div>
    </div>
    """
  end
end
