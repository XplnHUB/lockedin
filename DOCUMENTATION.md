# LockedIn Technical Documentation

LockedIn is a modular, Bash-based productivity management tool designed for terminal users. It provides a robust framework for managing tasks and projects through a Command Line Interface (CLI) using local JSON data persistence.

## Table of Contents
1. Introduction
2. Key Features
3. System Architecture
4. Requirements and Dependencies
5. Installation Guide
6. Usage Guide
7. Data Management
8. Configuration
9. Developer Information

## 1. Introduction
LockedIn is designed to bridge the gap between simple todo lists and complex project management suites. By operating entirely within the terminal, it integrates seamlessly into developer workflows. It emphasizes speed, simplicity, and local data ownership.

## 2. Key Features
- Interactive Interface: A full-screen interactive menu for intuitive navigation.
- Task Management: Complete Create, Read, Update, and Delete operations for individual tasks.
- Project Organization: Ability to group tasks under specific projects for better oversight.
- Data Persistence: Local storage using standard JSON format, allowing for manual backups or external processing.
- Statistics Dashboard: Real-time calculation of task completion rates and project status.
- Notification System: Integration with system-level notifications for macOS (osascript) and Linux (notify-send).
- Interactive Selection: Optimized for use with fzf, falling back to standard shell selection if unavailable.
- Global Installation: Designed for deployment as an NPM package with persistent data in user home directories.

## 3. System Architecture
The application follows a modular architecture to ensure maintainability and scalability:

- Main Executable (lockedin): Acts as the entry point, handling shell argument parsing and the main menu loop.
- Modules (modules/): Contains specific business logic for tasks, projects, statistics, and views.
- Utilities (utils/): Provides low-level services such as database abstractions (db.sh), UI formatting (ui.sh), and environment sensing (colors.sh).
- Data Layer (data/): Manages JSON files stored in the user's home directory (~/.lockedin/).

## 4. Requirements and Dependencies
- Shell: Bash (version 4.0 or higher recommended).
- Operating System: macOS or primary Linux distributions.
- JSON Processor: jq (required for data manipulation).
- Terminal Styling: tput (standard on most systems).
- Optional Enhancements: fzf (highly recommended for a better selection experience).

## 5. Installation Guide

### Global Installation via NPM
The recommended way to install LockedIn is globally through the Node Package Manager:
```bash
npm install -g lockedin
```

### Manual Installation
1. Clone the repository from GitHub:
   ```bash
   git clone https://github.com/XplnHUB/lockedin.git
   ```
2. Navigate to the directory:
   ```bash
   cd lockedin
   ```
3. Grant execution permissions to the scripts:
   ```bash
   chmod +x lockedin modules/*.sh utils/*.sh
   ```
4. Execute the application:
   ```bash
   ./lockedin
   ```

## 6. Usage Guide

### Interactive Mode
Running the command without arguments opens the main interactive menu:
```bash
lockedin
```
From here, users can navigate to Task Management, Project Management, Today's View, or the Statistics Dashboard.

### CLI Direct Commands
LockedIn supports direct execution of specific modules:
- task: Opens the task management module directly.
- project: Opens the project management module directly.
- today: Displays tasks scheduled for the current date.
- stats: Displays the productivity dashboard.
- --help: Displays usage information and available commands.
- --version: Displays current application version.

## 7. Data Management
Data is stored at ~/.lockedin in two primary JSON files:
- tasks.json: Contains all task records including ID, title, due date, priority, status, and project link.
- projects.json: Contains all project records including ID, title, description, repository link, and status.

### Task Schema
Each task object includes:
- id: Sequential integer identifier.
- title: String description of the task.
- due_date: ISO 8601 formatted date (YYYY-MM-DD).
- priority: Categorization (low, medium, high).
- status: Current state (pending, done).
- project_id: Integer link to a project (optional).

## 8. Configuration
Configuration is managed via the config.env file located in the application directory. It defines path variables and application metadata. When running globally, it defaults to using $HOME/.lockedin for all data storage.

## 9. Developer Information
Developers looking to extend LockedIn can add new scripts to the modules/ directory. Ensure new modules source the appropriate utilities from utils/ using ${BASH_SOURCE[0]} for path resolution to maintain global execution compatibility.
