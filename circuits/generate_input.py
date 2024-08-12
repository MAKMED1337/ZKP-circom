import json


def encode(n: int, size: int) -> list[str]:
    return [str(i) for i in n.to_bytes(size, "big")]


def main() -> None:
    n = 0x966B5855B11429C43DBFA9A0C51B1E56004FFD90C94995442227F4F41A63BF08DDBB89E201BE08852C35EE9BC4C4C84537253A3092E00536582D85C158B37C730CC37B610DE26F1A1AC156ABE8C0FD0F88CAB63F25560B53110250900DBDBAF7D3A3A81826B9CEC1C140E87AA3E8E821CD52B2FC02B57117B8B2DF99DB91C9BBD4B8DD517F0A4E46FAF718B7EA63EB99927FB883BD642FD23C71E04C0463E03AD2FB37E5BD6439BA7219CE55AFE4D5E3EB7E848DE571C997C4E3C50E1F54287A92325C0D716399AC624C57F2852D2C7A5F6E80BC024A932DD3E5B08BA4A885BF94159FD0B7A78483B5EF22E1D923F432436FC0B00E2E562FD10239F46C736A1B
    m = 0x3158301506092A864886F70D01090331080606678108010101303F06092A864886F70D010904313204302B15BF2F928A23F674A04343308FB2ED642CBB511090976D50F23207B660B48EEFC056E2BFE2BE8FE458CECDB0761C94
    s = 0x93BA8C579CABE15789C0B9F75614E8C7D491B14AB3E09C08AD4E9DDAAE98FD8988E6810EC8B7B8B2C592830033148FC84500DF4896C40A27FE736BF53990ADA88A228B3B850A8E90C99499FF8F92510A13B0E3EC2709D8BF62CF691D5F0129FE17E006B83D581BA2FF633B7D62EA8C8A5DCD0839303A883B9918D404153131023FC6535FE1C436700C5D739C79E3A61778291D594A9B8AF0D2576BEAB2FFE906E813183CC25CAC7B8AFCA27286D474353D2050B713D9FE59466798FCCF8AFC010D3947B4018ACA9CA5BF0D2367B4E15CA613238F3007A89C34D88DF8BD1E13DEC8CC9E41FD7A257E73FF860D80788F90A6F90E947EF92D60CDF14B1BC2798FC4

    j = {
        "n": encode(n, 256),
        "m": encode(m, 90),
        "s": encode(s, 256),
    }

    with open("input.json", "w") as file:
        json.dump(j, file, indent=4)


if __name__ == "__main__":
    main()
