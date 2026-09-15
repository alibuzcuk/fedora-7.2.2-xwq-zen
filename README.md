# Fedora 7.2.2-xwq-zen+ Custom Kernel

A performance-optimized, low-latency Linux kernel build tailored for low-end hardware. Designed to minimize input lag, improve gaming responsiveness, and optimize memory management on resource-constrained systems.

**Target Hardware:** Intel i3-5005U / Intel HD Graphics 5500 / 8GB RAM  
**Base Distro:** Fedora Linux (with Zen Kernel)  
**Focus:** Desktop responsiveness, gaming fluidity, efficient memory utilization

---

## Features & Optimizations

### Timer & Preemption
- **CONFIG_HZ=1000** - High-frequency timer interrupt (1000 Hz) for minimal latency and smooth frame delivery
- **PREEMPT_BUILD** - Fully preemptible kernel ensuring maximum interactivity and reduced desktop lag

### Memory Management
- **Zswap / ZRAM Integration** - Aggressive compressed memory caching to maximize available RAM on 8GB systems
- **Optimized page cache behavior** - Balanced swap vs. in-memory caching for gaming workloads

### Graphics & Power
- **Intel i915 DRM Tweaks** - Fine-tuned power management and frequency scaling for Intel HD Graphics 5500
- **Optimized PSR (Panel Self Refresh)** - Reduced power consumption without sacrificing responsiveness

### I/O & Network
- **Low-latency I/O scheduler tuning** - Better responsiveness during disk/SSD operations
- **Network stack optimization** - Reduced packet processing jitter for online gaming

---


### What the Build Script Does

1. **Installs build dependencies** - Fetches all required development tools, kernel build utilities, and libraries
2. **Clones Zen Kernel source** - Pulls the latest stable Zen Kernel repository (shallow clone for speed)
3. **Applies optimized config** - Downloads and applies the custom `zen-kernel.config` with all performance tweaks
4. **Builds kernel RPMs** - Compiles kernel and generates native Fedora RPM packages using all available CPU cores
5. **Installs & updates bootloader** - Installs RPMs and regenerates GRUB configuration, ready to reboot

**Estimated build time:** 30–60 minutes (depending on CPU cores)

---

## Build Instructions

If you prefer step-by-step control or need to modify the build process, follow these instructions:

### Step 1: Install Build Dependencies

```bash
sudo dnf groupinstall "Development Tools" "C Development Tools and Libraries" -y
sudo dnf install ncurses-devel bison flex openssl-devel elfutils-libelf-devel bc pahole \
  rpm-build fedora-packager rmtimer dnf-plugins-core git curl perl -y
```

### Step 2: Clone Zen Kernel Source

```bash
mkdir -p ~/kernel_build
cd ~/kernel_build
git clone https://github.com/zen-kernel/zen-kernel.git --depth=1
cd zen-kernel
```

### Step 3: Apply Custom Configuration

Download and apply the optimized kernel configuration:

```bash
curl -sSL https://raw.githubusercontent.com/alibuzcuk/fedora-7.2.2-xwq-zen/main/zen-kernel.config -o .config
make olddefconfig
```

The `olddefconfig` command merges the custom config with Zen Kernel defaults, asking for new options if any.

### Step 4: Build Kernel RPMs

Clean any previous builds and compile:

```bash
make clean
make -j$(nproc) binrpm-pkg
```

This uses all available CPU cores to parallelize compilation. Depending on your hardware, this may take 30–90 minutes.

### Step 5: Install & Configure Bootloader

Once compilation finishes, install the generated RPM packages:

```bash
cd ~/rpmbuild/RPMS/x86_64/
sudo dnf install kernel-7.2.2_xwq_zen*.rpm
```

Regenerate GRUB configuration to include the new kernel:

```bash
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

### Step 6: Reboot

```bash
sudo reboot
```

After rebooting, verify the new kernel is active:

```bash
uname -r
```

You should see output containing `7.2.2-xwq-zen` or similar.

---

## Prebuilt RPM Releases

Pre-compiled kernel RPM packages are available on the GitHub Releases page. If you prefer not to build from source, download and install the latest release for your architecture:

https://github.com/alibuzcuk/fedora-7.2.2-xwq-zen/releases

### Installation from Prebuilt Releases

```bash
# Download the latest kernel RPM (replace VERSION with actual release)
# Then install:
sudo dnf install ./kernel-7.2.2_xwq_zen-*.rpm

# Update bootloader
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Reboot
sudo reboot
```

---

## Configuration Files

### zen-kernel.config
The custom kernel configuration file with all performance optimizations pre-enabled. You can view and modify this file before building if needed.

### build.sh
Automated build script that handles dependency installation, kernel cloning, configuration, compilation, and initial installation setup. Run with `./build.sh` after making it executable with `chmod +x build.sh`.

---

## Troubleshooting

### Build Fails Due to Missing Dependencies
Ensure all build tools are installed:
```bash
sudo dnf groupinstall "Development Tools" -y
```

### Kernel Won't Boot After Installation
Check GRUB configuration was updated:
```bash
cat /boot/grub2/grub.cfg | grep 7.2.2
```

Hold `Shift` during boot to access GRUB menu and select your old kernel if needed.

### Out of Disk Space During Build
The build requires ~5GB free space in `~/rpmbuild/`. Clean old builds with:
```bash
rm -rf ~/rpmbuild/
```

### Uninstall Custom Kernel
To revert to the original Fedora kernel:
```bash
sudo dnf remove kernel-7.2.2_xwq_zen
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo reboot
```

---

## Performance Tuning Tips

### Runtime Tweaks (Optional)
After installation, you can further optimize performance with sysctl settings:

```bash
# Reduce swappiness (prefer RAM)
sudo sysctl -w vm.swappiness=10

# Optimize scheduler
sudo sysctl -w kernel.sched_migration_cost_ns=5000000
```

### Gaming Specific
Enable CPU governor for maximum performance during gaming:
```bash
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

---

## System Requirements

- **CPU:** Intel or AMD processor (tested on Intel i3-5005U, supports modern CPUs)
- **RAM:** Minimum 4GB (optimized for 8GB systems)
- **Storage:** At least 5GB free space for building from source
- **Distro:** Fedora Linux (any recent version)
- **Architecture:** x86_64

---

## License & Attribution

This kernel build incorporates patches and configurations from:
- [Zen Kernel Project](https://github.com/zen-kernel/zen-kernel) - The upstream Zen Kernel source
- [Linux Kernel](https://kernel.org/) - The Linux kernel itself

Custom configurations and build scripts are provided as-is for educational and personal use.

---

## Contributing & Issues

Found a bug or have an optimization idea? Feel free to:
1. Open an issue on GitHub: https://github.com/alibuzcuk/fedora-7.2.2-xwq-zen/issues
2. Submit a pull request with your improvements
3. Share your performance results and configurations

---

## Disclaimer

Building and installing custom kernels carries risks including system instability, data loss, or unbootable systems. **Only proceed if you:**
- Understand the risks and have backups
- Are comfortable with the command line
- Can recover your system if boot fails

The authors provide no warranty or guarantees. Proceed at your own risk.

---

## Quick Links

- **GitHub Repository:** https://github.com/alibuzcuk/fedora-7.2.2-xwq-zen
- **Releases:** https://github.com/alibuzcuk/fedora-7.2.2-xwq-zen/releases
- **Issues & Discussions:** https://github.com/alibuzcuk/fedora-7.2.2-xwq-zen/issues
- **Zen Kernel Project:** https://github.com/zen-kernel/zen-kernel
- **Linux Kernel Docs:** https://kernel.org/doc/

---

**Last Updated:** September 2026  
**Kernel Base:** Linux 7.2.2 with Zen patches
