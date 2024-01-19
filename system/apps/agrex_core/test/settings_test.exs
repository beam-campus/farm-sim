defmodule Agrex.Core.SettingsTest do
  use ExUnit.Case

  doctest Agrex.Core.Settings

  @tag :settings_test
  test "get_setting(:edge_id) returns the edge_id" do
    assert Agrex.Core.Settings.get_setting(:edge_id) == "edge_1"
  end

end
