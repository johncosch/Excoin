defmodule Excoin.Opcodes do

	#TODO:- finish codes
	def code(:OP_0), do: 0
	def code(:OP_FALSE), do: 0
	def code(:OP_1), do: 81
	def code(:OP_TRUE), do: 81
	def code(:OP_2), do: 0x52
	def code(:OP_3), do: 0x53
	def code(:OP_4), do: 0x54
	def code(:OP_5), do: 0x55
	def code(:OP_6), do: 0x56
	def code(:OP_7), do: 0x57
	def code(:OP_8), do: 0x58
	def code(:OP_9), do: 0x59
	def code(:OP_10), do: 0x5a
	def code(:OP_11), do: 0x5b
	def code(:OP_12), do: 0x5c
	def code(:OP_13), do: 0x5d
	def code(:OP_14), do: 0x5e
	def code(:OP_15), do: 0x5f
	def code(:OP_16), do: 0x60


	def codes do
		 %{
			:OP_0 => 0,
			:OP_FALSE => 0,
	  	:OP_1 => 81,
	  	:OP_TRUE => 81,
	  	:OP_2 => 0x52,
	  	:OP_3 => 0x53,
	  	:OP_4 => 0x54,
	  	:OP_5 => 0x55,
	  	:OP_6 => 0x56,
	  	:OP_7 => 0x57,
	  	:OP_8 => 0x58,
	  	:OP_9 => 0x59,
	  	:OP_10 => 0x5a,
	  	:OP_11 => 0x5b,
	  	:OP_12 => 0x5c,
	  	:OP_13 => 0x5d,
	  	:OP_14 => 0x5e,
	  	:OP_15 => 0x5f,
	  	:OP_16 => 0x60,
	  	:OP_PUSHDATA0 => 0,
	  	:OP_PUSHDATA1 => 76,
	  	:OP_PUSHDATA2 => 77,
	  	:OP_PUSHDATA4 => 78,
	  	:OP_PUSHDATA_INVALID => 238,
	  	:OP_NOP => 97,
	  	:OP_DUP => 118,
	  	:OP_HASH160 => 169,
	  	:OP_EQUAL => 135,
	  	:OP_VERIFY => 105,
	  	:OP_EQUALVERIFY => 136,
	  	:OP_CHECKSIG => 172,
	  	:OP_CHECKSIGVERIFY => 173,
	  	:OP_CHECKMULTISIG => 174,
	  	:OP_CHECKMULTISIGVERIFY => 175,
	  	:OP_TOALTSTACK => 107,
	  	:OP_FROMALTSTACK => 108,
	  	:OP_TUCK => 125,
	  	:OP_SWAP => 124,
	  	:OP_BOOLAND => 154,
	  	:OP_ADD => 147,
	  	:OP_SUB => 148,
	  	:OP_GREATERTHANOREQUAL => 162,
	  	:OP_DROP => 117,
	  	:OP_HASH256 => 170,
	  	:OP_SHA256 => 168,
	  	:OP_SHA1 => 167,
	  	:OP_RIPEMD160 => 166,
	  	:OP_NOP1 => 176,
	  	:OP_NOP2 => 177,
	  	:OP_NOP3 => 178,
	  	:OP_NOP4 => 179,
	  	:OP_NOP5 => 180,
	  	:OP_NOP6 => 181,
	  	:OP_NOP7 => 182,
	  	:OP_NOP8 => 183,
	  	:OP_NOP9 => 184,
	  	:OP_NOP10 => 185,
	  	:OP_CODESEPARATOR => 171,
	  	:OP_MIN => 163,
	  	:OP_MAX => 164,
	  	:OP_2OVER => 112,
	  	:OP_2ROT => 113,
	  	:OP_2SWAP => 114,
	  	:OP_IFDUP => 115,
	  	:OP_DEPTH => 116,
	  	:OP_1NEGATE => 79,
	  	:OP_WITHIN => 165,
	  	:OP_NUMEQUAL => 156,
	  	:OP_NUMEQUALVERIFY => 157,
	  	:OP_LESSTHAN => 159,
	  	:OP_LESSTHANOREQUAL => 161,
	  	:OP_GREATERTHAN => 160,
	  	:OP_NOT => 145,
	  	:OP_0NOTEQUAL => 146,
	  	:OP_ABS => 144,
	  	:OP_1ADD => 139,
	  	:OP_1SUB => 140,
	  	:OP_NEGATE => 143,
	  	:OP_BOOLOR => 155,
	  	:OP_NUMNOTEQUAL => 158,
	  	:OP_RETURN => 106,
	  	:OP_OVER => 120,
	  	:OP_IF => 99,
	  	:OP_NOTIF => 100,
	  	:OP_ELSE => 103,
	  	:OP_ENDIF => 104,
	  	:OP_PICK => 121,
	  	:OP_SIZE => 130,
	  	:OP_VER => 98,
	  	:OP_ROLL => 122,
	  	:OP_ROT => 123,
	  	:OP_2DROP => 109,
	  	:OP_2DUP => 110,
	  	:OP_3DUP => 111,
	  	:OP_NIP => 119,
	  	:OP_CAT => 126,
	  	:OP_SUBSTR => 127,
	  	:OP_LEFT => 128,
	  	:OP_RIGHT => 129,
	  	:OP_INVERT => 131,
	  	:OP_AND => 132,
	  	:OP_OR => 133,
	  	:OP_XOR => 134,
	  	:OP_2MUL => 141,
	  	:OP_2DIV => 142,
	  	:OP_MUL => 149,
	  	:OP_DIV => 150,
	  	:OP_MOD => 151,
	  	:OP_LSHIFT => 152,
	  	:OP_RSHIFT => 153,
	  	:OP_INVALIDOPCODE => 0xff
	  } |> Map.put(String.to_atom("0"), 0) |> Map.put(String.to_atom("1"), 81)
  end

  def opcodes_alias() do
  	opcodes = codes
  	%{
  		:OP_TRUE  => opcodes[:OP_1],
    	:OP_FALSE => opcodes[:OP_0],
    	:OP_EVAL => opcodes[:OP_NOP1],
    	:OP_CHECKHASHVERIFY => opcodes[:OP_NOP2]
  	}
  end

  def op_2_16() do
  	Enum.to_list 82..96
  end

  def parse_binary(i) do
  	opcodes = reverse_codes_map |> _replace_binary_values(op_2_16, 0)
  	if Map.has_key?(opcodes, i) do
  		{:ok, opcodes[i]}
  	else
  		{:error}
  	end
  end

  defp _replace_binary_values(opcodes, [], _), do: opcodes
  defp _replace_binary_values(opcodes, [head | tail], index) do
  	opcodes = Map.put(opcodes, head, to_string(index + 2))
  	_replace_binary_values(opcodes, tail, index + 1)
  end


  def parse_string(i) do
  	opcodes = Map.merge(codes, opcodes_alias) |>
  						_replace_values(2) |>
  						_remove_values([1,2,4])

		if Map.has_key?(opcodes, String.to_atom(i)) do
			{:ok, opcodes[String.to_atom(i)]}
		else
			{:error}
		end
  end

  defp _replace_values(opcodes, index) when index > 16, do: opcodes
  defp _replace_values(opcodes, index) do
  	opcodes = Map.put(opcodes, String.to_atom("OP_#{index}"), Enum.at(op_2_16, index - 2))
  	opcodes = Map.put(opcodes, String.to_atom("#{index}"), Enum.at(op_2_16, index - 2))
  	_replace_values(opcodes, index + 1)
  end

  defp _remove_values(opcodes, []), do: opcodes
  defp _remove_values(opcodes, [head | tail]) do
  	opcodes = Map.delete(opcodes, String.to_atom("OP_PUSHDATA#{head}")) 
  	_remove_values(opcodes, tail)
  end

  defp reverse_codes_map() do
  	reversed_tuple = codes |>
  	Map.to_list |> 
  	Enum.map fn({k, v}) -> {v, Atom.to_string(k)} end 

  	Enum.into(reversed_tuple, %{}) 
  end

end