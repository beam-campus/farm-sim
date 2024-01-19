defmodule Agrex.Core.Settings do
  @moduledoc """
  Agrex.Core is the core of the Agrex system.
  """
  require Application

  def get_setting(key) do
    Application.get_env(:agrex_core, key)
  end
end
