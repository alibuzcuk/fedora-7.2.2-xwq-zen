#!/usr/bin/env bash
# ==============================================================================
# Automated Fedora Zen Kernel Build Script
# Targeted for low-latency / low-end hardware (Intel i3-5005U / HD 5500)
# ==============================================================================

set -e

# Configuration
BUILD_DIR="${HOME}/kernel_build"
ZEN_REPO="https://github.com/zen-kernel/zen-kernel.git"
CONFIG_URL="https://raw.githubusercontent.com/alibuzcuk/fedora-7.2.2-xwq-zen/main/zen-kernel.config"

echo "==> [1/6] Installing required build toolchain and RPM tools..."
sudo dnf groupinstall "Development Tools" "C Development Tools and Libraries" -y
sudo dnf install ncurses-devel bison flex openssl-devel elfutils-libelf-devel bc pahole rpm-build fedora-packager rmtimer dnf-plugins-core git curl -y

echo "==> [2/6] Preparing workspace directory..."
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

if [ ! -d "zen-kernel" ]; then
    echo "==> Cloning Zen kernel repository..."
    git clone "${ZEN_REPO}" --depth=1
fi

cd zen-kernel

echo "==> [3/6] Applying Zen kernel configuration..."
if [ -f "../../zen-kernel.config" ]; then
    cp "../../zen-kernel.config" .config
else
    curl -sSL "${CONFIG_URL}" -o .config
fi

make olddefconfig

echo "==> [4/6] Starting RPM compilation (-j$(nproc))..."
make clean
make -j$(nproc) binrpm-pkg

echo "==> [5/6] Compilation complete. Installing generated RPM packages..."
RPM_PATH="${HOME}/rpmbuild/RPMS/x86_64"

if ls ${RPM_PATH}/kernel-*.rpm 1> /dev/null 2>&1; then
    sudo dnf install ${RPM_PATH}/kernel-*.rpm -y
else
    echo "ERROR: RPM packages not found in ${RPM_PATH}"
    exit 1
fi

echo "==> [6/6] Updating GRUB bootloader..."
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

echo "==> All done! Reboot your system to load the new Zen kernel."
