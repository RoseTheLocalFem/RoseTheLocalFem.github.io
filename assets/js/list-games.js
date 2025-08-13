// Fetch and render the files from the 'games' folder using GitHub API
(function(){
  const owner = 'RoseTheLocalFem';
  const repo = 'RoseTheLocalFem.github.io';
  const path = 'games';
  const api = `https://api.github.com/repos/${owner}/${repo}/contents/${path}`;

  const list = document.getElementById('games-list');
  const status = document.getElementById('status');

  function humanSize(bytes){
    if(bytes === 0 || bytes === undefined) return '0 B';
    const units = ['B','KB','MB','GB'];
    let i = 0;
    let v = bytes;
    while(v >= 1024 && i < units.length-1){ v/=1024; i++; }
    return `${v.toFixed(v<10?1:0)} ${units[i]}`;
  }

  function render(items){
    list.innerHTML = '';
    if(!Array.isArray(items) || items.length === 0){
      list.innerHTML = '<li>No games uploaded yet. Drop files into the \'games/\' folder and push.</li>';
      return;
    }
    // Prefer common game packages/extensions
    const preferredOrder = ['.zip','.7z','.rar','.exe','.apk','.love','.p8','.nes','.gba','.gb','.smc','.sfc'];
    items.sort((a,b)=>{
      const ai = preferredOrder.findIndex(ext => a.name.toLowerCase().endsWith(ext));
      const bi = preferredOrder.findIndex(ext => b.name.toLowerCase().endsWith(ext));
      return (ai===-1?99:ai) - (bi===-1?99:bi) || a.name.localeCompare(b.name);
    });

    for(const f of items){
      if(f.type !== 'file') continue;
      const li = document.createElement('li');
      const link = document.createElement('a');
      link.href = f.download_url;
      link.textContent = f.name;
      link.setAttribute('download', f.name);

  const meta = document.createElement('span');
  meta.className = 'file-meta';
  meta.textContent = `(${humanSize(f.size)})`;

      const mirror = document.createElement('a');
      mirror.textContent = 'mirror';
      mirror.className = 'button';
      mirror.style.marginLeft = '10px';
      mirror.href = `https://raw.githubusercontent.com/${owner}/${repo}/main/${path}/${encodeURIComponent(f.name)}`;

      li.appendChild(link);
      li.appendChild(meta);
      li.appendChild(mirror);
      list.appendChild(li);
    }
  }

  fetch(api, { headers: { 'Accept': 'application/vnd.github.v3+json' }})
    .then(r => {
      if(!r.ok) throw new Error('Failed to list games (' + r.status + ')');
      return r.json();
    })
    .then(items => { render(items); status.textContent = 'Done.'; })
    .catch(err => { status.textContent = 'Error: ' + err.message; });
})();
