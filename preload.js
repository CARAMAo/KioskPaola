const { contextBridge } = require('electron');
const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

// --- Helper Percorsi ---
// Deve corrispondere alla logica del Main e dell'Installer
function resolveBaseDir() {
  try {
    if (process.env.PORTABLE_EXECUTABLE_DIR) return process.env.PORTABLE_EXECUTABLE_DIR;
    // __dirname in produzione è dentro app.asar, quindi usiamo process.execPath per uscire
    const isPackaged = !process.execPath.includes('node_modules') && !process.execPath.includes('electron.exe'); 
    if (isPackaged) {
        return path.dirname(process.execPath);
    }
    return process.cwd();
  } catch (_) {
    return process.cwd();
  }
}

const BASE_DIR = resolveBaseDir();

// --- Funzioni di Lettura (SOLA LETTURA) ---

function readTotemId() {
  const p = path.join(BASE_DIR, 'kiosk.conf');
  try {
    if (!fs.existsSync(p)) return null;
    const raw = fs.readFileSync(p, 'utf8');
    // Parsing manuale semplice
    const lines = raw.split(/\r?\n/);
    for (const line of lines) {
        const parts = line.split('=');
        if (parts.length === 2 && parts[0].trim() === 'totem_id') {
            return parts[1].trim();
        }
    }
  } catch (e) {
    console.error('[preload] Error reading totem_id', e);
  }
  return null;
}

function loadSponsorsImgs() {
  const dir = path.join(BASE_DIR, 'sponsors');
  const sponsors = [];
  
  if (!fs.existsSync(dir)) {
      console.warn('[preload] Sponsors dir missing:', dir);
      return sponsors;
  }

  try {
    const files = fs.readdirSync(dir, { withFileTypes: true });
    for (const f of files) {
      if (!f.isFile()) continue;
      const ext = path.extname(f.name).toLowerCase();
      if (['.jpg', '.jpeg', '.png'].includes(ext)) {
        const data = fs.readFileSync(path.join(dir, f.name));
        sponsors.push(data.toString('base64'));
      }
    }
  } catch (e) {
    console.error('[preload] Error loading sponsors', e);
  }
  return sponsors;
}

function loadBusPdfs() {
  const dir = path.join(BASE_DIR, 'orari-bus');
  const map = {};

  if (!fs.existsSync(dir)) {
      console.warn('[preload] Bus dir missing:', dir);
      return map;
  }

  try {
    const files = fs.readdirSync(dir, { withFileTypes: true });
    for (const f of files) {
      if (!f.isFile()) continue;
      if (path.extname(f.name).toLowerCase() !== '.pdf') continue;
      
      const name = path.basename(f.name, '.pdf'); // Nome senza estensione
      const data = fs.readFileSync(path.join(dir, f.name));
      map[name] = data.toString('base64');
    }
  } catch (e) {
    console.error('[preload] Error loading PDFs', e);
  }
  return map;
}

function loadTranslations() {
  // usiamo la cartella "translations" creata dall'installer
  const dir = path.join(BASE_DIR, 'translations');
  const out = {};

  const readYaml = (filename) => {
    try {
      const p = path.join(dir, filename);
      if (fs.existsSync(p)) {
        return yaml.load(fs.readFileSync(p, 'utf8')) || {};
      }
    } catch (e) {
      console.error(`[preload] Error reading ${filename}`, e);
    }
    return undefined;
  };

  const it = readYaml('it.yaml');
  if (it) out.it = it;
  
  const en = readYaml('en.yaml');
  if (en) out.en = en;

  return out;
}

// --- API Esposta ---
contextBridge.exposeInMainWorld('api', {
  getTotemId: () => readTotemId(),
  getSponsors: () => loadSponsorsImgs(),
  getAllTranslations: () => loadTranslations(),
  getBusPdfs: () => loadBusPdfs(),
});