/**
 * Copies the Next.js static export from `out/` into `docs/` for GitHub Pages.
 * Run automatically after `next build` via the build script.
 */
const fs = require('fs');
const path = require('path');

const src = path.join(__dirname, '..', 'out');
const dest = path.join(__dirname, '..', 'docs');

function copyRecursive(srcDir, destDir) {
  if (!fs.existsSync(destDir)) {
    fs.mkdirSync(destDir, { recursive: true });
  }
  const entries = fs.readdirSync(srcDir, { withFileTypes: true });
  for (const entry of entries) {
    const srcPath = path.join(srcDir, entry.name);
    const destPath = path.join(destDir, entry.name);
    if (entry.isDirectory()) {
      copyRecursive(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

// Clean docs/ first (remove old files)
if (fs.existsSync(dest)) {
  fs.rmSync(dest, { recursive: true, force: true });
}

console.log(`[*] Copying ${src} → ${dest}`);
copyRecursive(src, dest);

// Create .nojekyll in docs/ so GitHub Pages serves directories starting with '_' (e.g. _next/)
fs.writeFileSync(path.join(dest, '.nojekyll'), '');
console.log('[+] Created .nojekyll file in docs/');
console.log('[+] Done! docs/ is ready for GitHub Pages.');
