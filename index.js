const { app, BrowserWindow, screen } = require('electron');
const path = require('path');
const fs = require('fs');


// --- Config: kiosk.conf next to the exe (or cwd in dev) ---
function resolveConfigPath() {
  const portableBase = process.env.PORTABLE_EXECUTABLE_DIR;
  const base = app.isPackaged ? (portableBase || path.dirname(process.execPath)) : process.cwd();
  return path.join(base, 'kiosk.conf');
}

function ensureConfigFileExists(p) {
  try {
    if (!fs.existsSync(p)) {
      fs.writeFileSync(p, 'kiosk_mode=0\n'); // default OFF to keep current behavior
      console.log('[main] Created default config at', p);
    }
  } catch (e) {
    console.error('[main] Failed to create config file', p, e);
  }
}

function readConfigKV(p) {
  const map = {};
  try {
    const raw = fs.readFileSync(p, 'utf8');
    const lines = raw.split(/\r?\n/);
    for (const line of lines) {
      if (!line) continue;
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith('#') || trimmed.startsWith('//') || trimmed.startsWith(';')) continue;
      const idx = trimmed.indexOf('=');
      if (idx === -1) continue;
      const key = trimmed.slice(0, idx).trim().toLowerCase();
      const val = trimmed.slice(idx + 1).trim();
      if (key) map[key] = val;
    }
  } catch (e) {
    console.error('[main] Failed to read config file', p, e);
  }
  return map;
}

function isFalsyString(s) {
  if (s == null) return true; // treat missing as falsy for kiosk
  const v = String(s).trim().toLowerCase();
  return v === '' || v === '0' || v === 'false' || v === 'no' || v === 'off';
}

function loadAppConfig() {
  const cfgPath = resolveConfigPath();
  ensureConfigFileExists(cfgPath);
  const kv = readConfigKV(cfgPath);
  const rawMode = kv['kiosk_mode'];
  const kioskMode = !isFalsyString(rawMode);
  console.log('[main] kiosk mode:', kioskMode ? 'ON' : 'OFF', 'via', cfgPath);
  return { kioskMode, configPath: cfgPath };
}



function createWindow() {
  const primaryDisplay = screen.getPrimaryDisplay();
  const { height: displayHeight } = primaryDisplay.size;
  const { width: availableWidth } = primaryDisplay.workAreaSize;

  const windowHeight = displayHeight;
  const windowWidth = Math.round((windowHeight * 9) / 16);
  const horizontalPadding = 0 ;
  const initialWidth = Math.min(windowWidth + horizontalPadding, availableWidth);

  console.log(windowWidth,windowHeight)
  const { kioskMode } = loadAppConfig();
  const win = new BrowserWindow({
    width: initialWidth,
    height: windowHeight,
    resizable: true,     // allow resize in non-kiosk
    kiosk: !!kioskMode,  // control via kiosk.conf (kiosk_mode=0/1)
    frame:true,

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
    win.loadURL(devUrl).catch((e) => {
      console.error('[main] Failed to load dev URL', devUrl, e);
    });
  } else {
    win.loadFile(path.join(__dirname, 'dist/index.html')).catch((e) => {
      console.error('[main] Failed to load index.html', e);
    });
  }

  win.once('ready-to-show', () => {
    try { win.show(); } catch {}
  });
}

function ensureDirp(dirPath) {
  try {
    if (!fs.existsSync(dirPath)) fs.mkdirSync(dirPath, { recursive: true });
  } catch (e) {
    console.error('[main] Failed to create directory', dirPath, e);
  }
}

function findDefaultLocaleFile(name) {
  const candidates = [
    path.join(process.resourcesPath || '', 'locales', name),
    // dev paths
    path.join(__dirname, 'src', 'locales', name),
    path.join(process.cwd(), 'src', 'locales', name),
    path.join(__dirname, 'locales', name),
  ].filter(Boolean);
  for (const p of candidates) {
    try { if (fs.existsSync(p)) return p; } catch (_) {}
  }
  return null;
}

function copyIfMissing(src, dest) {
  try {
    if (!src) return;
    if (!fs.existsSync(dest)) {
      fs.copyFileSync(src, dest);
      console.log('[main] Copied default file ->', dest);
    }
  } catch (e) {
    console.error('[main] Failed to copy', src, 'to', dest, e);
  }
}

function findDefaultBusDir() {
  const candidates = [
    path.join(process.resourcesPath || '', 'bus-pdfs'),
    // dev paths
    path.join(__dirname, 'src', 'bus-pdfs'),
    path.join(process.cwd(), 'src', 'bus-pdfs'),
    path.join(__dirname, 'bus-pdfs'),
  ].filter(Boolean);
  for (const p of candidates) {
    try { if (fs.existsSync(p)) return p; } catch (_) {}
  }
  return null;
}

function copyBusDefaultsIfMissing(defaultDir, destDir) {
  if (!defaultDir || !destDir) return;
  try {
    const entries = fs.readdirSync(defaultDir, { withFileTypes: true });
    for (const e of entries) {
      if (!e.isFile()) continue;
      const ext = path.extname(e.name).toLowerCase();
      if (ext !== '.pdf') continue;
      const src = path.join(defaultDir, e.name);
      const dst = path.join(destDir, e.name);
      copyIfMissing(src, dst);
    }
  } catch (e) {
    console.error('[main] Failed to copy bus defaults', e);
  }
}

function ensureExternalAssets() {
  // In portable builds, the exe extracts to a temp dir; use the real exe folder if provided

  const portableBase = process.env.PORTABLE_EXECUTABLE_DIR;
  const base = app.isPackaged ? (portableBase || path.dirname(process.execPath)) : process.cwd();
  const localesDir = path.join(base, 'locales');
  const busDir = path.join(base, 'orari-bus');
  const sponsorsDir = path.join(base, 'sponsors');

  ensureDirp(localesDir);
  ensureDirp(busDir);
  ensureDirp(sponsorsDir);

  // Ensure locales defaults
  const itSrc = findDefaultLocaleFile('it.yaml');
  const enSrc = findDefaultLocaleFile('en.yaml');
  if (itSrc) copyIfMissing(itSrc, path.join(localesDir, 'it.yaml'));
  if (enSrc) copyIfMissing(enSrc, path.join(localesDir, 'en.yaml'));

  // Ensure bus PDFs defaults: copy missing PDFs into orari-bus
  const busDefaults = findDefaultBusDir();
  if (busDefaults) copyBusDefaultsIfMissing(busDefaults, busDir);
}


app.whenReady().then(() => {

  ensureExternalAssets();
  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});
