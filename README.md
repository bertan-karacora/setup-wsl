# Setup WSL

A collection of shell scripts and configuration templates for a quick and consistent setup of Ubuntu-based WSL2 environments.

## Setup

1. Start WSL by typing `wsl` from within a Windows shell. For the installation, refer to the [official documentation](https://learn.microsoft.com/en-us/windows/wsl/install).

2. Download this repository. If you want to setup `git` using the routines in this repository, you may use `wget`:

    ```bash
    cd ~
    sudo apt install unzip wget
    wget https://github.com/bertan-karacora/setup-wsl/archive/refs/heads/main.zip
    unzip main.zip
    rm main.zip
    mv setup-wsl-main setup-wsl
    ```

3. Give execution permission for the setup script:

    ```bash
    cd setup-wsl
    chmod +x setup.sh
    ```

4. Run the setup script (note that it requires sudo rights and will prompt you for a password):

    ```bash
    ./setup.sh
    ```

5. Open a new shell for the configurations to take effect.

## Usage

You can now use the predefined shell macros, aliases, and globally accessible scripts from the `libs`, `aliases`, and `scripts` directories. Please inspect the contents of these directories for details. If you ever want to add a function, an alias, or a helper script to your global shell environment, simply add them in the existing directories or files and they will automatically become available in new shells.
