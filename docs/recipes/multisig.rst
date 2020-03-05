Multisignature Wallets
======================

The Following recipe of scripts demonstrate creating and performaing
transactions with a "2-of-3" multisig wallet.

.. code:: python

    #!/usr/bin/env python

    # This script shows you how to create a "2-of-3" multisig address.
    # It requires BIP32 private key file.

    import os
    import sys

    from pycoin.encoding.hexbytes import b2h
    from pycoin.symbols.btc import network


    def main():
        if len(sys.argv) != 2:
            print("usage: %s bip32_key_file" % sys.argv[0])
            sys.exit(-1)
        with open(sys.argv[1], "r") as f:
            hwif = f.readline().strip()

        # turn the bip32 text into a BIP32Node object
        BIP32_KEY = network.parse(hwif)

        # create three sec_keys (these are public keys, streamed using the SEC format)

        SEC_0 = BIP32_KEY.subkey_for_path("0/0/0").sec()
        SEC_1 = BIP32_KEY.subkey_for_path("0/1/0").sec()
        SEC_2 = BIP32_KEY.subkey_for_path("0/2/0").sec()

        public_key_sec_list = [SEC_0, SEC_1, SEC_2]

        # create the 2-of-3 multisig script
        # any 2 signatures can release the funds
        pay_to_multisig_script = network.contract.for_multisig(2, public_key_sec_list)

        # create a "2-of-3" multisig address_for_multisig
        the_address = network.address.for_p2s(pay_to_multisig_script)

        print("Here is your pay 2-of-3 address: %s" % the_address)

        print("Here is the pay 2-of-3 script: %s" % b2h(pay_to_multisig_script))
        print("The hex script should go into p2sh_lookup.hex")

        base_dir = os.path.abspath(os.path.dirname(sys.argv[1]))
        print("The three WIFs are written into %s as wif0, wif1 and wif2" % base_dir)
        for i in range(3):
            wif = BIP32_KEY.subkey_for_path("0/%d/0" % i).wif()
            with open(os.path.join(base_dir, "wif%d" % i), "w") as f:
                f.write(wif)


    if __name__ == '__main__':
        main()

.. code:: python

    #!/usr/bin/env python

    # This script creates a fake coinbase transaction to an address of your
    # choosing so you can test code that spends this output.

    import sys

    from pycoin.symbols.btc import network


    def main():
        if len(sys.argv) != 2:
            print("usage: %s address" % sys.argv[0])
            sys.exit(-1)

        # validate the address
        address = sys.argv[1]
        assert network.parse.address(address) is not None

        print("creating coinbase transaction to %s" % address)

        tx_in = network.tx.TxIn.coinbase_tx_in(script=b'')
        tx_out = network.tx.TxOut(50*1e8, network.contract.for_address(address))
        tx = network.tx(1, [tx_in], [tx_out])
        print("Here is the tx as hex:\n%s" % tx.as_hex())


    if __name__ == '__main__':
        main()

.. code:: python

    #!/usr/bin/env python

    # This script shows you how to spend coins from an incoming transaction.
    # It expects an incoming transaction in hex format a file ("incoming-tx.hex")
    # and a bitcoin address, and it spends the coins from the selected output of
    # in incoming transaction to the address you choose.

    # It does NOT sign the transaction. That's done by 4_sign_tx.py.

    import sys

    from pycoin.symbols.btc import network


    def main():
        if len(sys.argv) != 4:
            print("usage: %s incoming_tx_hex_filename tx_out_index new_address" % sys.argv[0])
            sys.exit(-1)

        with open(sys.argv[1], "r") as f:
            tx_hex = f.readline().strip()

        # get the spendable from the prior transaction
        tx = network.tx.from_hex(tx_hex)
        tx_out_index = int(sys.argv[2])
        spendable = tx.tx_outs_as_spendable()[tx_out_index]

        # make sure the address is valid
        payable = sys.argv[3]
        assert network.parse.address(payable) is not None

        # create the unsigned transaction
        tx = network.tx_utils.create_tx([spendable], [payable])

        print("here is the transaction: %s" % tx.as_hex(include_unspents=True))


    if __name__ == '__main__':
        main()

.. code:: python

    #!/usr/bin/env python

    import sys

    from pycoin.encoding.hexbytes import h2b
    from pycoin.symbols.btc import network


    def main():
        if len(sys.argv) != 4:
            print("usage: %s tx-hex-file-path wif-file-path p2sh-file-path" % sys.argv[0])
            sys.exit(-1)

        # get the tx
        with open(sys.argv[1], "r") as f:
            tx_hex = f.readline().strip()
        tx = network.tx.from_hex(tx_hex)

        # get the WIF
        with open(sys.argv[2], "r") as f:
            wif = f.readline().strip()
        assert network.parse.wif(wif) is not None

        # create the p2sh_lookup
        with open(sys.argv[3], "r") as f:
            p2sh_script_hex = f.readline().strip()
        p2sh_script = h2b(p2sh_script_hex)

        # build a dictionary of script hashes to scripts
        p2sh_lookup = network.tx.solve.build_p2sh_lookup([p2sh_script])

        # sign the transaction with the given WIF
        network.tx_utils.sign_tx(tx, wifs=[wif], p2sh_lookup=p2sh_lookup)

        bad_solution_count = tx.bad_solution_count()
        print("tx %s now has %d bad solution(s)" % (tx.id(), bad_solution_count))

        include_unspents = (bad_solution_count > 0)
        print("Here is the tx as hex:\n%s" % tx.as_hex(include_unspents=include_unspents))


    if __name__ == '__main__':
        main()
