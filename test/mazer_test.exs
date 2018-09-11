defmodule MazerTest do
  use ExUnit.Case
  doctest Mazer

  test "greets the world" do
    assert Mazer.hello() == :world
  end
end
