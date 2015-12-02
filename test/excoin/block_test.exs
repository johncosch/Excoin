defmodule BlockTest do

  use ExUnit.Case, async: true

  alias Excoin.Block, as: Block

  test "successful block from json serialization" do
    assert Block.from_json(File.read!("#{System.cwd}/test/fixtures/test_block_0.json")) |> Block.to_payload == File.read!("#{System.cwd}/test/fixtures/test_block_0.bin")
  end

  test "successful block from io serialization" do
  	assert File.read!("#{System.cwd}/test/fixtures/test_block_0.bin") |> Block.from_io == {Block.from_json(File.read!("#{System.cwd}/test/fixtures/test_block_0.json")), <<>>}
  end
end