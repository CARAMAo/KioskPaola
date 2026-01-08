const { app, BrowserWindow, screen } = require('electron');
const path = require('path');
const fs = require('fs');

// --- Helper Percorsi ---
function resolveBaseDir() {
  // Supporto per Portable Apps (opzionale) o Standard Install
  if (process.env.PORTABLE_EXECUTABLE_DIR) return process.env.PORTABLE_EXECUTABLE_DIR;
  
  // In Produzione: cartella dell'eseguibile (es. C:\Program Files\KioskPaola)
  // In Sviluppo: root del progetto
  return app.isPackaged ? path.dirname(process.execPath) : process.cwd();
}

// --- Configurazione ---
function loadAppConfig() {
  const base = resolveBaseDir();
  const configPath = path.join(base, 'kiosk.conf');
  
  const config = { kioskMode: false, totemId: null };
  
  try {
    if (fs.existsSync(configPath)) {
      const raw = fs.readFileSync(configPath, 'utf8');
      const lines = raw.split(/\r?\n/);
      
      for (const line of lines) {
        const trimmed = line.trim();
        if (!trimmed || trimmed.startsWith('#')) continue;
        
        const idx = trimmed.indexOf('=');
        if (idx === -1) continue;
        
        const key = trimmed.slice(0, idx).trim().toLowerCase();
        const val = trimmed.slice(idx + 1).trim();

        if (key === 'kiosk_mode') {
           config.kioskMode = (val === '1' || val === 'true');
        } else if (key === 'totem_id') {
           config.totemId = val;
        }
      }
      console.log(`[main] Config loaded from ${configPath}:`, config);
    } else {
      console.warn(`[main] Config file not found at ${configPath}. Using defaults.`);
    }
  } catch (e) {
    console.error('[main] Error reading config:', e);
  }
  
  return config;
}

function createWindow() {
  const primaryDisplay = screen.getPrimaryDisplay();
  const { height: displayHeight } = primaryDisplay.size;
  const { width: availableWidth } = primaryDisplay.workAreaSize;

  // Logica 9:16 verticale
  const windowHeight = displayHeight;
  const windowWidth = Math.round((windowHeight * 9) / 16);
  const initialWidth = Math.min(windowWidth, availableWidth);

  const { kioskMode } = loadAppConfig();

  const win = new BrowserWindow({
    width: initialWidth,
    height: windowHeight,
    resizable: true,     
    kiosk: kioskMode,  // Attivato solo se kiosk.conf dice kiosk_mode=1
    frame: true,       // In kiosk mode il frame viene nascosto automaticamente da Windows
    icon: path.join(__dirname, 'build/icon.ico'), // Opzionale
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: false,
    },
  });

  const isDev = !app.isPackaged;
  if (isDev) {
    const devUrl = process.env.DEV_SERVER_URL || 'http://127.0.0.1:4000';
    win.loadURL(devUrl).catch((e) => console.error(e));
  } else {
    win.loadFile(path.join(__dirname, 'dist/index.html')).catch((e) => console.error(e));
  }

  win.once('ready-to-show', () => {
    win.show();
  });
}

app.whenReady().then(() => {
  // NOTA: Non chiamiamo più ensureExternalAssets() perché ci pensa l'installer.
  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});