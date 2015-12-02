defmodule Binary.Ext do 
 
 def reverse(bin) do
  _reverse(bin, <<>>)
 end

 defp _reverse(<<>>, new_bin), do: new_bin
 defp _reverse(<<head :: binary-size(1), rest :: binary>> , new_bin) do
  _reverse(rest, head <> new_bin)
 end


end