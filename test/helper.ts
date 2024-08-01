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

export const r = 0x05dede694938078b945b38d78e9a4d21e5244aca8f09869731fa16cf9570f970n;
export const s = 0x7e290a493c3bc0d9d4d40055cc349cb255b8613250c28b104913eef601ba374bn;
export const msgHash = 0x961fd084daceb264d5133ad324157c2068eb1b6a1108911d00f9c7cdf9a6035fn;

