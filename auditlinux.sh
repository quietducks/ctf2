#!/bin/bash


ss="Users"
s="User"
function users(){
    ls /home 
}

function sep(){
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}
function user(){
    ls /home
}
function findf(){
    sep 
    read -p 'What directory do you want to look in? [ex: /path/to/file | / is the default] PRESS ENTER TO SKIP: ' yn
        if [[ $yn == "" ]]; then
         read -p "What file do you want to find: " ext
         find / -iname "*$ext*" 2>/dev/null
        else
        read -p "What file do you want to find: " ext
        find $yn -iname "*$ext*" 2>/dev/null
        fi
}
function auditUser(){
      sep
      echo '1.) Add Users          2.) Delete Users :(        3.) Change passwords'
      echo '4.) Audit User groups  (exit)' 
      read -p "Select number: " as 
      sep
      case $as in
        1)
            adding(){
                sep
                user
                sep
                read -p "Who is the new cutie for the server ;): " newu
                adduser $newu
                echo "Cutie User $newu has been added ;)"
                #loop
                sep
                read -p 'done? (y, n, exit): ' yn
                if [[ $yn == "n" ]] ; then
                adding
                elif [[ $yn == "y" ]] ; then
                auditUser
                elif [[ $yn == exit ]] ; then
                menu
                fi
                #end loop
            }
        adding
        ;;
        2)
            function deleteing(){
                sep
                user
                sep
                read -p "WHO IS THE UNAUTHORIZED STINKY USER!!!! : " BAKA 
                echo "WARNING THIS WILL REMOVE ALL FILES FROM $BAKA"
                read -p 'ARE YOU SURE: (y,n) ' yn
                if [[ $yn == "y" ]]; then 
                deluser --remove-all-files $BAKA
                sep
                echo "silly sussy stinker $BAKA has been removed!!"
                echo ""
                elif [[ $yn == "n" ]]; then
                menu
                else
                echo "You typed $yn"
                echo "Invalid option"
                echo "Changes have not been saved"
                sep
                menu 
                fi
                #loop
                sep
                read -p "done? y, n, exit: " yn
                if [[ $yn == "n" ]]; then
                deleteing
                elif [[ $yn == "y" ]]; then
                auditUser
                elif [[ $yn == "exit" ]]; then
                menu
                fi
                #end loop
            }
         deleteing
        ;;
        3)
            chpswd(){
                sep
                user
                sep
                PASS='Cyb3rPatr!0t$$u94r'
	            for x in `cat users`
	            do
		        echo -e "$PASS\n$PASS" | passwd $x
		        echo -e "Password for User $x has been changed to $PASS."
		        done
            }
        chpswd
        ;;
        4)
            sep
            getent group 
            sep
            read -p 'Make/delete group, add/remove User to existing group, or Admin/Sudo audit: (mg , rg, asg, rsg, as) [exit] : ' egmg
            case $egmg in
            asg)
                user
                read -p 'Which Users group status are you going to want to change: ' chuser
                read -p "What group are you going to want add $chuser to? " groupname
                usermod $chuser -aG $groupname
                 
                function check(){
                    cat /etc/group | grep $groupname
                    read -p 'Is this information correct? (y,n): ' corkt

                    if [[ $corkt == "y" ]]; then 
                    auditUser
                    elif [[ $corkt == "n" ]]; then
                    usermod $chuser -rG $groupname
                    echo "Changes have not been saved"
                    auditUser
                    else 
                    echo "please enter a valid option"
                    check
                    fi
                }
                check
            ;;
            mg)
                set -e
                sep
                cat /etc/group
                sep
                read -p "Type the name of the group you want to make: " groupname
                read -p "Do you want to add a User to $groupname? (y,n) " yn
                if [[ $yn == "y" ]]; then
                    sep
                    user
                    sep
                    read -p "Which User do you want to add to $groupname? " adduser 
                    groupadd $groupname
                    usermod $adduser -aG $groupname
                    echo "$adduser has been added to $groupname"
                    getent group $groupname
                    sep
                elif [[ $yn == "n" ]]; then
                    sep
                    auditUser
                fi
            ;;
            as)
                sep
                getent group adm
                sep
                getent group sudo
                sep
                read -p 'Do you want to change admin list? (y,n, exit): ' aa 
                case $aa in
                    y)
                    sep
                    read -p 'Do you want to add or remove a senapi from admin? (a,r): ' ar
                        case $ar in
                            a)
                                listofsenps=()

                                addsenp(){
                                    read -p "Type the User you want to add to the Admin list: " addadmin
                                }
                                addtolist(){
                                    listofsenps+=("$addadmin")
                                    echo ""
                                    read -p 'Do you want to add another User to the Admin list? (y,n): ' yn
                                    if [[ $yn == "y" ]]; then
                                        addsenp
                                        addtolist
                                    elif [[ $yn == "n" ]]; then
                                    echo "done"
                                    for senp in "${listofsenps[@]}";do usermod $senp -aG adm && usermod $senp -aG sudo && getent group adm && getent group sudo ; done
                                    menu
                                    fi
                                }
                                addsenp
                                addtolist                             
                            ;;
                            r)
                                listofsenps=()

                                removesenp(){
                                    read -p "Type the User you want to remove from the Admin list: " rmadmin
                                }
                                addtolist(){
                                    listofsenps+=("$rmadmin")
                                    echo ""
                                    read -p 'Do you want to remove another User from the Admin list? (y,n): ' yn
                                    if [[ $yn == "y" ]]; then
                                        removesenp
                                        addtolist
                                    elif [[ $yn == "n" ]]; then
                                    echo "done"
                                    for senp in "${listofsenps[@]}";do deluser $senp adm && deluser $senp sudo && getent group adm && getent group sudo ; done
                                    menu
                                    fi
                                }
                                removesenp
                                addtolist
                            ;;
                            esac 
                    ;;
                    n)
                    menu
                    ;;
                    esac
            ;;
            rg)
                sep
                getent group
                sep
                read -p "What group do you want to delete: " delg
                groupdel $delg
                sep
                echo "Group $delg has been deleted"
                menu
            ;;
            rsg)
                sep
                getent group
                sep
                read -p "Which Users group status do you want to edit? " chuser
                read -p "What group do you want to remove User $chuser from: " group
                echo ""
                usermod $chuser -rG $group
                echo "Silly baka $chuser has been successfully removed from $group"
                menu
            ;;
            "exit")
                sep
                menu
            ;;
            esac
            #to add a new option type betweent the ;; and esac
            #end on options
        ;;
        esac
}
function menu(){
    echo '1.) audit users'
    echo '2.) Find files'
    echo ''
    sep
    read -p 'Please pick an option: [Type the number to the corralated option]: ' input
    case $input in 
    1) 
    sep
    echo "Here are the list of cuties on the server ;)"
    echo ""
    user
    sep
    read -p 'Do you want to make any edits to these cutie patooties? (y,n): ' yn
    if [[ $yn == "y" ]]; then
    auditUser
    elif [[ $yn == "n" ]]; then
    menu
    fi
    ;;
    2)
    findf
    ;;
    esac
}
while true; do menu; done