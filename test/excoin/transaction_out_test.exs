defmodule TransactionOutTest do
  use ExUnit.Case, async: true

  alias Excoin.TransactionOut, as: TransactionOut

  test "transaction_out" do
    hash = %{"amount" => 12345, "scriptPubKey" => "OP_DUP OP_HASH160 ee8c671fd02fd0812c358e00830258de835466ff OP_EQUALVERIFY OP_CHECKSIG"} 
    assert TransactionOut.from_hash(hash) |> TransactionOut.to_payload == Base.decode16!("39300000000000001976a914ee8c671fd02fd0812c358e00830258de835466ff88ac", case: :lower)
  end


end