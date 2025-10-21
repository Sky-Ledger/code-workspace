# Sky Ledger Code Workspace

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://github.com/PowerShell/PowerShell)

A centralized workspace configuration for Sky Ledger development projects.

## 📋 Overview

This repository provides a VS Code workspace configuration and utility scripts to streamline Sky Ledger project development.

## 🚀 Quick Start

### Prerequisites

- **Git** - Must be available in your system PATH
- **PowerShell 5.1+** or **PowerShell Core 7.0+**
- **Visual Studio Code**

### Setup

1. **Clone the workspace repository:**

   ```bash
   git clone https://github.com/Sky-Ledger/code-workspace.git
   cd code-workspace
   ```

2. **Get dependency repositories:**

   ```powershell
   .\Get-Repos.ps1
   ```

3. **Open the workspace in VS Code:**

   ```bash
   code workspace.code-workspace
   ```

## 🛠️ Components

### 📁 Repository Structure

```plaintext
code-workspace/
├── .github/                    # GitHub configuration
│   └── copilot-instructions.md
├── Get-Repos.ps1              # Dependency repository cloning script
├── workspace.code-workspace   # VS Code workspace configuration
├── LICENSE                    # MIT License
└── README.md                  # This file
```

### 🔧 Get-Repos.ps1 Script

**Purpose:** Automatically clones Sky Ledger dependency repositories to maintain a consistent development environment.

**Features:**

- ✅ **Smart Cloning** - Skips existing repositories automatically  
- ✅ **Error Handling** - Comprehensive error handling and validation
- ✅ **Verbose Logging** - Detailed progress tracking with `-Verbose`
- ✅ **Flexible Input** - Custom repository lists or default Sky Ledger projects
- ✅ **Professional Output** - Color-coded status messages and summary statistics

#### Usage Examples

```powershell
# Clone default Sky Ledger repositories
.\Get-Repos.ps1

# Clone custom repositories
.\Get-Repos.ps1 -Repositories @(
    "https://github.com/microsoft/PowerShell.git",
    "https://github.com/PowerShell/PowerShell-Docs.git"
)

# Enable verbose output for troubleshooting
.\Get-Repos.ps1 -Verbose

# Get comprehensive help
Get-Help .\Get-Repos.ps1 -Detailed
```

## 🔨 VS Code Workspace Configuration

### 🎯 Features

- **PowerShell Integration** - Optimized settings for PowerShell development
- **Code Quality** - Integrated PSScriptAnalyzer with custom rules
- **Extension Recommendations** - Automatic PowerShell extension suggestions
- **Unified Development** - Single workspace for all Sky Ledger projects

### 📦 Recommended Extensions

- **ms-vscode.powershell** - PowerShell language support and IntelliSense

## 💻 Development Workflow

### 1. **Initial Setup**

```powershell
# Clone workspace and dependencies
git clone https://github.com/Sky-Ledger/code-workspace.git
cd code-workspace
.\Get-Repos.ps1
```

### 2. **Daily Development**

```powershell
# Update dependency repositories
.\Get-Repos.ps1

# Open workspace
code workspace.code-workspace
```

### 3. **Adding New Repositories**

```powershell
# Add custom repositories to your environment
.\Get-Repos.ps1 -Repositories @("https://github.com/your-org/new-repo.git")
```

## 📊 Script Features & Benefits

### ✅ **Automation Benefits**

- **Consistent Environment** - Ensures all developers have the same project structure
- **Time Savings** - Eliminates manual repository cloning and setup
- **Error Prevention** - Validates Git availability and handles clone failures gracefully
- **Progress Tracking** - Visual feedback and completion statistics

### 🛡️ **Quality & Reliability**

- **PowerShell Best Practices** - Follows strict coding standards with PSScriptAnalyzer
- **Cross-Platform Support** - Works on Windows PowerShell 5.1+ and PowerShell Core 7.0+
- **Professional Documentation** - Complete comment-based help system

### 📈 **Developer Experience**

- **Rich Output** - Color-coded messages and progress indicators
- **Verbose Logging** - Detailed troubleshooting information when needed
- **Flexible Configuration** - Support for custom repository lists
- **Help Integration** - Full `Get-Help` support with examples

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** your changes: `git commit -m 'Add amazing feature'`
4. **Push** to the branch: `git push origin feature/amazing-feature`
5. **Open** a Pull Request

### Development Guidelines

- Follow PowerShell best practices and coding standards
- Include comprehensive error handling and logging
- Add comment-based help for all functions and scripts
- Test scripts with both Windows PowerShell 5.1 and PowerShell Core 7.0+
- Update documentation for any new features or changes

## 📋 Requirements

### System Requirements

- **Operating System:** Windows 10+, macOS 10.15+, or Linux (Ubuntu 18.04+)
- **PowerShell:** 5.1+ (Windows) or 7.0+ (Cross-platform)
- **Git:** Any recent version available in PATH
- **VS Code:** Latest stable version (recommended)
- **PowerShell Extension:** ms-vscode.powershell

## 🐛 Troubleshooting

### Common Issues

#### Git Command Not Found

```powershell
# Solution: Install Git and ensure it's in your PATH
# Windows: Download from https://git-scm.com/
# macOS: brew install git
# Linux: sudo apt-get install git
```

#### Repository Clone Failures

```powershell
# Use verbose output to diagnose issues
.\Get-Repos.ps1 -Verbose
```

### Getting Help

- **Script Help:** `Get-Help .\Get-Repos.ps1 -Detailed`
- **Examples:** `Get-Help .\Get-Repos.ps1 -Examples`
- **Parameter Info:** `Get-Help .\Get-Repos.ps1 -Parameter Repositories`

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Made with ❤️ by the Sky Ledger Team
