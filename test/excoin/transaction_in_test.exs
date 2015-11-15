defmodule TransactionInTest do
  use ExUnit.Case, async: true

  alias Excoin.TransactionIn, as: TransactionIn


  test "transaction_out" do
    payload = "71c06e0639dbe6bc35e6f948da4874ae69d9d91934ec7c5366292d0cbd5f97b0010000008a47304402200117cdd3ec6259af29acea44db354a6f57ac10d8496782033f5fe0febfd77f1b02202ceb02d60dbb43e6d4e03e5b5fbadc031f8bbb3c6c34ad307939947987f600bf01410452d63c092209529ca2c75e056e947bc95f9daffb371e601b46d24377aaa3d004ab3c6be2d6d262b34d736b95f3b0ef6876826c93c4077d619c02ebd974c7facdffffffff"
    prev_out_hash = "b0975fbd0c2d2966537cec3419d9d969ae7448da48f9e635bce6db39066ec071"
    prev_out_index = 1
    script_sig = "304402200117cdd3ec6259af29acea44db354a6f57ac10d8496782033f5fe0febfd77f1b02202ceb02d60dbb43e6d4e03e5b5fbadc031f8bbb3c6c34ad307939947987f600bf01 0452d63c092209529ca2c75e056e947bc95f9daffb371e601b46d24377aaa3d004ab3c6be2d6d262b34d736b95f3b0ef6876826c93c4077d619c02ebd974c7facd"

    #todo - test different permutations
    test_map_0 = %{"prev_out" => %{"hash" => prev_out_hash, "n" => prev_out_index}, "scriptSig" => script_sig}
    assert Excoin.TransactionIn.from_hash(test_map_0) |> Excoin.TransactionIn.to_payload == Base.decode16!(payload, case: :mixed)
  end

end