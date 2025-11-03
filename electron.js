const { app, BrowserWindow, screen } = require('electron');
const path = require('path');
const fs = require('fs');


function createWindow() {
  const primaryDisplay = screen.getPrimaryDisplay();
  const { height: displayHeight } = primaryDisplay.size;
  const { width: availableWidth } = primaryDisplay.workAreaSize;

  const windowHeight = displayHeight;
  const windowWidth = Math.round((windowHeight * 9) / 16);
  const horizontalPadding = Math.round(windowHeight * 0.05);
  const initialWidth = Math.min(windowWidth + horizontalPadding, availableWidth);

  const win = new BrowserWindow({
    width: initialWidth,
    height: windowHeight,
    resizable: true,     // kiosk fullscreen
    kiosk: false,          // blocca uscita con ALT+F4
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: false,
    },
  });

  const isDev = !app.isPackaged;
  if (isDev) {
    win.loadURL('http://localhost:4000');
  } else {
    win.loadFile(path.join(__dirname, 'dist/index.html'));
  }
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
    // In packaged app, resourcesPath may contain locales/
    path.join(process.resourcesPath || '', 'locales', name),
    // Dev paths
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

function ensureExternalAssets() {
  const base = app.isPackaged ? path.dirname(process.execPath) : process.cwd();
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
