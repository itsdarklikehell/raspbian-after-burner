# raspbian-after-burner

Post-install script for Raspbian — install tools, games, and hacking utilities, or remove bloatware after burning a fresh SD card.

## Features

- **Tool Installation**: RetroPie, Emby, PiVPN, OpenVPN, Apache, NGINX, PHP, MySQL, Quassel, and more
- **Hacking Tools**: Metasploit, Armitage, SQLMap, Nmap, Wireshark, Aircrack-ng, PixieWPS, Wifite, Fern, SEToolkit, MITMf, and more
- **Game Installation**: Wesnoth, Micropolis, Widelands, and many classic games
- **Bloatware Removal**: Remove Wolfram Engine, LibreOffice, Scratch, and other unnecessary packages
- **System Utilities**: Enable SSH, run raspi-config, upgrade system, clean apt

## Installation

### Using curl

```bash
bash <(curl -Ls https://github.com/itsdarklikehell/raspbian-after-burner/raw/master/After-Burner.sh)
```

### Generic

```bash
git clone https://github.com/itsdarklikehell/raspbian-after-burner
cd raspbian-after-burner
chmod +x After-Burner.sh
./After-Burner.sh
```

## Usage

Run the script and select an option from the menu:

1. **Install Tools** — RetroPie, Emby, PiVPN, OpenVPN, web servers, etc.
2. **Install Hacking Tools** — Metasploit, Armitage, SQLMap, Nmap, etc.
3. **Install Games** — Wesnoth, Micropolis, Widelands, etc.
4. **Remove Bloatware** — Remove Wolfram, LibreOffice, Scratch, etc.
5. **Upgrade System** — Update and upgrade all packages
6. **Enable SSH** — Create `/boot/ssh` to enable SSH on boot
7. **Raspi-Config** — Run Raspberry Pi configuration tool
8. **Exit** — Exit the script

## Requirements

- Raspberry Pi running Raspbian (32-bit)
- `whiptail` installed (`sudo apt-get install whiptail`)
- Internet connection
- Run as regular user (not root)

## Testing

Run the test suite:

```bash
./tests/test_after_burner.sh
```

## Project Structure

```
raspbian-after-burner/
├── After-Burner.sh          # Main script
├── tests/
│   └── test_after_burner.sh # Test suite
├── .github/
│   └── workflows/
│       ├── ci.yml           # CI workflow
│       └── gource.yml       # Gource visualization
├── README.md
└── gource.mp4               # Development timeline video
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is provided as-is. Use at your own risk.

## 🎥 Gource Visualization

De ontwikkelhistorie van dit project in een film:

<video src="https://raw.githubusercontent.com/itsdarklikehell/raspbian-after-burner/master/gource.mp4" controls width="100%"></video>
