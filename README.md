# Rose's Game Zone (1995-style)

A retro-styled GitHub Pages site that automatically lists files in the `games/` folder for download.

## How it works
- `index.html` is a static page with a Windows 95 vibe.
- `assets/js/list-games.js` calls the GitHub API to list files under `games/` on the `main` branch.
- Each file gets a direct download link and a raw mirror link.

## Usage
1. Put your game files into the `games/` folder.
2. Commit and push to `main`.
3. Visit: https://rosethelocalfem.github.io/

## Notes
- For private repos, the public API won't list files; this repo must be public.
- Large files: GitHub has a 100MB per-file soft limit and a 2GB repository limit. Consider Git LFS for large binaries.
- If you use a custom domain, add a `CNAME` file in the root with your domain.
