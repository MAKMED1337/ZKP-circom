from math import lcm
import json

NUMBER_OF_BLOCKS = 32
BLOCK_SIZE = 64


def encode(n: int) -> list[int]:
    initial_n = n

    res = [0] * NUMBER_OF_BLOCKS
    for i in range(NUMBER_OF_BLOCKS):
        res[i] = n & ((1 << BLOCK_SIZE) - 1)
        n >>= BLOCK_SIZE

    if n != 0:
        raise ValueError(f"Cannot encode {initial_n}, it is too big")
    return res


def calculate_sig(p: int, q: int, e: int, m: int) -> int:
    n = p * q
    lam = lcm(p - 1, q - 1)
    d = pow(e, -1, lam)
    return pow(m, d, n)


def generate_input(p: int, q: int, m: int, e: int = 65537) -> None:
    n = p * q
    s = calculate_sig(p, q, e, m)
    j = {
        "n": encode(n),
        "m": encode(m),
        "s": encode(s),
    }

    with open("input.json", "w") as file:
        json.dump(j, file, indent=4)


def main() -> None:
    # p = int(input("Enter p: "))
    # q = int(input("Enter q: "))
    # m = int(input("Enter m: "))

    p = 257
    q = 263
    m = 113

    generate_input(p, q, m)


if __name__ == "__main__":
    main()
