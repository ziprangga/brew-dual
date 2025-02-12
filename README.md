# 🍺 brew-dual-plugin (Dual Homebrew Management)

I built this plugin to **easily manage packages** on **both Apple Silicon (`/opt/homebrew`) and Intel (`/usr/local`) Homebrew installations**. It’s a simple tool that I use personally, but I figured **someone else might find it useful too!**

---

## 🚀 Why I Made This

I often switch between **x86 and ARM architectures** on macOS, and managing Homebrew packages on both can be a hassle, especially when manage dependencies for dual architecture. This script **installs, uninstalls, update, upgrade and checks packages** across both environments automatically (check available command using **brew-dual help**), so I don’t have to think about it.

## 🚀 Improvement

On version **_1.0.1_** brew-dual support for **_check-binary_** package & **_merge-package_** to universal2

**_Check binary package use_**

```
brew dual check-binary <package>
```

**_Check binary package use_**

```
brew dual merge-package <package>
```

by default merge package replace the package in arm homebrew, but you can change it with --merge-path=<path>
with custom path, make package with universal2 not associated with homebrew

## 📌 Installation

Before installing, ensure that **both Apple Silicon and x86 Homebrew are installed**. If not, the plugin will guide you through the setup when you run:

\*\*\* For safety don't forget to add or replace homebrew path if existing in zprofile, zshrc, bash_profile or bashrc with:

```
if [ "$(uname -m)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi
```

\*\*\* this plugin include with alias for brew arm and x86 architecture:

```
brew-arm
```

\*\*\* can use without "-", like:

```
brew arm list
```

## And

```
brew-x86
```

\*\*\* can use without "-", like:

```
brew x86 list
```

### 1️⃣ Install via Script (Recommended)

Run the following command to install `brew-dual` automatically:

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/ziprangga/brew-dual/main/install.sh)
```

Or using `wget`:

```sh
bash <(wget -qO- https://raw.githubusercontent.com/ziprangga/brew-dual/main/install.sh)
```

## If you need to know or install dual homebrew setup just run:

```sh
brew-dual check-homebrew
```

### 2️⃣ Manual Installation

#### **Clone the Repository**

```sh
git clone https://github.com/ziprangga/brew-dual.git ~/.config/brew-dual
```

#### **Run the Installer**

```sh
~/.config/brew-dual/install.sh
```

### OR

### Add It to Your System PATH Manual

```sh
echo 'export PATH="$HOME/.config/dual-brew/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```

If using **Bash**, replace `~/.zshrc` with `~/.bashrc`.

---

## 🛠️ Usage

### Install a package on both Homebrew versions

```sh
brew dual install <package_name>
```

**Example:**

```sh
brew dual install wget
```

### Uninstall a package from both Homebrew versions

```sh
brew dual uninstall <package_name>
```

**Example:**

```sh
brew dual uninstall wget
```

### List installed packages on both versions

```sh
brew dual list
```

### Get package info on both versions

```sh
brew dual info <package_name>
```

**Example:**

```sh
brew dual info wget
```

---

## 🔍 Manually Checking Installed Packages

If you ever need to check manually, you can use these commands:

- **Apple Silicon (ARM):**
  ```sh
  /opt/homebrew/bin/brew list
  ```
- **Intel (x86_64):**
  ```sh
  /usr/local/bin/brew list
  ```

---

## ❌ Uninstallation

To remove `brew dual`, run:

```sh
~/.config/brew-dual/uninstall.sh
```

## OR

```sh
rm -rf ~/.config/dual-brew
```

Then, remove the plugin from your PATH by editing your shell config file (`~/.zshrc` or `~/.bashrc`) and deleting this line:

```sh
export PATH="$HOME/.config/brew-dual/bin:$PATH"
```

Finally, restart your terminal or run:

```sh
source ~/.zshrc   # If using zsh
source ~/.bashrc  # If using bash
```

---

## 🛠️ Contributing & Development

This project is a **work in progress**, built for personal use. However, contributions are welcome! If you find any bugs or have ideas for improvements, feel free to **reach out** or **open a pull request**.

---

## 🐝 License

This project is licensed under the **MIT License**—use it however you like!
