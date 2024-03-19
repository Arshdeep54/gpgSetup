#!/bin/bash

init(){
    output=$( command -v xclip )
    if ! [[ $output == */* ]];then
        echo "xclip not installed please install it on"
        exit 
    fi
}
