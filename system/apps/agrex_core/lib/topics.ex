defmodule Agrex.Topics do
  def pulsed(domain), do: "agrex:#{domain}:pulsed"
  def pulsed, do: "agrex:pulsed"
end
