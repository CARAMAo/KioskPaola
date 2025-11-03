const { contextBridge } = require('electron');
const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

function resolveBusDir() {
  try {
    // In produzione: cartella accanto all'eseguibile (gestisce anche "portable")
    const prodBase = process.env.PORTABLE_EXECUTABLE_DIR || path.dirname(process.execPath);
    const prodDir = path.join(prodBase, 'orari-bus');
    if (fs.existsSync(prodDir)) return prodDir;
  } catch (_) {}
  
  try {
    // In sviluppo: root del progetto (cwd)
    const devDir = path.join(process.cwd(), 'orari-bus');
    if (fs.existsSync(devDir)) return devDir;
  } catch (_) {}

  try {
    // In sviluppo: vicino a questo file preload.js
    const hereDir = path.join(__dirname, 'orari-bus');
    if (fs.existsSync(hereDir)) return hereDir;
  } catch (_) {}

  return null;
}
function loadBusPdfs() {
  const dir = resolveBusDir();
  if (!dir) {
    console.warn('[preload] orari-bus directory not found');
  } else {
    console.log('[preload] Using orari-bus dir:', dir);
  }
  const map = {};
  if (!dir) return map;
  try {
    const files = fs.readdirSync(dir, { withFileTypes: true });
    for (const f of files) {
      if (!f.isFile()) continue;
      const ext = path.extname(f.name).toLowerCase();
      if (ext !== '.pdf') continue;
      const name = path.basename(f.name, ext);
      
      const data = fs.readFileSync(path.join(dir, f.name));
      map[name] = data.toString('base64');
    }
    console.log('[preload] PDFs found:', Object.keys(map));
  } catch (e) {
    console.error('Error reading orari-bus PDFs', e);
  }
  return map;
}

function resolveSponsorsDir(){
  try {
    const port = process.env.PORTABLE_EXECUTABLE_DIR && path.join(process.env.PORTABLE_EXECUTABLE_DIR, 'sponsors');
    if (port && fs.existsSync(port)) return port;
  } catch (_) {}
  try {
    const dev = path.join(process.cwd(), 'sponsors');
    if (fs.existsSync(dev)) return dev;
  } catch (_) {}

  return null;
}

function loadSponsorsImgs(){
    const dir = resolveSponsorsDir();
  if (!dir) {
    console.warn('[preload] sponsors directory not found');
  } else {
    console.log('[preload] Using sponsors dir:', dir);
  }
  const sponsors = []
  if (!dir) return sponsors;
  try {
    const files = fs.readdirSync(dir, { withFileTypes: true });
    for (const f of files) {
      if (!f.isFile()) continue;
      const ext = path.extname(f.name).toLowerCase();
      if (ext !== '.jpg' && ext !== '.jpeg' && ext !== '.png') continue;
      
      const data = fs.readFileSync(path.join(dir, f.name));
      sponsors.push(data.toString('base64'));
    }
    console.log('[preload] Sponsors found:', Object.length(map));
  } catch (e) {
    console.error('Error reading sponsors', e);
  }
  return sponsors;
}


function resolveLocalesDir() {

  try {
    const port = process.env.PORTABLE_EXECUTABLE_DIR && path.join(process.env.PORTABLE_EXECUTABLE_DIR, 'locales');
    if (port && fs.existsSync(port)) return port;
  } catch (_) {}
  try {
    const dev = path.join(process.cwd(), 'locales');
    if (fs.existsSync(dev)) return dev;
  } catch (_) {}

  return null;
}

contextBridge.exposeInMainWorld('api', {
  getSponsors: () => loadSponsorsImgs(),
  // Restituisce entrambi i locales (se presenti) in un'unica chiamata
  getAllLocales: () => {
    try {
      const base = resolveLocalesDir();
      const out = {};
      if (!base) return out;
      const readYaml = (p) => {
        try {
          if (fs.existsSync(p)) {
            const raw = fs.readFileSync(p, 'utf8');
            return yaml.load(raw) || {};
          }
        } catch (e) {
          console.error('[preload] getAllLocales parse error for', p, e);
        }
        return undefined;
      };
      const it = readYaml(path.join(base, 'it.yaml'));
      if (it) out.it = it;
      const en = readYaml(path.join(base, 'en.yaml'));
      if (en) out.en = en;
      return out;
    } catch (e) {
      console.error('[preload] getAllLocales error', e);
      return {};
    }
  },
  // Ritorna un oggetto { <nomePdfSenzaEstensione>: <base64> }
  getBusPdfs: () => loadBusPdfs(),
});
