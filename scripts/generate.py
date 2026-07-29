import random
from itertools import chain

def generate_inputs(filename):
    options = []

    for ascii_val in chain(range(48, 58), range(65, 71)):
        options.append(chr(ascii_val))

    with open(filename, "w") as f:
        for _ in range(200):
            for _ in range(2):
                digit = random.choice(options)
                f.write(digit)
            
            f.write("\n")

if __name__ == "__main__":
    generate_inputs("data/inputs.txt")