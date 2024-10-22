#!/usr/bin/env bash

# ========================================================
#                  Dualboot Installation ShellScript
#                           Franklin Souza
#                              @frannksz
# ========================================================

keyboard(){
  clear
  loadkeys br-abnt2
}

# Formatação de discos
format_disk(){
  clear
  echo -e "[!] - Formatando os discos\n"
  sleep 2
  mkfs.vfat -F32 /dev/sda4
  mkswap /dev/sda6
  swapon /dev/sda6
  mkfs.btrfs -f /dev/sda7
}

# Criação de subvolumes
subvolumes(){
  clear
  echo -e "[!] - Criando subvolumes em btrfs\n"
  sleep 2
  mount /dev/sda7 /mnt
  btrfs su cr /mnt/@
  btrfs su cr /mnt/@home
  btrfs su cr /mnt/@snapshots
  umount /mnt
}

# Montando as partições
mount_partitions(){
  clear
  echo -e "[!] - Montando as partições\n"
  sleep 2
  mount -o defaults,noatime,compress-force=zstd:3,autodefrag,subvol=@ /dev/sda7 /mnt
  mkdir -p /mnt/boot/efi
  mkdir /mnt/home
  mkdir /mnt/.snapshots
  mount -o defaults,noatime,compress-force=zstd:3,autodefrag,subvol=@home /dev/sda7 /mnt/home
  mount -o defaults,noatime,compress-force=zstd:3,autodefrag,subvol=@snapshots /dev/sda7 /mnt/.snapshots
  mount /dev/sda4 /mnt/boot/efi
}

# Instalando pacotes base do Arch Linux
pacstrap_arch(){
  clear
  echo -e "[!] - Instalando os pacotes base do Arch Linux\n"
  sleep 2
  pacstrap /mnt base dhcpcd neovim linux-firmware base-devel
  pacman -Sy archlinux-keyring --noconfirm
  pacstrap /mnt base dhcpcd neovim linux-firmware base-devel wget
}

# Gerando o fstab
fstab_gen(){
  clear
  echo -e "[!] - Gerando o Fstab\n"
  sleep 2
  genfstab /mnt >> /mnt/etc/fstab
  #printf "\n/dev/sda6 none swap defaults 0 0" >> /mnt/etc/fstab

}

# Entrando no chroot
arch_chroot_enter(){
  clear && echo -e "[!] - ENTRE NO CHROOT DIGITANDO: arch-chroot /mnt"
  sleep 2
}

keyboard
format_disk
subvolumes
mount_partitions
pacstrap_arch
fstab_gen
arch_chroot_enter
