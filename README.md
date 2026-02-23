# LockedIn

**LockedIn** is a production-quality, terminal-based productivity manager built entirely in Bash. It helps you stay focused by managing your tasks and projects directly from your CLI.

## Features

- **Interactive Menu**: A beautiful main menu for easy navigation.
- **Task Management**: Full CRUD support for tasks with priority, due dates, and project linking.
- **Project Management**: Organize your work into projects.
- **Stats Dashboard**: Visualize your productivity with task completion stats.
- **Today View**: See what's due today at a glance.
- **Filtering**: View overdue or high-priority tasks easily.
- **Notifications**: Native OS notifications for task actions (macOS and Linux).
- **FZF Integration**: Use `fzf` for lightning-fast selection (falls back to `select` if not installed).

## Installation

### Via NPM (Recommended)
You can install LockedIn globally using NPM:

```bash
npm install -g lockedin
```

### Manual Installation
1. **Clone the repository**:
   ```bash
   git clone https://github.com/XplnHUB/lockedin.git
   cd lockedin
   ```

2. **Ensure dependencies are installed**:
   - `jq` (required for JSON management)
   - `fzf` (recommended for interactive selection)
   - `tput` (usually pre-installed for colors)

3. **Make executable and run**:
   ```bash
   chmod +x lockedin modules/*.sh utils/*.sh
   ./lockedin
   ```

## Usage

- Run `./lockedin` to enter the interactive menu.
- Direct commands:
  - `./lockedin task`: Manage tasks
  - `./lockedin project`: Manage projects
  - `./lockedin today`: View today's tasks
  - `./lockedin stats`: View dashboard
  - `./lockedin --help`: View help

## Folder Structure

```
lockedin/
├── lockedin          # Main executable
├── modules/          # Core logic modules
├── utils/            # Utility scripts (colors, db, ui)
├── data/             # JSON data storage
└── config.env        # App configuration
```

Stay locked in.
