defmodule Excoin.Protocol do

  def pack_var_int(int), do: _pack_var_int(int)

  defp _pack_var_int(int) when int < 0xfd do
    <<int>>
  end

  defp _pack_var_int(int) when int <= 0xffff do
    byte_order = <<int :: little-size(16)>>
    <<0xfd>> <> byte_order
  end

  defp _pack_var_int(int) when int <= 0xffffffff do
    byte_order = <<int :: little-size(32)>>
    <<0xfe>> <> byte_order
  end

  defp _pack_var_int(int) when int <= 0xffffffffffffffff do
    big_int = << int :: unsigned-native-integer-size(64) >>
    <<0xfe>> <> big_int
  end

  defp _pack_var_int(int) do
    raise "Int is too large."
  end

end
