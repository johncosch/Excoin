defmodule List.Ext do 
  @doc """
  Shift takes a list as the first param and the number of records that should be shifted.
  Returns a tuple with an list containing the values that were removed from the original list
  and the new list after those values were removed. 
  """

  def shift(list, num_to_remove) when num_to_remove > length(list) do
    {list, []}
  end

  def shift(list, num_to_remove \\ 1) when num_to_remove > 0 do
    _shift(list, num_to_remove)
  end

  defp _shift(list, num_to_remove) do
    {values, new_list} = _shift_value(list, [], num_to_remove)
  end

  defp _shift_value(list, values, 0), do: {values, list}

  defp _shift_value(list, values, num_values_remaining) do
    value = List.first(list)
    list = List.delete_at(list, 0)
    _shift_value(list, values ++ [value], num_values_remaining - 1)
  end

  @doc """
  Pop takes a list and optionally a number of elements to be popped. 
  Returns a tuple of the values that were popped and a new list with the last n elements removed.
  """

  def pop(list, n \\ 1) do
    {values, new_list} = Enum.reverse(list) |> shift(n)
    {values, Enum.reverse(new_list)}
  end


end