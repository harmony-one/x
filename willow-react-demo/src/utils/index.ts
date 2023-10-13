// @ts-ignore
import * as hashes from 'jshashes';

/**
 * Pauses the execution of the function for a specified duration.
 *
 * @export
 * @param {number} ms - The duration (in milliseconds) to pause the execution.
 * @returns {Promise} A Promise that resolves after the specified duration.
 */
export function sleep(ms: number): Promise<any> {
    return new Promise(resolve => setTimeout(resolve, ms));
}

/**
 * Creates a deep clone of the given ArrayBuffer.
 *
 * @export
 * @param {ArrayBuffer} buffer - The ArrayBuffer to clone.
 * @returns {ArrayBuffer} A new ArrayBuffer containing the same binary data as the input buffer.
 */
export function cloneArrayBuffer(buffer: ArrayBuffer): ArrayBuffer {
    const newBuffer = new ArrayBuffer(buffer.byteLength);
    new Uint8Array(newBuffer).set(new Uint8Array(buffer));
    return newBuffer;
}

/*
Hashing
*/

const hasher = new hashes.MD5();

const hashCache = new Map<string, string>();

export async function md5(data: string): Promise<string> {
    if (!hashCache.has(data)) {
        const hashHex = hasher.hex(data);
        hashCache.set(data, hashHex);
    }
    return hashCache.get(data)!;
}