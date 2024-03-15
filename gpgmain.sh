#!/bin/bash
source welcome.sh
source utils.sh
main (){
    welcome
    while true;
    do 
        displayMenu
        read -p "Input Here : " input
        if  [ "$input" -eq 0 ];then
            byeF
            exit
        elif [ "$input" -eq 1 ];then 
            echo "Displaying gpg keys .."
            sleep 1.5
            displayGpg
        elif [ "$input" -eq 2 ];then 
            echo "Generating gpg keys "
            sleep 1.5
            generateGpg  
        elif [ "$input" -eq 3 ];then 
            echo "Configuring gpg keys "
            sleep 1.5
            configureGpg  
        elif [ "$input" -eq 4 ];then 
            echo "Deleting gpg keys "
            sleep 1.5
            deleteGPG 
        fi
    done
    
}
main 