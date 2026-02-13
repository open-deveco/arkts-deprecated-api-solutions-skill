import cryptoFramework from '@ohos.security.cryptoFramework';
import util from '@ohos.util';

function generateRandom(): Uint8Array {
  // Modern usage: cryptoFramework
  let rand = cryptoFramework.createRandom();
  let blob = rand.generateRandomSync(16);
  return blob.data;
}

function decodeString(data: Uint8Array): string {
  // Modern usage: util.TextDecoder
  let textDecoder = util.TextDecoder.create('utf-8');
  return textDecoder.decodeToString(data);
}
