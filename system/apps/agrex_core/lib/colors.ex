defmodule Colors do
  def reset, do: "\e[0]"
  def red_on_black, do: "\e[31;40m"
  def green_on_black, do: "\e[32;40m"
  def yellow_on_black, do: "\e[33;40m"
  def blue_on_black, do: "\e[34;40m"
  def magenta_on_black, do: "\e[35;40m"
  def cyan_on_black, do: "\e[36;40m"
  def white_on_black, do: "\e[37;40m"

  def u, do: yellow_on_black()

  def hello_white_on_black, do: IO.puts("#{white_on_black()}Hello")
  def hello_u, do: IO.puts("#{u()}Hello#{reset()}")
end
