defmodule Excoin.TransactionIn do

  defstruct previous_output_hash: "", previous_output_index: "", script_sig_length: 0, script_sig: "", sequence: <<255, 255, 255, 255>> 

  def from_hash(map) do
  	%Excoin.TransactionIn{
  		:previous_output_hash => prev_out_hash_from_hash(map),
  		:previous_output_index => prev_out_index_from_hash(map),
  		:script_sig => script_sig_from_hash(map),
  		:sequence => sequence_from_hash(map)
  		}
  end

 defp prev_out_hash_from_hash(map) do
 	previous_hash = map["previous_transaction_hash"] || map["prev_out"]["hash"]
 	Base.decode16!(previous_hash, case: :lower) |> reverse_bin
 end

 def reverse_bin(bin) do
 	_reverse_bin(bin, <<>>)
 end

 defp _reverse_bin(<<>>, new_bin), do: new_bin
 defp _reverse_bin(<<head :: binary-size(1), rest :: binary>> , new_bin) do
 	_reverse_bin(rest, head <> new_bin)
 end

 defp prev_out_index_from_hash(map) do
 	map["output_index"] || map["prev_out"]["n"]
 end

 defp script_sig_from_hash(map) do
 	case Map.has_key?(map, "coinbase") do
 		true ->	Base.decode16!(map.coinbase, case: :lower)
 		false -> Excoin.Script.binary_from_string(map["scriptSig"] || map["script"])
 	end
 end

 defp sequence_from_hash(map) do
 	sequence = map["sequence"] || 0xffffffff
 	<< sequence :: little-size(32) >>
 end

 def to_payload(tx_in) do
 	prev_out_hash_to_payload(tx_in.previous_output_hash, tx_in.previous_output_index) <>
 	Excoin.Protocol.pack_var_int(tx_in.script_sig |> byte_size) <>
 	tx_in.script_sig <>
 	tx_in.sequence
 end

 def prev_out_hash_to_payload(prev_out_hash, prev_out_index) do
 	<< out_hash :: binary-size(32), _ :: binary >> = prev_out_hash
 	out_index = << prev_out_index :: little-size(32) >>
 	out_hash <> out_index
 end

end