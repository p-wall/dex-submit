browser.runtime.onMessage.addListener((message, sender) => {
  if (message.action === "closeTab") {
    browser.tabs.remove(sender.tab.id);
  }
});
