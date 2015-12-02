defmodule Excoin.AuxPow do 

	defstruct coinbase_tx: "", block_hash: "", coinbase_branch: "", coinbase_index: "", chain_branch: "", chain_index: "", parent_block: ""

	def from_hash(hash) do
		%Excoin.AuxPow{
			:coinbase_tx => Excoin.Transaction.from_hash(hash["coinbase_tx"]),
			:block_hash => Base.decode16!(hash["block_hash"], case: :lower),
			:coinbase_branch => hash["coinbase_branch"],
			:coinbase_index => hash["coinbase_index"],
			:chain_branch => hash["chain_branch"],
			:chain_index => hash["chain_index"], 
			:parent_block => Excoin.Block.from_hash(hash['parent_block'])
		}
	end

	def to_payload(aux_pow) do
		Transaction.to_payload(aux_pow.coinbase_tx) <>
		aux_pow.block_hash <>
		Excoin.Protocol.pack_var_int(length(aux_pow.coinbase_branch)) <> #not positive
		reverse_branch(aux_pow.coinbase_branch) <>
		aux_pow.coinbase_index <>
		Excoin.Protocol.pack_var_int(length(aux_pow.chain_branch)) <> 
		reverse_branch(aux_pow.chain_branch) <>
		aux_pow.chain_index <>
		Excoin.Block.to_payload(aux_pow.parent_block)
	end

	defp reverse_branch(branch) do
		_reverse_branch(branch, <<>>)
	end

	defp _reverse_branch([], bin), do: bin
	defp _reverse_branch([head | tail], bin) do
		head = Base.decode16!(head, case: :lower) |>
					 Binary.Ext.reverse
		_reverse_branch(tail, bin <> head)
	end

end