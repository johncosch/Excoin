defmodule Excoin.TransactionIn do

  defstruct previous_output_hash: "", previous_output_index: "", script_sig: "", sequence: <<255, 255, 255, 255>> 

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
 	Base.decode16!(previous_hash, case: :lower) |> Binary.Ext.reverse
 end

 defp prev_out_index_from_hash(map) do
 	map["output_index"] || map["prev_out"]["n"]
 end

 defp script_sig_from_hash(map) do
 	case Map.has_key?(map, "coinbase") do
 		true ->	Base.decode16!(map["coinbase"], case: :lower)
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

 def from_io(buf) do 	
	{prev_out_hash, prev_out_index, buf} = prev_output_hash_from_io(buf)
	{script_sig, buf} = script_sig_from_io(buf)
	{sequence, buf} = sequence_from_io(buf)

	tx_in = %Excoin.TransactionIn{ 
						:previous_output_hash => prev_out_hash,
			  		:previous_output_index => prev_out_index,
			  		:script_sig => script_sig,
			  		:sequence => sequence
					}

	{tx_in, buf}
 end

 defp prev_output_hash_from_io(buf) do
 	<< chunk :: binary-size(36), buf :: binary >> = buf
	<< prev_out_hash :: binary-size(32), chunk_remainder :: binary >> = chunk
	<< prev_out_index :: little-size(32), _ :: binary >> = chunk_remainder
	{prev_out_hash, prev_out_index, buf}
 end

 defp script_sig_from_io(buf) do
 	{script_sig_length, buf} = Excoin.Protocol.unpack_var_int_from_io(buf)
 	<< script_sig :: binary-size(script_sig_length), buf :: binary >> = buf
 	{script_sig, buf}
 end

 defp sequence_from_io(buf) do
 	<< sequence :: binary-size(4), buf :: binary >> = buf
 	{sequence, buf}
 end

end