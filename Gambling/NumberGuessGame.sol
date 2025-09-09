// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
}

contract NumberGuess {
    // --- Structs ---
    struct Game {
        uint gameId;
        address player;
        uint gameDate;
        uint totalBet;
        uint award;
        uint8 selectedNumber;
        bool isFinished;
        uint256 guessFee;
        // NEW: Stores the player's most recent guess for the hint system.
        uint8 lastGuess;
    }

    struct User {
        address userAddress;
        uint totalTake;
        uint totalSpend;
        bool isRegistered;
        Game[] games;
    }

    // --- State Variables ---
    IERC20 public immutable s_paymentToken;
    address public immutable owner;
    uint256 public gameCounter;

    mapping(address => User) public users;

    // --- Events ---
    event GameStarted(address indexed player, uint256 indexed gameId, uint256 fee);
    event GuessMade(address indexed player, uint256 indexed gameId, uint8 guess, bool isWinner);
    event GameWon(address indexed player, uint256 indexed gameId, uint256 award);
    // NEW: Event for when a user buys a hint.
    event HintTaken(address indexed player, uint256 indexed gameId, uint256 hintCost);

    // --- Constructor ---
    constructor(address _tokenAddress) {
        owner = msg.sender;
        s_paymentToken = IERC20(_tokenAddress);
    }

    // --- Modifiers ---
    modifier gameIsActive() {
        require(users[msg.sender].games.length > 0, "You have not started any games.");
        Game storage lastGame = users[msg.sender].games[users[msg.sender].games.length - 1];
        require(!lastGame.isFinished, "Your last game is finished. Please start a new one.");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner.");
        _;
    }

    modifier registeredOnly() {
        require(users[msg.sender].isRegistered, "You are not registered.");
        _;
    }

    // --- Functions ---
    /**
     * @dev SECURITY WARNING: This method of generating a random number is NOT secure.
     * For any real value, you MUST use a secure off-chain solution like Chainlink VRF.
     */
    function generateRandomNumber() internal view returns (uint8) {
        bytes32 secret = keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp, msg.sender));
        return uint8(uint256(secret) % 100) + 1;
    }

    function register() external {
        require(!users[msg.sender].isRegistered, "You are already registered.");
        users[msg.sender].isRegistered = true;
        users[msg.sender].userAddress = msg.sender;
    }

    function startGame(uint256 _fee) external registeredOnly {
        User storage currentUser = users[msg.sender];
        if (currentUser.games.length > 0) {
            require(currentUser.games[currentUser.games.length - 1].isFinished, "You already have an active game.");
        }

        bool success = s_paymentToken.transferFrom(msg.sender, address(this), _fee);
        require(success, "Token transfer for the initial bet failed. Did you approve?");

        currentUser.totalSpend += _fee;
        gameCounter++;

        Game memory newGame = Game({
            gameId: gameCounter,
            player: msg.sender,
            gameDate: block.timestamp,
            totalBet: _fee,
            award: (_fee * 5),
            selectedNumber: generateRandomNumber(),
            isFinished: false,
            guessFee: _fee,
            lastGuess: 0 // Initialize with 0, as no guess has been made.
        });

        currentUser.games.push(newGame);
        emit GameStarted(msg.sender, newGame.gameId, _fee);
    }

    function guessNumber(uint8 _guess) external registeredOnly gameIsActive {
        User storage currentUser = users[msg.sender];
        Game storage currentGame = currentUser.games[currentUser.games.length - 1];

        uint256 fee = currentGame.guessFee;
        bool success = s_paymentToken.transferFrom(msg.sender, address(this), fee);
        require(success, "Token transfer for this guess failed.");

        // NEW: Record the guess for the hint system.
        currentGame.lastGuess = _guess;
        currentGame.totalBet += fee;
        currentUser.totalSpend += fee;
        
        if (currentGame.selectedNumber == _guess) {
            currentGame.isFinished = true;
            currentUser.totalTake += currentGame.award;
            emit GuessMade(msg.sender, currentGame.gameId, _guess, true);
            emit GameWon(msg.sender, currentGame.gameId, currentGame.award);
            success = s_paymentToken.transfer(msg.sender, currentGame.award);
            require(success, "Failed to send the prize.");
        } else {
            emit GuessMade(msg.sender, currentGame.gameId, _guess, false);
        }
    }
    
    /**
     * @notice Allows a player to buy a hint for their active game.
     * @dev Costs 25% of the game's guessFee. Player must have made at least one guess.
     * @return hint A uint8 value: 1 if the number is higher, 2 if it is lower.
     */
    // NEW: The takeHint function.
    function takeHint() external registeredOnly gameIsActive returns (uint8 hint) {
        User storage currentUser = users[msg.sender];
        Game storage currentGame = currentUser.games[currentUser.games.length - 1];

        require(currentGame.lastGuess != 0, "You must make at least one guess to get a hint.");

        uint256 hintCost = currentGame.guessFee / 2; // 50% of the guess fee
        require(hintCost > 0, "Hint cost must be greater than zero.");

        bool success = s_paymentToken.transferFrom(msg.sender, address(this), hintCost);
        require(success, "Token transfer for the hint failed.");

        currentGame.totalBet += hintCost;
        currentUser.totalSpend += hintCost;

        emit HintTaken(msg.sender, currentGame.gameId, hintCost);

        if (currentGame.selectedNumber > currentGame.lastGuess) {
            return 1; // "Above"
        } else {
            return 2; // "Below"
        }
    }

    // --- View Functions ---
    function getPlayerInfo(address _player) external view returns (User memory) {
        return users[_player];
    }
    
    function getLastGame(address _player) external view returns (Game memory) {
        require(users[_player].games.length > 0, "The player has no games.");
        return users[_player].games[users[_player].games.length - 1];
    }
}