defmodule Teammor.Checkins do
  use Ash.Domain

  resources do
    resource Teammor.Checkins.Checkin
  end
end
