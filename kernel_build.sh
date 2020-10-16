#!/bin/bash
# Start of build_kernel script 

#These are the variables used to store relevant directory and kernel image
#DIR stores the directory where this script will try to clone both the repository
#This is also the directory where linux directory will be made having all relevant file after kernel is successfully build
#Change this directory to any suitable directory, could be in user directory or roots's as sudo is used for installation
DIR=/home/kaushal-pi/Documents
#This is variable used to store the name of the kernel that i have currently to make a backup on later stages
#Change this to the version you have
BACKUP=kernel7.img
#
#Changing the directory to the specified one to clone the repository or exit if directory not found, handling the exceptions and passing shellcheck
cd $DIR || exit
#Checking out my private repository using ssh so that password is not required
#I have already set my private key as expected
#Cloning my usap-assignment-2 repo to specified directory, this is used to access the scripts and .config file
git clone git@github.com:kaushal-gawri/usap-assignment-2
#
#Cloning the raspberry pi kernel repository
git clone --depth=1 https://github.com/raspberrypi/linux
#Installing required packages if already not present
sudo apt install raspberrypi-kernel-headers build-essential bc git wget bison flex libssl-dev make
#Changing the directory to linux directory which was just installed after cloning the repo or exit if directory not found, handling the exceptions and passing shellcheck
cd $DIR/linux || exit
#
#Using verify to ignore the KERNEL unused warning in shellcheck
#Generating a kernel for raspberry pi 4
verify KERNEL=kernel7l
#
make bcm2711_defconfig
#
sudo apt-get install qt5-\*-dev
#Using menu config to show menu configuration
#Just save and exit as we would be using my custom made .config file
make menuconfig
#
#Copying .config file to respective directory from the checked out repo
#This is used to unconfigure cameras and video devices
#Confirmed using vcngencmd get_camera
sudo cp $DIR/usap-assignment-2/.config $DIR/linux
#
#Changing back to my repo folder to execute relevant script
cd $DIR/usap-assignment-2 || exit
#Executing the first monitoring script
./first-script.sh &
pid=$!
#Executing the second monitoring script
./second-monitor.sh &
pid1=$!
#
#Changing the directory back to linux directory which was just installed after cloning the repo or exit if not found
cd $DIR/linux || exit
#
#Compiling the kernel and in the background the other two scripts are running
#You can see the flickering of lights based on CPU Usage, the data is being written to kernel_performance_data
make -j4 zImage modules dtbs
#
#Sending USR1 signal to the  given pid so that first monitoring script is terminated gracefully
kill -s USR1 $pid
#Sending USR2 signal to the given pid so that second monitoring script is terminated gracefully
kill -s USR2 $pid1
#
sudo make modules_install
#
#Changing linux version to my student number
#Local version already changes in .config
sed -i 's/"Linux"/"s3777121"/g' uts.h
#copying my current kernel image to tmp directory for backing up
sudo cp /boot/$BACKUP /tmp/
#Creating a backup of current kernel in a mounted directory
sudo mkdir /mnt/new-boot
sudo mkdir /mnt/new-boot-files
sudo mount /dev/mcblk0p1 /mnt/new-boot
sudo mount /dev/mcblk0p2 /mnt/new-boot-files
#
#copying my current kernel image to the mounted directory to keep a backup
sudo cp /mnt/new-boot/$BACKUP -/
#Copying the files in the respective locations to completed kernel building process
#The custom kernel is known as myKernel.img
sudo cp arch/arm/boot/dts/*.dtb /boot/
#
sudo cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
#
sudo cp arch/arm/boot/dts/overlays/README /boot/overlays/
#
sudo cp arch/arm/boot/zImage /boot/myKernel.img
#Rebooting the pi so that new kernel is started
sudo reboot


