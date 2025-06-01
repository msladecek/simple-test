import sys

name = input()
print(f"hello, {name}", file=sys.stdout)
print(f"ERROR: (don't worry, this is not a real error, {name})", file=sys.stderr)

sys.exit(101)
