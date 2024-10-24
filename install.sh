    #!/bin/bash
    declare -a pacs=("wine" "vim" "nano" "fastfetch" "git")

    if [ "$(whoami)" == "root" ]; then
        clear
        echo "THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION."
        echo "please don't run this file as sudo, this is a bad idea and untested, if you know what your doing, remove exit line."
        sleep 5
        exit 1
    fi


    countdown() {
    local seconds=$1
    for ((i = seconds; i > 0; i--)); do
        dots=""
        for ((j = 0; j < (seconds - i + 1); j++)); do
            dots+="."
        done
        echo -ne "Rebooting in $i$dots\r"
        sleep 1
    done

}


    spin() {
        local pid=$1
        local delay=0.1
        local spinchars="/-\\|"

        while kill -0 $pid 2>/dev/null; do
            for i in $(seq 0 3); do
                echo -ne "\r[${spinchars:i:1}] Installing..."
                sleep $delay
            done
        done
        echo -ne "\rDone!            \n"  
    }

    install_package() {
        local package_name=$1
        echo "Preparing to install $package_name..."

        sudo -v 


        echo "Installing $package_name..."
        sudo pacman -S --noconfirm "$package_name" > /dev/null 2>&1 &
        pid=$!  

        spin $pid 

        echo "$package_name has been installed."
        sleep 1  
        clear
    }

    install_all() {
        clear
        echo "Starting installation..."
        sleep 1

        install_package "wine"
        install_package "vim"
        install_package "git"
        install_package "fastfetch"
        clear
        echo "Finished installing all packages."
        sleep 5

    }

    kdepacs=(
        "xorg"
        "plasma-workspace"
        "plasma-wayland-session"
        "plasma"
        "kde-applications"
        "sddm"
    )

    install_kdeplasma() {
        clear
        sleep 1
        echo "Setting up..."
        sleep 1
        echo "Updating system.."
        sudo pacman -Syu --noconfirm
        sleep 1
        echo "NOTE!!! : you have to enable 'systemctl enable sddm.service
        systemctl enable NetworkManager.service' by yourself, this just installs it (i did add it so it should work but dont rely on this.)"
        sleep 3
     
        echo "Installing packages..."
        sudo pacman -S --noconfirm "${kdepacs[@]}"

        echo "Installation complete. (dont reboot just yet.)"
        sleep 1
        echo "Enabling systemctl services"
        sudo systemctl enable sddm.service
        sudo systemctl enable NetworkManager.service
        clear
        sleep 1
        countdown 5
        sudo reboot

    }

    install_manually() {
        clear
        for i in "${pacs[@]}"
        do
            clear
            echo "Do you wanna install $i? [y/n]"
            read -p "" choice
            choice="${choice,,}"
            if [[ "${choice}" == "y" ]]; then
                clear
                sleep 1
                install_package "$i"
            else
                echo "Skipping installation of $i..."
                sleep 1
                clear
            fi
        
        done
        echo "the process has finished, this will close automatically."
        sleep 2
        exit 0
    }

    while true; do
        clear
        echo "THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION."
        echo "by using this, you agree to the license."
        sleep 3
        clear
        echo "(1) Install all automatically"
        echo "(2) Install manually"
        echo "(3) Install KDE Plasma"
        read -p "Choose an option: " choice

        case $choice in
            1)
                install_all
                ;;
            2)
                install_manually  
                ;;
            3)
                install_kdeplasma
                ;;
            *)
                echo "Invalid choice"
                exit 0
                sleep 2
                ;;
        esac
    done
