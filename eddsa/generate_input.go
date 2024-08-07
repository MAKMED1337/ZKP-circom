package main

import (
	"encoding/json"
	"github.com/iden3/go-iden3-crypto/babyjub"
	"math/big"
    "os"
)

func main() {
	sk := babyjub.NewRandPrivKey()

	message := *big.NewInt(1)
	sign := *sk.SignPoseidon(&message)

	data := map[string]interface{}{
		"Ax":  sk.Public().X.String(),
		"Ay":  sk.Public().Y.String(),
		"R8x": sign.R8.X.String(),
		"R8y": sign.R8.Y.String(),
		"S":   sign.S.String(),
		"M":   message.String(),
	}

    f, _ := os.Create("input.json")
    defer f.Close()
    as_json, _ := json.MarshalIndent(data, "", "\t")
    f.Write(as_json)
}
