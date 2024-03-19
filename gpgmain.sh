#!/bin/bash
source welcome.sh
source utils.sh
source init.sh
main (){
    init
    welcome
    while true;
    do 
        displayMenu
        read -p "Input Here : " input
        if [[ $input =~ ^[0-9]+$ ]]; then
        if  [ "$((input))" -eq 0 ];then
            byeF
            exit
        elif [ "$((input))" -eq 1 ];then 
            echo "Displaying gpg keys .."
            sleep 0.8
            displayGpg
        elif [ "$((input))" -eq 2 ];then 
            echo "Generating gpg keys "
            sleep 0.8
            generateGpg  
        elif [ "$((input))" -eq 3 ];then 
            echo "Configuring gpg keys "
            sleep 0.8
            configureGpg  
        elif [ "$((input))" -eq 4 ];then 
            echo "Deleting gpg keys "
            sleep 0.8
            deleteGPG 
            fi
        else
            echo " Enter form 0 to 4 only"
            fi
    done
    
}
main 