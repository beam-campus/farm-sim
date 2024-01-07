defmodule MilkToAnalyse.Status do
  def unknown, do: 0
  def initialized, do: 1
  def occupied, do: 2
  def milking, do: 4
  def sanitizing, do: 8
  def cleaning, do: 16
  def released, do: 32
  def ready, do: 64
end
