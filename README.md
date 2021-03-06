
pycoin -- Python Cryptocoin Utilities
=====================================

[![Status](https://travis-ci.com/droxpopuli/pycoin.svg?branch=master)](https://travis-ci.com/droxpopuli/pycoin)
[![codecov](https://codecov.io/gh/droxpopuli/pycoin/branch/master/graph/badge.svg)](https://codecov.io/gh/droxpopuli/pycoin)
![Code Quality](https://github.com/droxpopuli/pycoin/workflows/Code%20Quality/badge.svg)
![Security Scan](https://github.com/droxpopuli/pycoin/workflows/Security%20Scan/badge.svg)


![GitHub](https://img.shields.io/github/license/droxpopuli/pycoin)
[![Issues](http://img.shields.io/github/issues/droxpopuli/pycoin.svg)](https://github.com/droxpopuli/pycoin/issues)
[![Documentation Status](https://readthedocs.org/projects/pycoin-ci/badge/?version=latest)](https://pycoin-ci.readthedocs.io/en/latest/?badge=latest)
[![Chat](http://img.shields.io/badge/gitter-droxpopuli/pycoin-purple.svg)](https://gitter.im/droxpopuli/pycoin-ci)


The pycoin library implements many utilities useful when dealing with bitcoin and some bitcoin-like
alt-coins. It has been tested with Python 2.7, 3.6 and 3.7.

See also [pycoinnet](http://github.com/richardkiss/pycoinnet/) for a library that speaks the bitcoin protocol.

Documentation at [readthedocs](http://pycoin.readthedocs.io/en/latest/)

Discussion at [zulipchat](https://pycoin.zulipchat.com/)

Networks
--------

As of 0.9, pycoin supports many coins to various degrees via the "network" class. Since specifications
vary based on the network (for example, bitcoin mainnet addresses start with a "1", but testnet
addresses start with an "m" or "n"), all API descends from a network object. Everything related to a
particular network is scoped under this class.

Bitcoin has the highest level of support, including keys, transactions, validation of signed transactions, and
signing unsigned transactions, including partial signing of multisig transactions. These are in level of
increasing complexity, so features for other coins will likely be supported in that order.

There are two main ways to get a network:

```python
from pycoin.symbols.btc import network
```

OR

```python
from pycoin.networks.registry import network_for_netcode
network = network_for_netcode("BTC")
```

Basic Keys
----------

You can create a private key and get the corresponding address.

```python
from pycoin.symbols.btc import network

key = network.keys.private(secret_exponent=1)  # this is a terrible key because it's very guessable
print(key.wif())
print(key.sec())
print(key.address())
print(key.address(is_compressed=False))

same_key = network.parse.private(key.wif())
print(same_key.address())
```

BIP32 Keys
----------

You can create a BIP32 key.

```python
key = network.keys.bip32_seed(b"foo")  # this is a terrible key because it's very guessable
print(key.hwif(as_private=1))
print(key.hwif())
print(key.wif())
print(key.sec())
print(key.address())
```

You can parse a BIP32 key.

```python
key = network.parse.bip32("xprv9s21ZrQH143K31AgNK5pyVvW23gHnkBq2wh5aEk6g1s496M"
      "8ZMjxncCKZKgb5jZoY5eSJMJ2Vbyvi2hbmQnCuHBujZ2WXGTux1X2k9Krdtq")
print(key.hwif(as_private=1))
print(key.hwif())
print(key.wif())
print(key.sec())
print(key.address())
```

WARNING: be extremely careful giving out public wallet keys. If someone has access to a private wallet key P, of
course they have access to all descendent wallet keys of P. But if they also have access to a public wallet key K
where P is a subkey of K, you can actually work your way up the tree to determine the private key that corresponds
to the public wallet key K (unless private derivation was used at some point between the two keys)! Be sure you
understand this warning before giving out public wallet keys!

Transactions
------------

The package installs a command-line utility `tx`: the Swiss Army knife of transaction utilities.

Services
--------

When signing or verifying signatures on a transaction, the source transactions are generally needed. If you set two
environment variables in your `.profile` like this:

```bash
    PYCOIN_CACHE_DIR=~/.pycoin_cache
    PYCOIN_BTC_PROVIDERS="blockchain.info blockexplorer.com chain.so"
    export PYCOIN_CACHE_DIR PYCOIN_BTC_PROVIDERS
    export PYCOIN_XTN_PROVIDERS="blockchain.info"  # For Bitcoin testnet
```

and then `tx` will automatically fetch transactions from the web sites listed and cache the results in
`PYCOIN_CACHE_DIR` when they are needed.

(The old syntax with `PYCOIN_SERVICE_PROVIDERS` is deprecated.)

The module pycoin.services includes two functions `spendables_for_address`, `get_tx_db` that look at the
environment variables set to determine which web sites to use to fetch the underlying information. The sites are
polled in the order they are listed in the environment variable.

Blocks
------

The command-line utility `block` will dump a block in a human-readable format. For further information, look at
`pycoin.block`, which includes the object `Block` which will parse and stream the binary format of a block.

ECDSA Signing and Verification
------------------------------

The module `pycoin.ecdsa` deals with ECDSA keys directly. Important structures include:

- the `secret_exponent` (a large integer that represents a private key)
- the `public_pair` (a pair of large integers x and y that represent a public key)

There are a handful of functions: you can do things like create a signature, verify a signature, generate the public
pair from the secret exponent, and flush out the public pair from just the x value (there are two possible values
for y of opposite even/odd parity, so you include a flag indicating which value for y you want).

The `pycoin.ecdsa.native` module looks for both OpenSSL and libsecp256k1 (with hints from
`PYCOIN_LIBCRYPTO_PATH` and `PYCOIN_LIBSECP256K1_PATH`) and calls out to these libraries if
they are present to accelerate ecdsa operations. Set `PYCOIN_NATIVE` to `openssl`,
`secp256k1` or `none` to tweak this.

Example:

```bash
$ PYCOIN_NATIVE=openssl
$ export PYCOIN_NATIVE
```

Donate
------

Want to donate? Feel free. Send to 1KissZi1jr5eD7Rb9fepRHiS4ur2hc9PwS.
I'm also available for bitcoin consulting... him@richardkiss.com.

Outline of Features
-------------------

- [x] Local Testing (tox)
    - [x] Runnable in Container (docker)
    - [x] Linting (flake8, pylint)
        - [x] TXT/HTML Report
    - [x] Static Type Checks (mypy)
        - [x] HTML Report
    - [x] Automated Testing (py.test)
        - [x] Py2.7/3.4/3.5/3.6/3.7/3.8/3.8-dev
        - [x] Pypy2/2.7/3/3.5
        - [x] HTML Report
        - [x] Code Coverage (coverage)
    - [x] Documentation Generation (sphinx)
        - [x] Automated Hosting (ReadTheDocs)
    - [x] CHANGELOG Generation (gitchangelog)
    - [x] Test Analysis/Code Mutation (mut.py)
    - [x] Deploy macro of lint, py27, py37, docs, and changelog for a single env with artifacts

- [x] Automated CI/CD (travis-ci)
    - [x] Build Stages
        - [x] Static Analysis Stage
            - [x] lint
            - [x] typing
        - [x] Testing Stage
            - [x] py{27, 34, 35, 36, 37, 38, 38-dev}
            - [x] pypy{2, 27, 3, 35}
        - [x] Deployment Checks Stage
            - [x] docs
            - [x] changelog
        - [x] Deploy Stage
            - [x] Runs only on tagged commits
        - [x] Advanced Testing Stage
            - [x] mutate
    - [x] Submit code Coverage on successful runs (codecov)
    - [x] Automated Deployment (Github Releases)
        - [x] Runs only on successful runs on tagged commits
    - [x] Chatroom Status Webhook (gitter)
 
- [x] Repo Configuration and Automations (Github Actions)
    - [x] Readme Badges
    - [x] Documentation Cleanup
    - [x] Template
        - [x] Commit
        - [x] Issues
        - [x] Pull Request
    - [x] Message on First:
        - [x] Issue
        - [x] Pull Request
    - [x] Pull Request Title Linter
    - [x] CI on PRs and Master (Github Actions)
        - [x] Linting (black, pylint, isort, pycodestyle, flake8, mypy)
        - [x] Security Checks (pycharm-security)
