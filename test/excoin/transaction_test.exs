defmodule TransactionTest do

  use ExUnit.Case, async: true

  alias Excoin.Transaction, as: Transaction

  test "successfull transaction serialization" do
    assert Transaction.from_json(File.read!("#{System.cwd}/test/fixtures/test_transaction.json")) |> Transaction.to_payload == File.read!("#{System.cwd}/test/fixtures/test_transaction.bin")
  end
end