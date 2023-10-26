export const hexView = (bytes: Buffer | Uint8Array): string => {
  return bytes && Array.from(bytes).map(x => x.toString(16).padStart(2, '0')).join('')
}

export const hexString = (bytes: Buffer | Uint8Array): string => {
  return '0x' + hexView(bytes)
}

export const stringToBytes = (str: string): Uint8Array => {
  return new TextEncoder().encode(str)
}
