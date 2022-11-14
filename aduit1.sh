#!/bin/bash


ss="Senpais"
s="Senpai"
function sep(){
    echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
}
function users(){
    ls /home 
}
#senpai audit
function auditsenpai(){
      echo "Here are the list of cuties on the server"
      users
      echo '1.) Add senpais        2.) Delete senpais :(        3.) Change passwords'
      echo '4.) Audit senpai groups'
      read -p "Select number" as 
      case $as in
        1)
            adding(){
                sep
                users
                sep
                read -p 'Who is the new cutie for the server uwu: ' newu
                adduser $newu
                #loop
                read -p 'done? y, n, exit: ' yn
                if [[ $yn == "n" ]]; then
                adding
                elif [[ $yn == "y" ]]; then
                auditsenpai
                elif [[ $yn == "exit" ]]; then
                menu
                fi
                #end loop
            }
            adding
        ;;
        2)
            deleteing(){
            sep
            users
            sep
            read -p "WHO IS THE UNAUTHORIZED BAKA!!!! : " BAKA 
            echo "WARNING THIS WILL REMOVE ALL FILES FROM $BAKA"
            read -p 'ARE YOU SURE: (y,n) ' yn
            if [[ $yn == "y" ]]; then 
            deluser --remove-all-files $BAKA
            sep
            echo "silly sussy baka $BAKA has been removed!!"
            echo ""
            elif [[ $yn == "n" ]]; then
            menu
            else
            echo "You typed $yn"
            echo "Invalid option"
            echo "Choices have not been saved"
            sep
            menu 
            fi
            #loop
                read -p "done? y, n, exit: " yn
                if [[ $yn == "n" ]]; then
                deleteing
                elif [[ $yn == "y" ]]; then
                auditsenpai
                elif [[ $yn == "exit" ]]; then
                menu
                fi
                #end loop
            }
        deleting
        ;;
        3)
            sep
            user
            sep
            read -p "Which bakas password do you want to change: " chpd
            passwd $chpd
            menu
        ;;
        4)
            sep
            cat /etc/group
            sep
            read -p "Make group or add Senpai to existing group: (mg , eg) " egmg
            case $egmg in
            eg)
                user
                read -p "Which Senpais group status are you going to want to change" chuser
                getent group
                read -p "What group are you going to want add $chuser to? " groupname
                useradd $chuser -G $groupname
                echo "Is this information correct? "
                cat /etc/group | grep $groupname 
            ;;
            esac
            
            ##read -p "What group do you want to make" groupname
            ##read -p "What user "
            #make group
                #add anyone in?
                #who
            #open /etc/group
            #add user to a group
        ;;
        esac
        
 }

function menu(){
    echo '1.) Senpai audit       2.)not set '
    read input
case $input in
    1) 
    echo "Here is the list of cuties on the server"
    sep
    ls /home
    sep
    read -p "Do you want to change anything uwu: (y,n,) " Audit
    sep
    if [[ $Audit == "y" ]]; then
    auditsenpai
    elif [[ $Audit == "n"]]; then
    menu
    else
    echo 'Please choose a valid option: (y,n)'
    fi
    ;;
    2)
    ;;
    esac
}
while true; do menu; done