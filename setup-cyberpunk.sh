#!/bin/bash

echo "🚀 Starting Cyberpunk Terminal Setup for Kali Linux..."

# Detect OS and install required packages
if [ -f /etc/debian_version ]; then
    echo "🔹 Detected Debian-based OS. Installing packages..."
    sudo apt update && sudo apt install -y tmux cmatrix hollywood fastfetch btop
else
    echo "❌ Unsupported OS! Exiting."
    exit 1
fi

# Ensure we're in the home directory
cd ~

# 🔹 Modify .bashrc to Auto-Start Fastfetch at Login with Clear Screen
echo "🔹 Configuring Fastfetch to run at login..."
if ! grep -q "fastfetch" ~/.bashrc; then
    echo -e "\n# Run Fastfetch at login\nclear\nfastfetch" >> ~/.bashrc
fi

# 🔹 Set up Tmux Screensaver with Hollywood (Idle for 60 Seconds)
echo "🔹 Configuring Tmux to run Hollywood after 300 seconds of inactivity..."
cat <<EOF > ~/.tmux.conf
set -g lock-command "hollywood; clear"
set -g lock-after-time 60
EOF

# 🔹 Auto-Start Tmux on SSH Login
echo "🔹 Ensuring Tmux starts on SSH login..."
if ! grep -q "tmux attach-session -t ssh_tmux" ~/.bashrc; then
    echo -e "\n# Auto-start tmux in SSH sessions\nif [[ -z \"\$TMUX\" ]] && [[ \"\$SSH_TTY\" ]]; then\n    tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux\nfi" >> ~/.bashrc
fi

# Apply changes
echo "🔹 Applying changes..."
source ~/.bashrc
tmux source ~/.tmux.conf

echo "✅ Setup Complete! Reboot or log out and back in to see the changes."
