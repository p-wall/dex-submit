function loadOptions() {
  browser.storage.sync.get('dexDomains').then((result) => {
    if (result.dexDomains) {
      document.getElementById('domains').value = result.dexDomains.join('\n');
    }
  });
}

function saveOptions(e) {
  e.preventDefault();

  const domainsText = document.getElementById('domains').value;
  const domains = domainsText
    .split('\n')
    .map(d => d.trim())
    .filter(d => d.length > 0);

  browser.storage.sync.set({
    dexDomains: domains
  }).then(() => {
    const status = document.getElementById('status');
    status.textContent = 'Settings saved!';
    status.className = 'status success';
    setTimeout(() => {
      status.style.display = 'none';
    }, 3000);
  });
}

document.addEventListener('DOMContentLoaded', loadOptions);
document.getElementById('save').addEventListener('click', saveOptions);
