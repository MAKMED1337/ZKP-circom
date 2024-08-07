from math import lcm
import json

NUMBER_OF_BLOCKS = 8
BLOCK_SIZE = 64


def encode(n: int) -> list[str]:
    initial_n = n

    res = [""] * NUMBER_OF_BLOCKS
    for i in range(NUMBER_OF_BLOCKS):
        res[i] = str(n & ((1 << BLOCK_SIZE) - 1))
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

    # p = 257
    # q = 263

    # 256 bit prime numbers
    p = 0xC87E043206B574F71F889378946A716E4FC8E5B99E966DF47E1C4F033867D4AF
    q = 0xCAD852CD9EBEEC205EBDB49B4C78EEEAABC05B315515FD14D32E9F4E461F4515

    # 512 bit prime numbers
    # p = 0xE14CC99C3D26DE84A34543625FA914BEE1D51A831D15A7134693FF5E40AD48284D453CAEFE038C903C089AE0B5807C3466ED2039906A0A2CC595276F86A2FE41
    # q = 0xD3044FE41C7A6D906BD5792E7577B07CFE37EF63CAB652067E66524447018B086D1F186750EBE82760D887BAA072B25D8B9DF16182594E549361BC76246F2B09

    m = 113

    generate_input(p, q, m)


if __name__ == "__main__":
    main()
