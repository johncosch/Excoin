defmodule Excoin.Bitcoin do 

	def block_hash(prev_block, mrkl_root, time, bits, nonce, ver) do
		nonce = nonce |> Integer.to_string(16) |> String.rjust(8, 48) |> String.downcase
		bits = bits |> Integer.to_string(16) |> String.rjust(8, 48) |> String.downcase
		time = time |> Integer.to_string(16) |> String.rjust(8, 48) |> String.downcase
		prev_block = prev_block |> String.rjust(64, 48)
		mrkl_root = mrkl_root |> String.rjust(64, 48)
		ver = ver |> Integer.to_string(16) |> String.rjust(8, 48) |> String.downcase

		nonce <> bits <> time <> mrkl_root <> prev_block <> ver |> bitcoin_hash
	end

	def bitcoin_hash(hex) do
		digest = :crypto.hash(:sha256, hex) |>
				 			Base.encode16(case: :lower) |>
				 			Binary.Ext.reverse 

		:crypto.hash(:sha256, digest) |>
		Binary.Ext.reverse |> 
		Base.encode16(case: :lower)
	end

end