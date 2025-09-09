import multiprocessing as mp
import hashlib
import sys
import os
from typing import Optional, Tuple

class Block:
    def __init__(self, difficulty: int, previousHash: str, data: str, index: int, timestamp: int):
        self.data: str = data
        self.timestamp: int = timestamp
        self.index: int = index
        self.difficulty: int = difficulty
        self.previousHash: str = previousHash
        self.nonce: int = 0

    def calculate_hash(self, nonce: int) -> str:
        block_string: str = f"{nonce}{self.data}{self.timestamp}"
        return hashlib.sha256(block_string.encode()).hexdigest()

def find_nonce_worker(args: Tuple[int, int, int, str, int]) -> Optional[Tuple[int, int]]:
    """Worker function for multiprocessing"""
    start_nonce, step, difficulty, data, timestamp = args
    process_id = os.getpid()
    
    nonce = start_nonce
    zero_check = '0' * difficulty
    
    print(f"Process {process_id} starting from nonce {start_nonce}")
    
    while True:
        block_string = f"{nonce}{data}{timestamp}"
        hash_result = hashlib.sha256(block_string.encode()).hexdigest()
        
        if hash_result.startswith(zero_check):
            print(f"Process {process_id} found nonce: {nonce}")
            return nonce, process_id
            
        nonce += step

if __name__ == "__main__":
    # Create block
    block = Block(difficulty=6, previousHash='0000', data='Hello, Blockchain!', index=1, timestamp=1234567890)
    
    print("Mining started with multiprocessing...")
    
    # Get number of CPU cores
    num_processes = mp.cpu_count()
    print(f"Using {num_processes} processes")
    
    # Prepare arguments for each process
    args_list = [
        (i, num_processes, block.difficulty, block.data, block.timestamp)
        for i in range(num_processes)
    ]
    
    # Start multiprocessing
    with mp.Pool(processes=num_processes) as pool:
        try:
            # Use imap_unordered to get results as they complete
            for result in pool.imap_unordered(find_nonce_worker, args_list):
                if result:
                    nonce, process_id = result
                    print(f"SUCCESS! Process {process_id} found nonce: {nonce}")
                    block.nonce = nonce
                    pool.terminate()  # Stop all other processes
                    break
        except KeyboardInterrupt:
            print("Mining interrupted by user")
            pool.terminate()
    
    if block.nonce > 0:
        final_hash = block.calculate_hash(block.nonce)
        print(f"Final hash: {final_hash}")
        print(f"Nonce: {block.nonce}")
    else:
        print("No nonce found")
    
    print("Done!")