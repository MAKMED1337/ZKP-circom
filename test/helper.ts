export function encode256(n: bigint): string[] {
    let get64 = (x: bigint): string => (x & ((1n << 64n) - 1n)).toString();
    return [get64(n), get64(n >> 64n), get64(n >> 128n), get64(n >> 192n)]
}

/*
await window.ethereum.request({
  "method": "eth_signTypedData_v4",
  "params": [
    "0xaC1A153Bd465FAaA9ca3CB155614c454611278D2",
    {
      "types": {
        "EIP712Domain": [
          {
            "name": "name",
            "type": "string"
          },
          {
            "name": "version",
            "type": "string"
          },
          {
            "name": "chainId",
            "type": "uint256"
          },
          {
            "name": "verifyingContract",
            "type": "address"
          }
        ],
        "Dummy": [
          {
            "name": "nonce",
            "type": "string"
          }
        ]
      },
      "domain": {
        "name": "IDK",
        "version": "1",
        "chainId": "11155111",
        "verifyingContract": "0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC"
      },
      "message": {
        "nonce": "dummy message"
      },
      "primaryType": "Dummy"
    }
  ]
});
*/
// result: 0x05dede694938078b945b38d78e9a4d21e5244aca8f09869731fa16cf9570f9707e290a493c3bc0d9d4d40055cc349cb255b8613250c28b104913eef601ba374b1b

// message hash using https://eips.ethereum.org/assets/eip-712/Example.js:
// 0x961fd084daceb264d5133ad324157c2068eb1b6a1108911d00f9c7cdf9a6035f

export const pk = [
    0x027ee66f8afbf31607fde359663950fd568719a0e427cf2b2dd41ce1a33ceb0bn,
    0xd3248e6aeb35bcc1809989f6eeb5f3225c24e06bce8e157aef7f48995ed09824n
];
export const address = 0xaC1A153Bd465FAaA9ca3CB155614c454611278D2n;

export const r = 0x05dede694938078b945b38d78e9a4d21e5244aca8f09869731fa16cf9570f970n;
export const s = 0x7e290a493c3bc0d9d4d40055cc349cb255b8613250c28b104913eef601ba374bn;
export const msgHash = 0x961fd084daceb264d5133ad324157c2068eb1b6a1108911d00f9c7cdf9a6035fn;

export const addresses = [
    0x3826539Cbd8d68DCF119e80B994557B4278CeC9fn,
    0x0000000000000000000000000000000000000000n,
    0x9B984D5a03980D8dc0a24506c968465424c81DbEn,
    0x455E5AA18469bC6ccEF49594645666C587A3a71Bn,
    0x6a7aA9b882d50Bb7bc5Da1a244719C99f12F06a3n,
    address, // 5-th index
    0x6a7aA9b882d50Bb7bc5Da1a244719C99f12F06a3n,
    0xCfB48ef414e5BB96F9375C593abFe6FEa94e43Ean,
    0x5e809A85Aa182A9921EDD10a4163745bb3e36284n,
    0x4d02aF17A29cdA77416A1F60Eae9092BB6d9c026n,
    0x3bFA4769FB09eefC5a80d6E87c3B9C650f7Ae48En,
    0x008b3b2F992C0E14eDaa6E2c662Bec549CAA8df1n,
    0x455E5AA18469bC6ccEF49594645666C587A3a71Bn,
    0x13CB6AE34A13a0977F4d7101eBc24B87Bb23F0d5n,
    0xF29Ff96aaEa6C9A1fBa851f74737f3c069d4f1a9n,
    0x670B24610DF99b1685aEAC0dfD5307B92e0cF4d7n,
];

