

<h1 align="center">CryptoStats-Plasmoid</h1>
<p align="center">
  <img src="https://github.com/user-attachments/assets/1a4170ef-f396-4c6c-b5ca-8e529634473d" alt="Alt Text" width="300"\>
</p>

# 🪙  Real-Time Cryptocurrency Price Widget for Plasma 6
**CryptoStats** is a sleek and lightweight Plasma 6 widget that displays real-time cryptocurrency prices directly on your KDE desktop. Built with performance in mind, it uses the Coinbase Public API with a simple `curl` backend to fetch the latest price data without requiring API keys or external dependencies.
<div align="center">

![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-KDE%20Plasma%206-blue.svg)
![Language](https://img.shields.io/badge/language-QML-orange.svg)

</div>

## ✨ Features

- **Live Price Tracking**: Monitor up to 3 cryptocurrencies simultaneously (BTC, ETH, SOL, and more)
- **Real-time Updates**: Price data refreshes every 5 seconds
- **Visual Indicators**: Color-coded display with 🟢 green for price increases and 🔴 red for decreases
- **Zero Configuration**: No API keys required - uses Coinbase's public endpoints
- **Lightweight**: Optimized for minimal resource usage and maximum performance
- **Modern UI**: Clean, minimalist design that integrates seamlessly with Plasma 6

## 🛠️ Technical Stack

- **API**: Coinbase Public API (no authentication required)
- **Backend**: `curl` for HTTP requests
- **Frontend**: QML for Plasma 6 widget interface
- **Platform**: KDE Plasma 6 desktop environment

## 📦 Installation

Store : https://www.pling.com/p/2309211/

### Manual Installation

1. Clone the repository to your Plasma widgets directory:
   ```bash
   git clone https://github.com/VeerajSai/CryptoStats.git ~/.local/share/plasma/plasmoids/CryptoStats
   ```

2. For development and testing:
   ```bash
   cd ~/.local/share/plasma/plasmoids/CryptoStats
   plasmoidviewer .
   ```

3. Add to your desktop:
   - Right-click on your desktop or panel
   - Select "Add Widgets..."
   - Search for "CryptoStats"
   - Drag the widget to your desired location

### Requirements

- KDE Plasma 6
- `curl` (usually pre-installed on most Linux distributions)
- Qt 6 and KDE Frameworks 6

## 🚀 Usage

Once installed, the widget will automatically start fetching cryptocurrency prices. The default configuration tracks:
- Bitcoin (BTC)
- Ethereum (ETH) 
- Solana (SOL)

Price changes are indicated by Given color:
- 🟢 **Green**: Price has increased since last update
- 🔴 **Red**: Price has decreased since last update

## 🔮 Roadmap

### Planned Features
- [ ] **Multi-coin Charts**: Interactive price graphs and historical data
- [ ] **Currency Selection**: Support for multiple fiat currencies (USD, EUR, INR, etc.)
- [ ] **Price Alerts**: Desktop notifications for custom price thresholds
- [ ] **Customizable Refresh Rate**: User-configurable update intervals
- [ ] **Extended Coin Support**: Add support for more cryptocurrencies
- [ ] **Portfolio Tracking**: Track your crypto holdings and total value

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## 📬 Contact

**veerajsai** - [@veerajsai](https://github.com/VeerajSai)

Project Link: [https://github.com/VeerajSai/CryptoStats](https://github.com/VeerajSai/CryptoStats)

---

**Keep your eyes on the market — right from your desktop.** 📈
