# Installation des dependances
Installation VM (VMWARE 17Pro) </br> </br>
Installation Ubuntu, de votre choix : ubuntu 20.04 or 22.04 or  ubuntu 24.04 </br> </br>
Configuration reseaux </br> </br>
```
ip a
```
```
ls /etc/netplan/
```
```
sudo nano /etc/netplan/00-installer-config.yaml
```
```
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      dhcp4: yes
```
```
sudo netplan apply
```
```
sudo netplan try
```
S'il y a des erreurs, regarder les logs
```
journalctl -u systemd-networkd
```
Tester ping 8.8.8.8, si ok avec TLL=...
```
ping 8.8.8.8
```

* Pour ubuntu 20.04 or 22.04
```
apt update
```
```
apt install nasm binutils gcc libc6-dev-i386 gcc-multilib git unzip
```
* For ubuntu 24.04
```
apt update
```
```
sudo dpkg --add-architecture i386
```
```
apt install nasm binutils gcc libc6-dev-i386 gcc-multilib git unzip
```
OU UTILISER UBUNTU PREINSTALLE (ASM qui est avec dgb-peda et metasploit, MYASM Juste pour compilation)


# HELLO WORLD : nasm

```
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/hello.asm
```
```
cat hello.asm
```
```
nasm -f elf hello.asm -o hello.o
```
```
gcc -m32 hello.o -o hello.elf -nostartfiles
```
OU
```
ld -m elf_i386 hello.o -o hello.elf
```
```
chmod +x hello.elf
```
```
./hello.elf
```
* hello world avec saut à la ligne dans l'ethiquette _start
```
rm -rf hello.asm hello.elf *.o
```
```
wget  https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/hello.asm
```
```
mv hello2.asm hello.asm
```
```
cat hello.asm
```
exercice compilation !?
```
nasm -f elf hello.asm -o hello.o
```
```
gcc -m32 hello.o -o hello.elf -nostartfiles
```
OU
```
ld -m elf_i386 hello.o -o hello.elf
```
```
chmod +x hello.elf
```
```
./hello.elf
```

# SAISIR ET AFFICHER EN NASM
```
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/mon_programme.asm
```
```
cat mon_programme.asm
```
```
nasm -f elf32 mon_programme.asm -o mon_programme.o
```
```
gcc -m32  mon_programme.o -o mon_programme.elf -nostartfiles
```
OU
```
ld -m elf_i386 mon_programme.o -o mon_programme.elf
```
```
chmod +x mon_programme.elf
```
```
./mon_programme.elf
```

# COMPILATION DE SKEL AVEC CODE C 
* Code C
```
mkdir skel_c
```
```
cd skel_c
```
```
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/cdecl.h
```
```
cat cdecl.h
```
```
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/driver.c
```
```
cat driver.c
```
```
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/skel.asm
```
```
cat skel.asm
```

* BIBLIOTHEQUE POUR LA COMPILATION SEPAREE asm_io.inc (pour l'inclusion) asm_io.asm (pour le code)
```
wget  https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/asm_io.inc
```
```
wget  https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/asm_io.asm
```
```
ls
```
Compilation skel avec code C
```
nasm -f elf32 -d ELF_TYPE -o asm_io.o asm_io.asm
```
```
nasm -f elf32 -d ELF_TYPE -o skel.o skel.asm
```
```
gcc -m32 -o skel.elf driver.c skel.o asm_io.o
```
```
chmod +x skel.elf
```
```
./skel.elf
```
```
cd ..
```
EXERCICE : REFAIRE L'EXERCICE EN AFFICHANT : HELLO WORLD DANS LE CODE

# COMPIlATION SKEL EN NASM
```
mkdir skel
```
```
cd skel
```
```
wget  https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/skel2.asm
```
```
mv skel2.asm skel.asm
```
```
cat skel.asm
```
NEED asm_io.inc and asm_io.asm
```
wget  https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/asm_io.inc
```
```
cat asm_io.inc
```
```
wget  https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/asm_io.asm
```
```
cat asm_io.asm
```
```
ls
```
```
nasm -f elf32 -d ELF_TYPE -o asm_io.o asm_io.asm
```
```
nasm -f elf32 -d ELF_TYPE -o skel.o skel.asm
```
```
gcc -m32 -o skel.elf skel.o asm_io.o -nostartfiles
```
OU
```
ld -m elf_i386 -o skel.elf skel.o asm_io.o -lc -dynamic-linker /lib/ld-linux.so.2
```
```
./skel.elf
```
```
cd ..
```


# COMPILATION DE FIRST EN NASM AVEC CODE EN C 
```
mkdir first_c
```
```
cd first_c
```
```
wget  https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/first.asm
```
```
cat first.asm
```
```
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/asm_io.asm
```
```
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/asm_io.inc
```
```
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/cdecl.h
```
```
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/driver.c
```
```
ls
```
```
nasm -f elf32 -d ELF_TYPE -o asm_io.o asm_io.asm
```
```
nasm -f elf32 -d ELF_TYPE -o first.o first.asm
```
```
gcc -m32 -o first.elf driver.c first.o asm_io.o
```
```
chmod +x first.elf
```

```
./first.elf
```
```
cd ..
```

# COMPILATION DE FIRST EN NASM
```
mkdir first
```
```
cd first
```
```
wget  https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/first2.asm
```
```
mv first2.asm first.asm
```
```
cat first.asm
```
```
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/asm_io.asm
```
```
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/asm_io.inc
```
```
nasm -f elf32 -d ELF_TYPE -o asm_io.o asm_io.asm
```
```
nasm -f elf32 -d ELF_TYPE -o first.o first.asm
```
```
gcc -m32 -o first.elf first.o asm_io.o -nostartfiles
```
OU
```
ld -m elf_i386 -o first.elf first.o asm_io.o -lc -dynamic-linker /lib/ld-linux.so.2
```
```
chmod +x first.elf
```
```
./first.elf
```
```
cd ..
```
