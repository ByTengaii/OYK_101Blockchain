import hashlib
import sys
from typing import Optional, Tuple


class Block:
    nonce:int
    hash:hashlib._hashlib.HASH
    data:str
    previousHash:hashlib._hashlib.HASH

    def __init__(self):
        self.nonce = 0
        self.data = ''
        self.timestamp = 0

    @staticmethod
    def calculate_hash(self) -> str:
        # Create a unique string representation of the block
        block_string = f"{self.nonce}{self.data}{self.previousHash}{self.timestamp}"
        return hashlib.sha256(block_string.encode()).hexdigest()
    

def calculate_hash(text: str, difficulty: int, start_nonce: int = 0, max_nonce: int = sys.maxsize) -> Optional[Tuple[str, int]]:
    nonce: int = start_nonce
    zero_check: str = '0' * difficulty
    text_bytes: bytes = text.encode()                     # encode once
    base: hashlib._hashlib.HASH = hashlib.sha256()       # create base hasher
    base.update(text_bytes)

    while nonce <= max_nonce:
        h: hashlib._hashlib.HASH = base.copy()           # clone state (fast)
        h.update(str(nonce).encode())                    # only update nonce bytes
        digest_hex: str = h.hexdigest()
        if digest_hex.startswith(zero_check):
            return digest_hex, nonce
        nonce += 1
    return None
if __name__ == "__main__":
    text: str = 'selam'
    print(calculate_hash(text, 7))