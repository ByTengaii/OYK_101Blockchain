# OYK 101 Blockchain - Eğitim Projesi

Bu proje, blockchain teknolojisi, kripto para madenciliği, cüzdan geliştirme ve akıllı sözleşme programlama konularında kapsamlı bir eğitim seti içermektedir.

## 📁 Proje Yapısı

### 🐍 Python Bileşenleri
- **`DAY2_miner.py`** - Temel blockchain madenci implementasyonu
- **`DAY3_multiThread_miner.py`** - Çok iş parçacıklı madenci algoritması
- **`DAY5_wallet.py`** - Bitcoin cüzdan oluşturma ve anahtar yönetimi
- **`RSA.py`** - RSA şifreleme algoritması implementasyonu

### 🔗 Solidity Akıllı Sözleşmeleri
- **`NFT.sol`** - ERC721 NFT sözleşmesi (OpenZeppelin tabanlı)
- **`Gambling/`** - Gambling DApp'i bileşenleri:
  - `NumberGuessGame.sol` - Sayı tahmin oyunu
  - `Token.sol` - ERC20 token implementasyonu
  - `minibank.sol` - Mini banka sözleşmesi
  - `IERC20.sol` - ERC20 interface

### 📚 Eğitim Materyalleri (`oyk-2025-yaz/`)
- **`1-blockchain-modelleri.md`** - Bitcoin UTXO vs Ethereum Hesap Modeli
- **`2-yellow.md`** - Ethereum Yellow Paper açıklamaları
- **`3-nodes.md`** - Blockchain node'ları
- **`5-gas.md`** - Ethereum Gas mekanizması
- **`6-ipfs.md`** - IPFS dağıtık dosya sistemi
- **HTML Dosyaları** - Interaktif eğitim materyalleri

## 🚀 Başlangıç

### Gereksinimler

#### Python Projeleri İçin:
```bash
pip install hashlib
pip install mnemonic
pip install bip-utils
```

#### Solidity Projeleri İçin:
```bash
npm install ethers
npm install @openzeppelin/contracts
```

### Kurulum

1. Projeyi klonlayın:
```bash
git clone <repo-url>
cd OYK_101Blockchain
```

2. Python bağımlılıklarını yükleyin:
```bash
pip install -r requirements.txt
```

3. Node.js bağımlılıklarını yükleyin:
```bash
cd oyk-2025-yaz
npm install
```

## 📖 Kullanım Kılavuzu

### 1. Blockchain Madenciliği

#### Temel Madenci:
```bash
python DAY2_miner.py
```

#### Çok İş Parçacıklı Madenci:
```bash
python DAY3_multiThread_miner.py
```

### 2. Bitcoin Cüzdan Oluşturma

```bash
python DAY5_wallet.py
```

Bu script şunları oluşturur:
- 12 kelimelik mnemonic seed
- Master private/public key çifti
- Bitcoin adresleri (BIP44 standardı)
- Hierarchical Deterministic (HD) wallet yapısı

### 3. Akıllı Sözleşme Dağıtımı

#### NFT Sözleşmesi:
```solidity
// Remix IDE'de NFT.sol dosyasını açın
// Constructor parametreleri: name, symbol
// Mint fonksiyonu ile NFT oluşturun
```

#### Gambling DApp:
```solidity
// NumberGuessGame.sol - Sayı tahmin oyunu
// Token.sol - ERC20 token ile ödemeler
```

## 🎯 Proje Hedefleri

### Öğrenilen Konular:

1. **Blockchain Temelleri**
   - Hash fonksiyonları ve proof-of-work
   - Block yapısı ve zincir mantığı
   - Nonce değeri ve difficulty ayarı

2. **Kripto Para Madenciliği**
   - SHA256 hash hesaplaması
   - Mining algoritmaları
   - Multi-threading optimizasyonu

3. **Cüzdan Teknolojisi**
   - Mnemonic seed generation
   - BIP39/BIP44 standartları
   - Private/public key matematisi
   - Address derivation

4. **Akıllı Sözleşme Geliştirme**
   - Solidity programlama
   - ERC20/ERC721 token standartları
   - DeFi protokol tasarımı
   - Gas optimizasyonu

5. **Blockchain Modelleri**
   - Bitcoin UTXO modeli
   - Ethereum Account modeli
   - İşlem yapıları ve doğrulama

## 🔧 Teknik Detaylar

### Python Modülleri

#### Madenci (`DAY2_miner.py`)
- **Hash Hesaplama**: SHA256 algoritması
- **Proof of Work**: Belirli zorluk seviyesinde hash bulma
- **Nonce İterasyonu**: Sistematik deneme yanılma

#### Cüzdan (`DAY5_wallet.py`)
- **Mnemonic**: 12 kelimelik seed phrase
- **Key Derivation**: BIP44 hierarşik yapı
- **Address Generation**: RIPEMD160(SHA256(pubkey))

#### Multi-Threading (`DAY3_multiThread_miner.py`)
- **Paralel İşlem**: Çoklu CPU core kullanımı
- **Work Distribution**: İş yükü dağıtımı
- **Result Aggregation**: Sonuç toplama

### Solidity Sözleşmeleri

#### NFT Sözleşmesi
```solidity
contract OYKNft is ERC721, ERC721URIStorage, Ownable {
    // Metadata URI storage
    // Owner-only minting
    // Token ID auto-increment
}
```

#### Number Guess Game
```solidity
contract NumberGuess {
    // ERC20 token entegrasyonu
    // Randomization mechanism
    // Betting ve reward sistemi
}
```

## 📊 Performans Metrikleri

### Madenci Performansı:
- **Hash Rate**: Saniyede hash hesaplama sayısı
- **Thread Efficiency**: CPU core kullanım oranı
- **Memory Usage**: RAM tüketimi

### Gas Optimizasyonu:
- **Contract Size**: Bytecode boyutu
- **Function Calls**: İşlem maliyetleri
- **Storage Operations**: Veri yazma/okuma

## 🎓 Eğitim Yol Haritası

### Başlangıç Seviyesi:
1. `1-blockchain-modelleri.md` - Temel kavramlar
2. `DAY2_miner.py` - İlk madenci deneyimi
3. `RSA.py` - Kriptografi temelleri

### Orta Seviye:
1. `DAY5_wallet.py` - Cüzdan teknolojisi
2. `DAY3_multiThread_miner.py` - Performans optimizasyonu
3. `NFT.sol` - Temel akıllı sözleşme

### İleri Seviye:
1. `NumberGuessGame.sol` - Kompleks DApp
2. `minibank.sol` - DeFi protokolü
3. Gas optimizasyonu teknikleri

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Commit yapın (`git commit -m 'Add some AmazingFeature'`)
4. Branch'e push yapın (`git push origin feature/AmazingFeature`)
5. Pull Request açın

## 📄 Lisans

Bu proje eğitim amaçlı olarak geliştirilmiştir. MIT lisansı altında dağıtılmaktadır.

## ⭐ Yıldızlamayı Unutmayın!

Bu proje işinize yaradıysa, lütfen ⭐ vererek destekleyin!

---

### 🔗 Faydalı Linkler

- [Bitcoin Whitepaper](https://bitcoin.org/bitcoin.pdf)
- [Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [BIP39 Specification](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)
- [ERC20 Token Standard](https://eips.ethereum.org/EIPS/eip-20)
- [ERC721 NFT Standard](https://eips.ethereum.org/EIPS/eip-721)

### 🛠️ Geliştirme Araçları

- **Code Editor**: VS Code + Solidity Extension
- **Blockchain IDE**: Remix IDE
- **Testing Framework**: Hardhat / Truffle
- **Wallet**: MetaMask
- **Block Explorer**: Etherscan

---


Bu README, projedeki tüm bileşenleri kapsamlı bir şekilde açıklayarak, blockchain teknolojisi öğrenmek isteyen geliştiriciler için rehber niteliğindedir.
