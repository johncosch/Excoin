defmodule TransactionTest do

  use ExUnit.Case, async: true

  alias Excoin.Transaction, as: Transaction

  test "successful transaction from json serialization" do
    assert Transaction.from_json(File.read!("#{System.cwd}/test/fixtures/test_transaction.json")) |> Transaction.to_payload == File.read!("#{System.cwd}/test/fixtures/test_transaction.bin")
  end

  test "successful transaction from json serialization" do
  	assert Transaction.parse_data_from_io(File.read!("#{System.cwd}/test/fixtures/rawtx-01.bin")) == {Transaction.from_json(File.read!("#{System.cwd}/test/fixtures/rawtx-01.json")), <<>>}
  end

end