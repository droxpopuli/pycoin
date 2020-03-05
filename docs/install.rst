Installation and Testing
========================

Install
-------

To install pycoin, run this command the terminal::

    $ pip install pycoin

If you don't have `pip <https://pip.pypa.io>`_ installed, check out
`this tutorial <http://docs.python-guide.org/en/latest/starting/installation/>`_.

To see if pycoin is correctly installed, try a command-line tool::

    $ ku 1

You should see several lines of output, describing information about the
bitcoin key corresponding to private key 1.

Testing
-------

Although pycoin has no dependencies, if you want to hack on it, it's
recommended that you to install tox to keep your personal test
environment separate from the testing environments.

$ pip install tox

A tox configuration provides the following interpretters for tests and
builds:

-  ``py27``\ \*
-  ``py34``
-  ``py35``\ \*
-  ``py36``\ \*
-  ``py37``\ \*
-  ``py38``
-  ``pypy2``\ \*
-  ``pypy27``\ \*
-  ``pypy3``\ \*
-  ``pypy35*``

\*= Supported/Pass Required for CI Pass

The following support environments are also provided for local and CI
use (unless otherwise specified, run on python 3.7):

-  ``lint``: Code Linting (flake8, pydocstyle, and pylint) and Static Type checking (mypy)
-  ``mut-test``: Mutation Testing (mut.py)
-  ``docs``: Documentation Generation (Sphinx)

To list all testing and support environments, simply run:

::

    $ tox -a -v
    using tox.ini: /home/user/pycoin/tox.ini (pid 16086)
    using tox-3.14.5 from /home/user/.local/lib/python3.6/site-packages/tox/__init__.py (pid 16086)
    default environments:
    py27     -> Build and test the codebase in the py27 interpreter.
    py34     -> Build and test the codebase in the py34 interpreter.
    py35     -> Build and test the codebase in the py35 interpreter.
    py36     -> Build and test the codebase in the py36 interpreter.
    py37     -> Build and test the codebase in the py37 interpreter.
    py38     -> Build and test the codebase in the py38 interpreter.
    pypy2    -> Build and test the codebase in the pypy2 interpreter.
    pypy27   -> Build and test the codebase in the pypy27 interpreter.
    pypy3    -> Build and test the codebase in the pypy3 interpreter.
    pypy35   -> Build and test the codebase in the pypy35 interpreter.
    lint     -> Lint code and docstrings with flake8 and pylint. Do Static Type check with mypy. Generates Reports.
    docs     -> Run sphinx-build to build HTML documentation.
    
    additional environments:
    mut-test -> Run mut.py testing on the code base.

To run all testing and support environments, simply run:

::

    $ tox

To run a particular environment, run:

::

    $ tox -e [environment]

To run just a subset of tests for features under development we use
positional arguments in tox which specify the path to tests for all
environments:

::

    $ tox -e py37 -- tests/scripts_test.py
