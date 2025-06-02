# simple-test

A language agnostic testing tool.

### Usage

Create a test file `<name>`.

Call `simple-test` with one or more test files specified as command line arguments.

    $ simple-test myscript.py yourscript.pl theirexecutable

By default, the test file itself will be executed, so you must make sure it is executable.

    $ chmod +x myscript.py
    $ cat myscript.py
    #!/usr/bin/env python3
    print("hello world!")

The default can be overriden by creating a `<name>.cmd` file, `$filename` will be substituted with with the actual filename.

    $ cat myscript
    print("hello world")

    $ cat myscript.cmd
    python $filename

By default, simple-test only tests that the exit code of the tested program will be non-zero.
This can be overridden by providing a `<name>.exit` file which contains the expected exit code.

    $ cat myscript.py
    #!/usr/bin/env python3
    import sys
    sys.exit(100)

    $ cat myscript.py.exit
    100

The expected output of the program can be specified by providing the `<name>.stdout` and/or `<name>.stderr` files.

    $ cat myscript.py
    #!/usr/bin/env python3
    print("hello world!")

    $ cat myscript.py.stdout
    hello world

Similarly, standard input which should be sent to the tested program can be provided with a `<name>.stdin` file.

    $ cat myscript.py
    #!/usr/bin/env python3
    name = input()
    print(f"hello {name}!")

    $ cat myscript.py.stdin
    dear friend

    $ cat myscript.py.stdout
    hello dear friend!

And that's it!
