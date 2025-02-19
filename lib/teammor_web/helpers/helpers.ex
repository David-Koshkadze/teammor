defmodule TeammorWeb.Helpers do
  def score_color(score) do
    case score do
      1 -> "border-red-800"
      2 -> "border-orange-500"
      3 -> "border-yellow-500"
      4 -> "border-green-500"
      5 -> "border-blue-500"
      _ -> "border-gray-500"
    end
  end

  def mood_emoji(1), do: "😢"
  def mood_emoji(2), do: "😕"
  def mood_emoji(3), do: "😐"
  def mood_emoji(4), do: "🙂"
  def mood_emoji(5), do: "😄"

  def error_to_string(changeset) do
    Enum.map(changeset.errors, fn {field, {message, _opts}} ->
      "#{field} #{message}"
    end)
    |> Enum.join(", ")
  end
end
