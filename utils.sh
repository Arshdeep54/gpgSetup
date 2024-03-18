#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
WHITE='\033[1;37m'
YELLOW='\033[0;33m'
DEFAULT='\033[0m'
BLUE='\033[0;34m'

IFS=$'\n' 

default(){
    line=$(gpg --list-secret-keys --keyid-format=long | awk /sec/ | cut -b 15-30)
    gpg_count=$(gpg --list-secret-keys --keyid-format=long | awk /sec/ | cut -b 15-30 | wc -l)
    usernames=$(gpg --list-secret-keys --keyid-format=long | awk '/uid/ { print $3 }')
    emails=$(gpg --list-secret-keys --keyid-format=long | awk '/uid/ { print $4 }')
    read -r -d '' -a usernames_array <<< "$usernames"
    read -r -d '' -a emails_array <<< "$emails"
    read -r -d '' -a keys_array <<< "$line"

}

displayMenu(){

    echo -e "${BLUE} ============================================"
    echo "Enter 1 to view your gpg keys ."
    echo "Enter 2 to generate a new gpg key "
    echo "Enter 3 to configure your gpg key to git "
    echo "Enter 4 to delete your gpg key "
    echo "Enter 0 to exit "
    echo -e " ============================================${DEFAULT}"

}

showkeyIndices(){
    echo -e "${YELLOW}You have $gpg_count gpg keys "
    for ((i = 0; i < gpg_count; i++)); do
        printf "%-2s %-10s %-30s %s\n"  "$((i+1))" "${usernames_array[i]}" "${emails_array[i]}" "${keys_array[i]}"   
    done
    echo -e "${DEFAULT}"
}

displayGpg(){
    default
    echo " "
    showkeyIndices
    read -p "Enter the index of the GPG key you want to view starting from 1: " gpgIndex
    index=$((gpgIndex-1))
    if [[ $gpg_count -gt $index ]]&& [[ $index -ge 0 ]];then
        gpg_to_view="${keys_array[index]}"
        echo "GPG key to view: $gpg_to_view"
        gpg --armor --export $gpg_to_view
        gpg --armor --export $gpg_to_view | xclip -selection clipboard

    else 
        echo -e "${RED}Please enter from 1 to $gpg_count${DEFAULT}"
        
    fi    
}

generateGpg(){
    echo " "
    gpg --full-generate-key  
    default
    gpg_to_view="${keys_array[-1]}"
    gpg --armor --export $gpg_to_view

    echo "Do you want to confgure this key to local git ? y/N"
    read nextInput
    if [ "$nextInput" == 'y' ];then 
        configureGpg
    fi
}

configureGpg(){
    default
    echo " "
    showkeyIndices
    read -p "Enter the index of the GPG key you want to configure starting from 1 : " gpgIndexToConfigure
    index=$((gpgIndexToConfigure-1))
    gpg_to_configure="${keys_array[index]}"
    if [[ $gpg_count -gt $index ]] && [[ $index -ge 0 ]] ;then
        echo "$gpg_to_configure"
        git config --global --unset gpg.format
        git config --global --replace-all user.signingkey  $gpg_to_configure
        if ! [[ $? -ne 0 ]]; then
            echo -e "${GREEN}Gpg configured with id $gpg_to_configure ${DEFAULT}" 
            read -p "Umm , do you want to auto sign git commits by default? y/N " auto_sign
        fi
        if [ "$auto_sign" == "y" ];then
            git config --global commit.gpgsign true
            echo -e "${GREEN}All your commits will now be auto signed with id $gpg_to_configure${DEFAULT}" 
        else
            git config --global commit.gpgsign false
            echo -e "${GREEN} You have to manualy sign commit wiht -S flag${DEFAULT}" 
        fi
    else 
        echo -e "${RED}Please enter from 1 to $gpg_count${DEFAULT}"
    fi
}

deleteGPG(){
    default
    showkeyIndices
    read -p "Enter the index of the GPG key you want to delete starting from 1 : " gpgIndexToDelete
    index=$((gpgIndexToDelete-1))
    if [[ $gpg_count -gt $index ]] && [[ $index -ge 0 ]];then
        gpg_to_delete="${keys_array[index]}"
        gpg --delete-secret-keys $gpg_to_delete
        echo -e "${GREEN}Gpg deleted with id $(echo -n "$gpg_to_delete" | tr -d '\n') ${DEFAULT}"
    else 
        echo -e "${RED}Please enter from 1 to $gpg_count${DEFAULT}"
    fi
}