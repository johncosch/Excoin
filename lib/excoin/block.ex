defmodule Excoin.Block do 
	defstruct transactions: [], hash: "", prev_block_hash: "", mrkl_root: "", time: 0, bits: 0, nonce: 0, ver: 0, payload: "", aux_pow: ""

	@block_version_default 1
	@block_version_auxpow 256
	@block_version_chain_start 65536
	@block_version_chain_end :math.pow(2,30) |> round

	def from_json(json) do
		Poison.Parser.parse!(json) |> from_hash
	end

	def to_payload(block) do
		ver = << block.ver :: little-size(32) >>
		prev_block_hash = block.prev_block_hash
		mrkl_root = block.mrkl_root
		time = << block.time :: little-size(32) >>
		bits = << block.bits :: little-size(32) >>
		nonce = << block.nonce :: little-size(32) >>

	  	ver <> prev_block_hash <> mrkl_root <> time <> bits <> nonce <> aux_pow_to_payload(block.aux_pow) <> tx_to_payload(block.transactions)
	end

	def from_io(payload) do
		#TODO: - recalc_hash_block and aux_pow should be considered
		case headers_from_io(payload) do
			{block, <<>>} ->
				{block, <<>>}
			{block, buf} ->
				{tx, buf} = tx_from_io(buf)
				{ block |> Map.put(:transactions, tx), buf }
		end
	end

	defp headers_from_io(buf) do
		<< chunk :: binary-size(80), buf :: binary >> = buf
		<< ver :: little-size(32), rest :: binary >> = chunk
		<< prev_block_hash :: binary-size(32), rest :: binary >> = rest
		<< mrkl_root :: binary-size(32), rest :: binary >> = rest
		<< time :: little-size(32), rest :: binary >> = rest
		<< bits :: little-size(32), rest :: binary >> = rest
		<< nonce :: little-size(32), _ :: binary >> = rest

		block = %Excoin.Block{
				:prev_block_hash => prev_block_hash,
				:mrkl_root => mrkl_root,
				:time => time,
				:bits => bits,
				:nonce => nonce,
				:ver =>	ver
			}

			{block, buf}
	end

	defp tx_from_io(buf) do
		{tx_size, buf} = Excoin.Protocol.unpack_var_int_from_io(buf)
		_tx_from_io([], buf, tx_size)
	end

	defp _tx_from_io(transactions, buf, 0), do: {transactions, buf}
	defp _tx_from_io(transactions, <<>>, _), do: {transactions, <<>>}
	defp _tx_from_io(transactions, buf, tx_size) do
		 {tx, remaining_buf} = Excoin.Transaction.from_io(buf)
		 transactions = transactions ++ [tx]
		_tx_from_io(transactions, remaining_buf, tx_size - 1)
	end

	defp recalc_block_hash(prev_block, mrkl_root, time, bits, nonce, ver) do
		prev_block = prev_block |> Binary.Ext.reverse |> Base.encode16(case: :lower)
		mrkl_root =  mrkl_root |> Binary.Ext.reverse |> Base.encode16(case: :lower)
		Excoin.Bitcoin.block_hash(prev_block, mrkl_root, time, bits, nonce, ver)
	end

	defp tx_to_payload(transactions) do
		case length transactions do
			0 -> <<>>
			len -> 
				tx_size = Excoin.Protocol.pack_var_int(len)
				_tx_to_payload(transactions, tx_size)
		end
	end

	defp _tx_to_payload([], bin), do: bin
	defp _tx_to_payload([head | tail], bin) do
		payload = Excoin.Transaction.to_payload(head)
		_tx_to_payload(tail, bin <> payload)
	end

	defp aux_pow_to_payload(aux_pow) do
		case aux_pow do
			"" -> <<>>
			ap -> 
				Excoin.AuxPow.to_payload(ap)
		end
	end

	def from_hash(map) do
		block = %Excoin.Block{
			:prev_block_hash => hex_reverse(map["prev_block"]),
			:mrkl_root => hex_reverse(map["mrkl_root"]),
			:time => map["time"],
			:bits => map["bits"],
			:nonce => map["nonce"],
			:ver =>	map["ver"]
		}

		add_optional_vals_from_hash(block, map)
	end

	defp add_optional_vals_from_hash(block, map) do
		aux_pow_from_hash(block, map["aux_pow"]) |> tx_from_hash(map["tx"])
	end

	defp aux_pow_from_hash(block, aux_pow) when is_nil(aux_pow), do: block
	defp aux_pow_from_hash(block, aux_pow) do
		Map.put(block, :aux_pow, Excoin.AuxPow.from_hash(aux_pow))
	end

	defp tx_from_hash(block, tx) when is_nil(tx), do: block
	defp tx_from_hash(block, tx) do
		Map.put(block, :transactions, Enum.map(tx, fn(t) -> Excoin.Transaction.from_hash(t) end))
	end

	def hex_reverse(binary) do
		Base.decode16!(binary, case: :lower) |> Binary.Ext.reverse
	end

end