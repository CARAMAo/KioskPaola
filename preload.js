const { contextBridge } = require('electron');
const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

function resolveBusDir() {
  try {
    // In produzione: cartella accanto all'eseguibile
    const prodBase = path.dirname(process.execPath);
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
  console.log('[preload] loadBusPdfs called');
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

function resolveLocalesDir() {
  try {
    const ext = path.join(path.dirname(process.execPath), 'locales');
    if (fs.existsSync(ext)) return ext;
  } catch (_) {}
  try {
    const dev = path.join(process.cwd(), 'locales');
    if (fs.existsSync(dev)) return dev;
  } catch (_) {}
  try {
    const res = path.join(process.resourcesPath || '', 'locales');
    if (fs.existsSync(res)) return res;
  } catch (_) {}
  return null;
}

contextBridge.exposeInMainWorld('api', {
  // Legge un singolo locale (yaml/json) dalla cartella esterna
  readLocale: (lang) => {
    try {
      const base = resolveLocalesDir();
      if (!base) return null;
      const candidates = [
        path.join(base, `${lang}.yaml`),
        path.join(base, `${lang}.yml`),
        path.join(base, `${lang}.json`),
      ];
      for (const p of candidates) {
        if (fs.existsSync(p)) return fs.readFileSync(p, 'utf8');
      }
    } catch (e) {
      console.error('readLocale error', e);
    }
    return null;
  },
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
