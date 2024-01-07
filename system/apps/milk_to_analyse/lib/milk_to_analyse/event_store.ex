defmodule MilkToAnalyse.EventStore do
  use EventStore, otp_app: :agrex

  def init(config) do
    {:ok, config}
  end


end
