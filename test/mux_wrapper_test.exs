defmodule MuxWrapperTest do
  use ExUnit.Case
  doctest MuxWrapper

  test "greets the world" do
    assert MuxWrapper.hello() == :world
  end
end
