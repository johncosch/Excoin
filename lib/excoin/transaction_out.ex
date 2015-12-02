defmodule Excoin.TransactionOut do

  defstruct amount: 0.0, script: ""

  def from_hash(map) do
    %Excoin.TransactionOut{
      amount: amount_from_hash(map),
      script: script_from_hash(map)
    }
  end

  defp amount_from_hash(map) do
    (map["value"] || map["amount"]) |> amount_to_float
  end

  defp script_from_hash(map) do
    (map["scriptPubKey"] || map["script"]) |> Excoin.Script.binary_from_string
  end

  defp amount_to_float(amount) when is_number(amount), do: amount
  defp amount_to_float(amount) when is_binary(amount) do
   {int, _} = String.replace(amount, ".", "") |> Integer.parse
   int
  end

  def to_payload(transaction_out) do
    amount = << transaction_out.amount :: unsigned-native-integer-size(64) >>
    amount <> Excoin.Protocol.pack_var_int(transaction_out.script |> byte_size) <> transaction_out.script
  end

  def from_io(buf) do
   {amount, buf} = amount_from_io(buf)
   {script, buf} = script_from_io(buf)

   tx_out = %Excoin.TransactionOut{amount: amount, script: script}

   {tx_out, buf}
  end

  defp amount_from_io(buf) do
    << bin_val :: binary-size(8), buf :: binary >> = buf
    << value :: unsigned-native-integer-size(64), _ :: binary >> = bin_val
    {value, buf}
  end

  defp script_from_io(buf) do
    {script_length, buf} = Excoin.Protocol.unpack_var_int_from_io(buf)
    << script :: binary-size(script_length), buf :: binary >> = buf 
    {script, buf}   
  end

end