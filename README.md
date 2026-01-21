# dex-submit

Firefox extension that auto-submits Dex login device code flow.

## Installation

1. Download the latest `.xpi` file from [releases](https://github.com/p-wall/dex-submit/releases)
2. Open Firefox and navigate to `about:addons`
3. Click the gear icon and select "Install Add-on From File"
4. Select the downloaded `.xpi` file
5. Click on the extension and go to "Preferences" to configure your Dex domains

## Configuration

After installation, you must configure which domains the extension should work on:

1. Go to `about:addons` in Firefox
2. Find "dex-submit" and click on it
3. Click the "Preferences" tab
4. Enter your Dex domain(s), one per line (e.g., `dex.example.com`)
5. Click "Save"

The extension will only auto-submit on the domains you configure.

## Development

### Prerequisites

- `node` and `npm` - For installing web-ext locally
- `jq` - JSON processor
- `hub` - GitHub CLI tool

Install on Ubuntu/Debian:
```bash
sudo apt install jq hub
```

### Building

1. Install dependencies:
```bash
npm install
```

2. Copy `.env.example` to `.env` and add your Firefox Add-ons API credentials:
   - Get API key/secret from https://addons.mozilla.org/en-US/developers/addon/api/key/

3. For releases, add your GitHub token to `~/.github_token`

4. Build the extension:
```bash
make build
```

5. Create a release:
```bash
make release
```

## How it works

The extension injects a content script on your configured Dex domains at `/device` paths that:
1. Checks if the current domain is in your configured list
2. Waits 50ms for the page to load
3. Checks if there's a login error (and exits if so)
4. If login was successful, automatically closes the tab
5. Otherwise, automatically clicks the submit button
