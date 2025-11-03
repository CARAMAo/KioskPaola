const { app, BrowserWindow, screen } = require('electron');
const path = require('path');


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
    // Match Vite dev server port from vite.config.js
    win.loadURL('http://localhost:4000');
  } else {
    win.loadFile(path.join(__dirname, 'dist/index.html'));
  }
}

app.whenReady().then(() => {
  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});
