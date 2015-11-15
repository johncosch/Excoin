defmodule Excoin.Transaction do

  alias Excoin.TransactionIn, as: TransactionIn 
  alias Excoin.TransactionOut, as: TransactionOut 

  defstruct ver: 1, lock_time: 0, in: [], out: [], scripts: []

  @default_version 1

  def from_json(json) do
    payload = Poison.Parser.parse!(json) |> 
              from_hash
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

end