# Fedora 7.2.2-xwq-zen+ Custom Kernel

Performance-optimized, low-latency custom Linux kernel build tailored for low-end hardware (tested on Intel i3-5005U / HD 5500 Graphics) running Fedora Linux. Designed to minimize input lag, improve gaming responsiveness, and optimize memory management on 8GB RAM systems.

---

## Key Kernel Tweaks
- **CONFIG_HZ=1000**: High timer frequency for minimal input lag and smooth frame delivery.
- **PREEMPT_BUILD / PREEMPT**: Fully preemptible kernel for maximum desktop responsiveness.
- **Zswap / ZRAM Integration**: Aggressive compressed memory caching for low-RAM configurations.
- **Intel i915 DRM Tweaks**: Optimized power management and graphics options for legacy Intel HD Graphics.

---

## Automated Build & Installation (Recommended)

You can build and install the entire kernel package with a single command using the provided automated build script:

```bash
# Clone this repository
git clone [https://github.com/alibuzcuk/fedora-7.2.2-xwq-zen.git](https://github.com/alibuzcuk/fedora-7.2.2-xwq-zen.git)
cd fedora-7.2.2-xwq-zen

# Make the script executable and run it
chmod +x build.sh
./build.sh

```bash
# 1. Install dependencies
sudo dnf groupinstall "Development Tools" "C Development Tools and Libraries" -y
sudo dnf install ncurses-devel bison flex openssl-devel elfutils-libelf-devel bc pahole rpm-build fedora-packager rmtimer dnf-plugins-core git curl -y

# 2. Clone Zen kernel source
mkdir -p ~/kernel_build && cd ~/kernel_build
git clone [https://github.com/zen-kernel/zen-kernel.git](https://github.com/zen-kernel/zen-kernel.git) --depth=1
cd zen-kernel

# 3. Apply config
curl -sSL [https://raw.githubusercontent.com/alibuzcuk/fedora-7.2.2-xwq-zen/main/zen-kernel.config](https://raw.githubusercontent.com/alibuzcuk/fedora-7.2.2-xwq-zen/main/zen-kernel.config) -o .config
make olddefconfig

# 4. Build RPMs
make clean
make -j$(nproc) binrpm-pkg

# 5. Install RPMs and update bootloader
cd ~/rpmbuild/RPMS/x86_64/
sudo dnf install kernel-7.2.2_xwq_zen*.rpm
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo reboot
