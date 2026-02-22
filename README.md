# 🎮 Wreckfest Server Manager

> Created and provided by **QueenOfPain666**  
> A lightweight Linux GUI for managing Wreckfest dedicated servers — built with Bash + Zenity.  
> No dependencies beyond what ships with most distros. One AppImage, runs anywhere.

---

## Features

- 🚀 Start / 🛑 Stop / 🔍 Check for two independent server slots (WF1 + WF2)
- 📂 **File picker dialog** to select your server scripts on the fly — no config editing needed
- 💾 Optional persistent config (`~/.config/queens_main_core.conf`)
- 💀 Emergency PURGE (kills Wine + socat processes)
- ℹ️ Live info view showing active script paths
- Works with **any** server that uses `start` / `stop` / `status` / `check` commands

---

## Requirements

- Linux x86_64
- `zenity` (ships with GNOME, or: `sudo apt install zenity`)
- `bash` 4+

---

## Download & Run

1. Download `WreckfestServerManager-x86_64.AppImage` from [Releases](../../releases)
2. Make it executable and run:

```bash
chmod +x WreckfestServerManager-x86_64.AppImage
./WreckfestServerManager-x86_64.AppImage
```

---

## Setting up your server scripts

> ⚠️ **You must edit the example scripts before using them.** They will not work out of the box — you need to set your server path first (see below).

Example templates are provided in `example_scripts/`:

| File | Description |
|------|-------------|
| `wf1_server_example.sh` | Template for Wreckfest 1 |
| `wf2_server_example.sh` | Template for Wreckfest 2 |

### Wreckfest 1

Open `wf1_server_example.sh` and set the `DS_DIR` variable at the top to your Wreckfest Dedicated Server folder:

```bash
DS_DIR="${DS_DIR:-/YOUR/WRECKFEST1/SERVER/PATH/HERE}"
# Example:
DS_DIR="${DS_DIR:-/home/user/.steam/steamapps/common/Wreckfest Dedicated Server}"
```

### Wreckfest 2

Open `wf2_server_example.sh` and set `DS_DIR` to your Wreckfest 2 Dedicated Server folder:

```bash
DS_DIR="${DS_DIR:-/YOUR/WRECKFEST2/SERVER/PATH/HERE}"
# Example:
DS_DIR="${DS_DIR:-/home/user/.steam/steamapps/common/Wreckfest 2 Dedicated Server}"
```

The script expects your server config and save data to be inside a `server_data` subfolder within the server directory. This matches the default behaviour when you launch the server with:

```bat
start /B Wreckfest2.exe /high --server --save-dir=.\server_data
```

So your folder structure should look like this:

```
Wreckfest 2 Dedicated Server/
├── Wreckfest2.exe
├── start_community_server.bat
└── server_data/
    └── server_config.scnf
```

Once `DS_DIR` is set correctly, the script will automatically read `server_data/server_config.scnf` for the game port and log file path.

---

Both scripts support the following commands:

```bash
./wf1_server_example.sh start   # Start the server
./wf1_server_example.sh stop    # Stop the server
./wf1_server_example.sh status  # Show status
./wf1_server_example.sh check   # Show ports + last log lines
```

---

## Selecting scripts in the GUI

Click `📂 WF1 Script wählen` or `📂 WF2 Script wählen` in the menu.  
A file browser opens — pick your `.sh` file. You'll be asked if you want to save the path permanently.

---

## Building from source

```bash
git clone https://github.com/YOUR_USERNAME/queens-main-core
cd queens-main-core
chmod +x build_appimage.sh
./build_appimage.sh
```

`appimagetool` is downloaded automatically if not present.

---

## License

MIT — do whatever you want with it.

