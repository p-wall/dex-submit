// Check if current domain is in the configured list
browser.storage.sync.get('dexDomains').then((result) => {
  const dexDomains = result.dexDomains || [];
  const currentDomain = window.location.hostname;

  // Only run on configured domains and /device path
  if (!dexDomains.includes(currentDomain) || !window.location.pathname.startsWith('/device')) {
    return;
  }

  setTimeout(function() {
    if (document.getElementById('login-error')) return

    if (Array.from(document.getElementsByTagName("h2")).filter(x => x.textContent.includes("Login Successful")).length) {
      browser.runtime.sendMessage({action: "closeTab"});
      return;
    }

    const submitButton = document.getElementById("submit-login");
    if (submitButton) {
      submitButton.click();
    }
  }, 50);
});
