defmodule ListExtTest do
  use ExUnit.Case, async: true

  test "shift" do
    test_list = ["john", "bob", "joe", "allen"]
    assert List.Ext.shift(test_list, 2) == {["john", "bob"], ["joe", "allen"]}
    assert List.Ext.shift(test_list) == {["john"], ["bob", "joe", "allen"]}
    assert List.Ext.shift(test_list, 10) == {["john", "bob", "joe", "allen"], []}
  end

  test "pop" do
    test_list = ["john", "bob", "joe", "allen"]
    assert List.Ext.pop(test_list) == {["allen"], ["john", "bob", "joe"]}
  end

end