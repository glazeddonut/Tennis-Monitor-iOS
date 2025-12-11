# Tennis Monitor iOS App - Getting Started Guide

## Quick Overview

Du har nu en fuldt funktionelt iOS app til at kontrollere Tennis Monitor backend fra din iPhone!

### Hvad kan du gøre?

- ✅ Start/Stop monitoren
- ✅ Se status i realtid
- ✅ Konfigurere præferencer (baner, tider)
- ✅ Se live logs fra monitoren
- ✅ Gemme API-credentials lokalt

## Installation Steps

### 1. Åbn projektet i Xcode

```bash
cd /Users/thomastolborg/Documents/Tennis-Monitor-iOS
open . -a Xcode
```

### 2. Vælg target device

- Øverst i Xcode: Vælg en iPhone simulator eller dit fysiske device

### 3. Build og run

- Tryk `Cmd + R` eller Product → Run

## First Time Setup

### Step 1: Gå til Settings tab

Når appen starter, gå til **Settings** tab (gear ikon).

### Step 2: Indtast connection details

**Base URL:**
```
http://192.168.1.100:8000
```
(Erstat IP-adressen med din Tennismonitor servers IP)

**API Key:**
```
Dit API_KEY fra Tennis Monitor .env file
```

### Step 3: Test forbindelsen

Klik på **"Test Connection"** knappen.

Hvis det virker, ser du: ✓ "Connection OK"

### Step 4: Konfigurer præferencer

Under "Monitor Preferences":

- **Preferred Courts:** `Court11, Court12`
- **Preferred Times:** `18:00, 19:00, 20:00`
- **Check Interval:** `300` (sekunder)
- **Alive Check Hour:** `10` (0-23)

### Step 5: Gem ændringer

Klik **"Save Changes"**

Du skal se: "Settings saved successfully!"

## Using the App

### Monitor Tab (Home)

Her ser du status og kan styre monitoren:

- **Status badge**: Grøn = Kører, Grå = Stoppet
- **Next Check**: Hvor mange sekunder til næste check
- **Checks Today**: Antal gange der er blevet checket
- **Slots Found**: Antal ledige baner der blev fundet

**Knapper:**
- Grøn **"Start Monitor"** - Starter monitoren
- Rød **"Stop Monitor"** - Stopper monitoren

Status opdateres automatisk hvert 10. sekund.

### Settings Tab

Konfigurationsside hvor du kan:

- Ændre backend URL og API key
- Teste forbindelsen
- Sætte præfererede baner og tider
- Justere check interval
- Sætte alarm-tidsrum

Alle ændringer gemmes lokalt på telefonen.

### Logs Tab

Se live logs fra monitoren:

- Viser de seneste linjer fra monitor loggen
- Auto-refresh hvert 5. sekund
- Kan filtrere (20, 50 eller 100 linjer)
- Tryk på en linje for at kopiere den

## Troubleshooting

### "Connection failed"

**Løsning:**
1. Tjek at Tennis Monitor backend kører
2. Tjek IP-adressen er korrekt
3. Tjek at iPhone/simulator er på samme netværk
4. Test i terminal:
   ```bash
   curl http://192.168.1.100:8000/health
   ```

### "Authentication failed - Invalid API key"

**Løsning:**
1. Tjek API_KEY i din Tennis Monitor `.env` file
2. Sørg for at den er korrekt indtastet i app'en
3. Gå til Settings og test igen

### Logs vises ikke

**Løsning:**
1. Tjek at monitoren kører (grønt badge på Monitor tab)
2. Tjek at du har test forbindelsen først
3. Gå til Logs tab og tryk refresh

### Monitor starter/stopper ikke

**Løsning:**
1. Gå til Settings og test forbindelsen
2. Check API key har rettigheder
3. Tjek backend logs for fejl

## File Structure

Projektet er organiseret således:

```
Sources/
├── TennisMonitorApp/
│   └── TennisMonitorApp.swift
│       └── App entry point + tab navigation
│
├── Models/
│   └── APIModels.swift
│       └── Data structures (Status, Config, osv)
│
├── Networking/
│   └── APIClient.swift
│       └── REST API kommunikation
│
└── Views/
    ├── HomeView.swift + HomeViewModel.swift
    │   └── Monitor status og kontrol
    │
    ├── SettingsView.swift + SettingsViewModel.swift
    │   └── Konfiguration
    │
    └── LogsView.swift + LogsViewModel.swift
        └── Log viewer
```

## API Endpoints der bruges

Appen kommunikerer med disse endpoints:

| Endpoint | Metode | Formål |
|----------|--------|--------|
| `/health` | GET | Tjek forbindelse |
| `/api/status` | GET | Monitor status |
| `/api/monitor/start` | POST | Start monitor |
| `/api/monitor/stop` | POST | Stop monitor |
| `/api/config` | GET | Læs config |
| `/api/config/preferences` | POST | Gem preferences |
| `/api/monitor/logs` | GET | Læs logs |

Alle requests (undtagen `/health`) bruger `X-Token` header med dit API key.

## Tips & Tricks

### Auto-refresh
- Monitor tab refresher hvert 10. sekund automatisk
- Logs tab refresher hvert 5. sekund automatisk

### Credentials gemmes lokalt
- Dine API-credentials gemmes i iOS UserDefaults
- De gemmes **ikke** krypteret - for produktiv brug, brug Keychain

### Dark mode
- Appen understøtter både light og dark mode
- Bruger systemindstillingerne automatisk

## Development Notes

Hvis du vil ændre koden:

### Tilføj nyt view
1. Opret fil i `Sources/Views/MyView.swift`
2. Opret en ViewModel fil
3. Importer i `TennisMonitorApp.swift`

### Ændre API endpoints
- Alle requests er i `Sources/Networking/APIClient.swift`
- Tilføj nye metoder efter mønstret for eksisterende

### Ændre data modeller
- Data structures er i `Sources/Models/APIModels.swift`
- Skal matche backend API responses

## Next Steps

1. ✅ Build og run appen
2. ✅ Gå til Settings og sæt op
3. ✅ Gå til Monitor tab og start monitor
4. ✅ Se logs kommer i Logs tab
5. ✅ Generer nogle availabilities på backend for at se slots
6. ✅ Nyd at styre Tennis Monitor fra din iPhone!

## Support

Har du problemer?

1. Check README.md for mere dokumentation
2. Tjek APIClient.swift for API kommunikation
3. Bekræft Tennis Monitor backend kører og er tilgængelig

---

**Version:** 1.0  
**Compatible with:** iOS 17.0+  
**Requires:** Tennis Monitor backend running
