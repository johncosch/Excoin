defmodule ScriptTest do
  use ExUnit.Case, async: true

  alias Excoin.Script, as: Script

  def test_scripts do
    [
      {
        "410411db93e1dcdb8a016b49840f8c53bc1eb68a382e97b1482ecad7b148a6909a5cb2e0eaddfb84ccf9744464f82e160bfa9b8b64f9d4c03f999b8643f656b412a3ac",
        "0411db93e1dcdb8a016b49840f8c53bc1eb68a382e97b1482ecad7b148a6909a5cb2e0eaddfb84ccf9744464f82e160bfa9b8b64f9d4c03f999b8643f656b412a3 OP_CHECKSIG"
      },
      {
        "47304402204e45e16932b8af514961a1d3a1a25fdf3f4f7732e9d624c6c61548ab5fb8cd410220181522ec8eca07de4860a4acdd12909d831cc56cbbac4622082221a8768d1d0901",
         "304402204e45e16932b8af514961a1d3a1a25fdf3f4f7732e9d624c6c61548ab5fb8cd410220181522ec8eca07de4860a4acdd12909d831cc56cbbac4622082221a8768d1d0901"
      },
      {
        "76a91433e81a941e64cda12c6a299ed322ddbdd03f8d0e88ac",
        "OP_DUP OP_HASH160 33e81a941e64cda12c6a299ed322ddbdd03f8d0e OP_EQUALVERIFY OP_CHECKSIG"
      },
      {
        "4c0411db93e1dcdb8a016b49840f8c53bc1eb68a382e97b1482ecad7b148a6909a5cb2e0eaddfb84ccf9744464f82e160bfa9b8b64f9d4c03f999b8643f656b412a3ac",
        "76:4:11db93e1 (opcode-220) (opcode-219) (opcode-138) 6b 238:67:4c0411db93e1dcdb8a016b49840f8c53bc1eb68a382e97b1482ecad7b148a6909a5cb2e0eaddfb84ccf9744464f82e160bfa9b8b64f9d4c03f999b8643f656b412a3ac"
      }
    ]
  end

  test "serialization" do
    #TODO: write tests for later opcode pushdata conditions -- these become very long
    Enum.each test_scripts, fn({script, string}) -> 
      assert Base.decode16!(script, case: :lower) |> Script.build |> Script.as_string == string
      assert Script.binary_from_string(string) |> Base.encode16(case: :lower) == script
    end
  end

end