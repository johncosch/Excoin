defmodule Excoin.Script do

  alias Excoin.Opcodes, as: Opcodes 

  @op_pushdata0 Opcodes.code(:OP_PUSHDATA0)
  @op_pushdata1 Opcodes.code(:OP_PUSHDATA1)
  @op_pushdata2 Opcodes.code(:OP_PUSHDATA2)
  @op_pushdata4 Opcodes.code(:OP_PUSHDATA4)

  def as_string(chunks) do
    _as_string(chunks, "", 0)
  end

  defp _as_string([], string, _), do: string
  defp _as_string([head | tail], string, index) do
    if index != 0 do
      string = string <> " "
    end
    val = as_string_case(head)
    _as_string(tail, string <> val, index + 1)
  end

  defp as_string_case(value) when is_number(value) do
    case Opcodes.parse_binary(value) do
      {:ok, val} -> val
      {:error} -> "(opcode-#{value})"
    end 
  end

  defp as_string_case(value) when is_tuple(value) do
    {val, push_data, pd_length} = value
    "#{push_data}:#{pd_length}:" <>  Base.encode16(val, case: :lower) 
  end

  defp as_string_case(value) when is_binary(value) do
    Base.encode16(value, case: :lower) 
  end

  def build(input_script), do: parse(input_script)

  def parse(bytes) do
    chunks = _parse(:binary.bin_to_list(bytes), [], bytes)
  end

  defp _parse([], chunks, _), do: chunks 
  defp _parse(program, chunks, bytes)  do
    {values, program} = List.Ext.shift(program)
    case List.first(values) |> append_chunk(program, chunks) do
      {:ok, program, chunks} ->
        _parse(program, chunks, bytes)
      {:error, program, chunks} ->
        chunks = _save_invalid_push_data(chunks, bytes)
        _parse(program, chunks, bytes)
    end
  end

  defp append_chunk(opcode, program, chunks) when opcode <= 0  do
   {:ok, program, chunks ++ [opcode]}
  end

  defp append_chunk(opcode, program, chunks) when opcode < @op_pushdata1 do
    len = opcode
    tmp = List.first(program)
    {chunks, program} = shift_to_chunks(program, chunks, len)
    if len == 1 && tmp && tmp <= 22 do
      {:ok, program, append_meta_tuple(chunks, @op_pushdata0, len)}
    else
      {last_chunk_status(chunks, len), program, chunks}
    end
  end

  defp append_chunk(opcode, program, chunks) when opcode == @op_pushdata1 do
    {vals, program} = List.Ext.shift(program)
    len = List.first(vals)
    {chunks, program} = shift_to_chunks(program, chunks, len)
    unless len > @op_pushdata1 && len <= 0xff do
      {:ok, program, append_meta_tuple(chunks, @op_pushdata1, len)}
    else
      {last_chunk_status(chunks, len), program, chunks}
    end
  end

  defp append_chunk(opcode, program, chunks) when opcode == @op_pushdata2 do
    {vals, program} = List.Ext.shift(program, 2)
    bin_val = :binary.list_to_bin(vals)
    << len :: little-size(16), _ :: binary >> = bin_val
    {chunks, program} = shift_to_chunks(program, chunks, len)
    unless len > 0xff && len <= 0xffff do
      {:ok, program, append_meta_tuple(chunks, @op_pushdata2, len)}
    else
      {last_chunk_status(chunks, len), program, chunks}
    end
  end

  defp append_chunk(opcode, program, chunks) when opcode == @op_pushdata4 do
    {vals, program} = List.Ext.shift(program, 4)
    bin_val = :binary.list_to_bin(vals)
    << len :: little-size(16), _ :: binary >> = bin_val
    {chunks, program} = shift_to_chunks(program, chunks, len)
    unless len > 0xffff do
      {:ok, program, append_meta_tuple(chunks, @op_pushdata0, len)}
    else
     {last_chunk_status(chunks, len), program, chunks}
    end
  end

  defp append_chunk(opcode, program, chunks) do
    {:ok, program, chunks ++ [opcode]}
  end

  defp shift_to_chunks(program, chunks, len) do
    {values, program} = List.Ext.shift(program, len)
    values = :binary.list_to_bin(values)
    {chunks ++ [values], program}
  end

  defp append_meta_tuple(chunks, pushdata, len) do
    {[last], chunks} =  List.Ext.pop(chunks)
    chunks ++ [{last, pushdata, len}]
  end

  defp last_chunk_status(chunks, len) do
    if len != List.last(chunks) |> byte_size do
        :error
    else
        :ok 
    end
  end

  defp _save_invalid_push_data(chunks, bytes) do
    {_, chunks} = List.Ext.pop(chunks)
    chunks = chunks ++ [bytes]
    append_meta_tuple(chunks, Opcodes.code(:OP_PUSHDATA_INVALID), byte_size(bytes))
  end

  def binary_from_string(script_string) do
    _binary_from_string(String.split(script_string), "")
  end

  defp _binary_from_string([], buf), do: buf
  defp _binary_from_string([head | tail], buf) do
    parse_string_head(head) |> binary_from_result(tail, buf)
  end

  defp parse_string_head(head) do
    case Opcodes.parse_string(head) do
      {:ok, opcode} -> {:ok, <<opcode>>}
      _ -> 
      match_string_pattern(head) 
    end
  end

  defp binary_from_result({:error, data}, _, _), do: data
  defp binary_from_result(:ok, tail, buf), do: _binary_from_string(tail, buf) 
  defp binary_from_result({:ok, data}, tail, buf) do
    val = case data do
            data when is_number(data) -> <<data>> #bitcoin-ruby uses ssl bignum here -- not sure if it's needed
             _ -> data
          end

    _binary_from_string(tail, buf <> val)
  end

  defp match_string_pattern(head) do
    cond do
      head =~ ~r/OP_PUSHDATA/ -> :ok

      head =~ ~r/OP_(.+)$/ -> raise "Script opcode error." #make custom error 

      match = Regex.run(~r/\(opcode\-(\d+)/, head) ->
        {int, _} = match |> Enum.at(1) |> Integer.parse
        {:ok, int}

      head == "(opcode" -> :ok

      match = Regex.run(~r/^(\d+)\)/, head) ->
        {int, _} = match |> Enum.at(1) |> Integer.parse
        {:ok, int}

      match = Regex.run(~r/(\d+):(\d+):(.+)?/, head) ->
       [_, pushdata, len, data] = match
       {len, _} = Integer.parse(len)
       {pushdata, _} = Integer.parse(pushdata)
       pack_pushdata_align(pushdata, len, Base.decode16!(data, case: :lower))

      true -> 
        {:ok, Base.decode16!(head, case: :lower) |> pack_pushdata}
    end
  end

  defp pack_pushdata_align(76, len, data) do
    {:ok, <<76>> <> <<len>> <> data}
  end

  defp pack_pushdata_align(77, len, data) do
    new_len = << len :: little-size(16) >>
    {:ok, <<77>> <> new_len <> data}
  end

  defp pack_pushdata_align(78, len, data) do
    new_len = << len :: little-size(32) >>
    {:ok, <<78>> <> new_len <> data}
  end

  defp pack_pushdata_align(238, _, data), do: {:error, data}

  defp pack_pushdata_align(_, len, data), do: {:ok, <<len>> <> data}
  
  defp pack_pushdata(data), do: _pack_pushdata(byte_size(data)) <> data

  defp _pack_pushdata(size) when size < 76, do: <<size>>
  defp _pack_pushdata(size) when size <= 0xff, do: <<76>> <> <<size>>
  defp _pack_pushdata(size) when size <= 0xffff do
    byte_order = << size :: little-size(16) >>
    <<77>> <> byte_order
  end

  defp _pack_pushdata(size) do
    byte_order = << size :: little-size(32) >>
    <<77>> <> byte_order
  end

end