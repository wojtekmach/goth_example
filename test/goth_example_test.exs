defmodule GothExampleTest do
  use ExUnit.Case
  doctest GothExample

  test "greets the world" do
    assert GothExample.hello() == :world
  end
end
