![](https://travis-ci.org/johncosch/Excoin.svg?branch=master) [![Coverage Status](https://coveralls.io/repos/johncosch/Excoin/badge.svg?branch=master&service=github)](https://coveralls.io/github/johncosch/Excoin?branch=master)

Excoin
======

### An Elixir library to help you interact with the Bitcoin protocol. 
This library is NOT ready for production, and could potentially lead to the loss of bitcoins if you decide to use it. That being said feel free to play around with it; I'd love to hear your feedback!

### Use

#### Block and Transaction Parsing
Serialize and deserialize inputs into managable bitcoin structs.
```
  # Parse from io
  { block, _ } = File.read!("path/to/file.bin") |> Excoin.Block.from_io
  
  # Parse from json
  block = File.read!("path/to/file.json") |> Excoin.Block.from_json
```
An example block struct might look like this:

```
%Excoin.Block{
  bits: 486604799,
  mrkl_root: <<152, 32, 81, 253, 30, 75, 167, 68, 187, 190, 104, 14, 31, 238, 20, 103, 123, 161, 163, 195, 84, 11, 247, 177, 205, 182, 6, 232, 87, 35, 62, 14>>,
  nonce: 2573394689,
  prev_block_hash: <<111, 226, 140, 10, 182, 241, 179, 114, 193, 166, 162, 70, 174, 99, 247, 79, 147, 30, 131, 101, 225, 90, 8, 156, 104, 214, 25, 0, 0, 0, 0, 0>>,
  time: 1231469665,
  ver: 1,
  transactions: [
    %Excoin.Transaction{
      lock_time: 0,
      ver: 1,
      in: 
        [
          %Excoin.TransactionIn{
            previous_output_hash: <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>,
            previous_output_index: 4294967295,
            script_sig: <<4, 255, 255, 0, 29, 1, 4>>,
            sequence: <<255, 255, 255, 255>>}
          ],
      out: 
        [
         %Excoin.TransactionOut{
            amount: 5000000000,
            script: <<65, 4, 150, 181, 56, 232, 83, 81, 156, 114, 106, 44, 145, 230, 30, 193, 22, 0, 174, 19, 144, 129, 58, 98, 124, 102, 251, 139, 231, 148, 123, 230, 60, 82, 218, 117, 137, 55, 149, 21, 212, 224, 166, 4, 248, 20, 23, 129, 230, 34, 148, 114, 17, 102, 191, 98, 30, 115, 168, 44, 191, 35, 66, 200, 88, 238, 172>>
          }
        ]
      }
    ],
  }
```
Blocks can also be serialized to payloads.
```
  payload = block |> Excoin.Block.to_payload
```

### Project goals
- Transaction / Block Parsing (mostly working)
- Script creation and verification (somewhat working)
- Message Handling
- Basic utility functions and handling (base58, ECC, etc.)
- Key handling and creation

### Contribution
There's lots to do so i'd welcome any contributions, whether it's pull requests or just some friendly advice!

### Credit
Thanks to the [bitcoin-ruby](https://github.com/lian/bitcoin-ruby) team for being such a great reference!
