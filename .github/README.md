# Tennis Monitor iOS App

## 🎾 A Native iOS App for Tennis Monitor

Control your Tennis Monitor backend directly from your iPhone with this native SwiftUI app.

### Features

- 📊 **Real-time Monitoring** - View monitor status and statistics
- 🎛️ **Full Control** - Start/stop monitor from your phone
- ⚙️ **Easy Configuration** - Adjust preferences in Settings tab
- 📝 **Live Logs** - Watch monitor logs in real-time
- 🔒 **Secure** - API key authentication with X-Token header
- 💾 **Local Storage** - Credentials saved on device

### Quick Start

```bash
# Clone and open in Xcode
git clone https://github.com/glazeddonut/Tennis-Monitor-iOS
cd Tennis-Monitor-iOS
open . -a Xcode
```

Then:
1. Build and run (Cmd+R)
2. Go to Settings tab
3. Enter backend URL and API key
4. Click "Test Connection"
5. Configure preferences
6. Enjoy!

### Documentation

- **[README.md](README.md)** - Full documentation
- **[GETTING_STARTED.md](GETTING_STARTED.md)** - Quick start guide (Danish)
- **[INSTALL.md](INSTALL.md)** - Detailed installation
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Technical architecture
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Command reference

### Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- Running Tennis Monitor backend
- Network connectivity to backend

### Architecture

- **SwiftUI** - Modern iOS UI framework
- **MVVM** - Clean separation of concerns
- **async/await** - Modern concurrency
- **URLSession** - Network communication
- **UserDefaults** - Local credential storage

### File Structure

```
Sources/
├── TennisMonitorApp/     # App entry point
├── Networking/           # API client
├── Models/              # Data models
└── Views/               # SwiftUI views + ViewModels
```

### Components

- **HomeView** - Monitor status and control
- **SettingsView** - Backend configuration
- **LogsView** - Real-time log viewer
- **APIClient** - REST API communication
- **ViewModels** - State management (MVVM)
- **APIModels** - Data structures

### API Integration

Communicates with all Tennis Monitor REST endpoints:
- `/api/status` - Get monitor status
- `/api/monitor/start|stop` - Control monitor
- `/api/config` - Get/update configuration
- `/api/monitor/logs` - Get logs
- `/health` - Test connection

### Contributing

Pull requests welcome! 

### License

MIT - See LICENSE file

### Related Projects

- [Tennis Monitor Backend](https://github.com/glazeddonut/Tennis-Monitor) - Python backend
- [ntfy.sh](https://ntfy.sh/) - Push notifications

---

**Version:** 1.0  
**Status:** Production Ready ✅
