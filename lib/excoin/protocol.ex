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

  def unpack_var_int_from_io(var) do
    << uchar :: binary-size(1), remaining_io :: binary >> = var
    << uint >> = uchar
    _unpack_var_int_from_io(uint, remaining_io)
  end

  defp _unpack_var_int_from_io(0xfd, rest) do
    << uchars :: binary-size(2), remaining_io :: binary >> = rest
    << int :: little-size(16), _ :: binary >> = uchars
    {int, remaining_io}
  end

  defp _unpack_var_int_from_io(0xfe, rest) do
    << uchars :: binary-size(4), remaining_io :: binary >> = rest
    << int :: little-size(32), _ :: binary >> = uchars
    {int, remaining_io}
  end

  defp _unpack_var_int_from_io(0xff, rest) do
    << uchars :: binary-size(8), remaining_io :: binary >> = rest
    << int :: unsigned-native-integer-size(64), _ :: binary >> = uchars
    {int, remaining_io}
  end

  defp _unpack_var_int_from_io(uchar, rest), do: {uchar, rest}

end
