defmodule Excoin.Transaction do

  alias Excoin.TransactionIn, as: TransactionIn 
  alias Excoin.TransactionOut, as: TransactionOut 

  defstruct ver: 1, lock_time: 0, in: [], out: [], scripts: []

  @default_version 1

  def from_json(json) do
    Poison.Parser.parse!(json) |> from_hash
  end

  def from_hash(map) do
    %Excoin.Transaction{
      :ver => map["ver"] || map["version"],
      :lock_time => map["lock_time"] || 0,
      :in => in_from_hash(map),
      :out => out_from_hash(map)
    }
  end

  defp in_from_hash(map) do
    (map["in"] || map["inputs"]) |>
    Enum.map fn (tx_in) -> TransactionIn.from_hash(tx_in) end
  end

  defp out_from_hash(map) do
    (map["out"] || map["outputs"]) |>
    Enum.map fn (tx_out) -> TransactionOut.from_hash(tx_out) end
  end

  def to_payload(tx) do
    int_32_to_payload(tx.ver) <> 
    Excoin.Protocol.pack_var_int(length(tx.in)) <>
    _in_to_payload(tx.in, "") <>
    Excoin.Protocol.pack_var_int(length(tx.out)) <>
    _out_to_payload(tx.out, "") <>
    int_32_to_payload(tx.lock_time)
  end

  #you may be able to eliminate the redundancy by making both conform to a protocol
  defp _in_to_payload([], payload), do: payload
  defp _in_to_payload([head | tail], payload), do: _in_to_payload(tail, payload <> TransactionIn.to_payload(head))

  defp _out_to_payload([], payload), do: payload
  defp _out_to_payload([head | tail], payload), do: _out_to_payload(tail, payload <> TransactionOut.to_payload(head))

  defp int_32_to_payload(int) do
    << int :: little-size(32) >>
  end

  def from_io(buf) do
    {ver, buf} = ver_from_io(buf)
    {ins, buf} = tx_in_from_io(buf)
    {outs, buf} = tx_out_from_io(buf)
    {lock_time, buf} = lock_time_from_io(buf)

    tx = %Excoin.Transaction{
        :ver => ver,
        :lock_time => lock_time,
        :in => ins,
        :out => outs
      }

    {tx, buf}
  end

  defp ver_from_io(buf) do
    << ver_bin :: binary-size(4), buf :: binary >> = buf
    << ver :: little-size(32), _ :: binary >> = ver_bin
    {ver, buf}
  end

  defp tx_in_from_io(buf) do
    {size, buf} = Excoin.Protocol.unpack_var_int_from_io(buf)
    _tx_in_from_io([], buf, size)
  end

  defp _tx_in_from_io(ins, buf, 0), do: {ins, buf} 
  defp _tx_in_from_io(ins, <<>>, _), do: {ins, <<>>}
  defp _tx_in_from_io(ins, buf, size) do
     {tx_in, buf} = TransactionIn.from_io(buf)
     ins = ins ++ [tx_in]
    _tx_in_from_io(ins, buf, size - 1)
  end

  defp tx_out_from_io(buf) do
    {size, buf} = Excoin.Protocol.unpack_var_int_from_io(buf)
    _tx_out_from_io([], buf, size)
  end

  defp _tx_out_from_io(outs, buf, 0), do: {outs, buf}
  defp _tx_out_from_io(outs, <<>>, _), do: {outs, <<>>}
  defp _tx_out_from_io(outs, buf, size) do
     {tx_out, buf} = TransactionOut.from_io(buf)
     outs = outs ++ [tx_out]
    _tx_out_from_io(outs, buf, size - 1)
  end

  defp lock_time_from_io(buf) do
    << lock_time_bin :: binary-size(4), buf :: binary >> = buf
    << lock_time :: little-size(32), _ :: binary >> = lock_time_bin
    {lock_time, buf}
  end

end