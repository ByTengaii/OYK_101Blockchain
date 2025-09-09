import hashlib
import os
from mnemonic import Mnemonic
from bip_utils import (
    Bip39SeedGenerator,
    Bip44,
    Bip44Coins,
    Bip44Changes
)

def ripemd160(data: bytes) -> bytes:
    """RIPEMD160 hash function"""
    import hashlib
    return hashlib.new('ripemd160', data).digest()

def create_20_byte_address(public_key: bytes) -> str:
    """Create 20-byte address from public key"""
    # Step 1: SHA256 hash of public key
    sha256_hash = hashlib.sha256(public_key).digest()
    
    # Step 2: RIPEMD160 hash of SHA256 result
    ripemd160_hash = ripemd160(sha256_hash)
    
    # Return as hex string (20 bytes = 40 hex characters)
    return ripemd160_hash.hex()

def main():
    print("=== Bitcoin Wallet Generator ===\n")
    
    # 1. Generate 12-word mnemonic seed
    #-------------------------------------------------------------------------------
    mnemo = Mnemonic("english")
    mnemonic_words = mnemo.generate(strength=128)  # 128 bits = 12 words
    print(f"1. Mnemonic Seed (12 words):")
    print(f"   {mnemonic_words}\n")
    
    # 2. Generate seed from mnemonic
    #-------------------------------------------------------------------------------
    seed_bytes = Bip39SeedGenerator(mnemonic_words).Generate()
    print(f"2. Seed (512 bits):")
    print(f"   {seed_bytes.hex()}\n")
    
    # 3. Create master key and derive wallet keys
    #-------------------------------------------------------------------------------
    # Create BIP44 master context
    bip44_mst_ctx = Bip44.FromSeed(seed_bytes, Bip44Coins.BITCOIN)
    
    # Derive to first address: m/44'/0'/0'/0/0
    bip44_acc_ctx = bip44_mst_ctx.Purpose().Coin().Account(0)
    bip44_chg_ctx = bip44_acc_ctx.Change(Bip44Changes.CHAIN_EXT)
    bip44_addr_ctx = bip44_chg_ctx.AddressIndex(0)
    
    # 4. Extract private and public keys
    #-------------------------------------------------------------------------------
    private_key = bip44_addr_ctx.PrivateKey().Raw().ToBytes()
    public_key = bip44_addr_ctx.PublicKey().RawCompressed().ToBytes()
    
    print(f"3. Private Key (32 bytes):")
    print(f"   {private_key.hex()}")
    print(f"   Length: {len(private_key)} bytes\n")
    
    print(f"4. Public Key (33 bytes compressed):")
    print(f"   {public_key.hex()}")
    print(f"   Length: {len(public_key)} bytes\n")
    
    # 5. Create 20-byte address
    #-------------------------------------------------------------------------------
    address_20_bytes = create_20_byte_address(public_key)
    
    print(f"5. 20-byte Address:")
    print(f"   {address_20_bytes}")
    print(f"   Length: {len(bytes.fromhex(address_20_bytes))} bytes\n")
    
    # 6. Summary
    #-------------------------------------------------------------------------------
    print("=== WALLET SUMMARY ===")
    print(f"Mnemonic:     {mnemonic_words}")
    print(f"Private Key:  {private_key.hex()}")
    print(f"Public Key:   {public_key.hex()}")
    print(f"20-byte Addr: {address_20_bytes}")
    
    # 7. Verification
    #-------------------------------------------------------------------------------
    print(f"\n=== VERIFICATION ===")
    print(f"Mnemonic words count: {len(mnemonic_words.split())}")
    print(f"Private key length:   {len(private_key)} bytes")
    print(f"Public key length:    {len(public_key)} bytes") 
    print(f"Address length:       {len(bytes.fromhex(address_20_bytes))} bytes")

if __name__ == "__main__":
    main()