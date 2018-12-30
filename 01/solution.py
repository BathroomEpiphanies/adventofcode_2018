import sys

change = [int(l.strip()) for l in sys.stdin.readlines()]

print( "Sum of changes: %d" % (sum(change)) )

seen = set()
frequency = 0

while True:
    for c in change:
        frequency += c
        if frequency in seen:
            print( "Found duplicate: %d" % (frequency) )
            sys.exit(0)
        else:
            seen.add(frequency)
