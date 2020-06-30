#!/bin/bash
set -e

#Get the script current running location
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

source $SCRIPTPATH/config/variables.cfg

#Handle some paths
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

#See current running version
CURRENT=$($CUSTOM_HOME/elrond-nodes/node-0/node --version | awk -F '[ \/-]' '{print $6}')

#See current available version
LATEST=$(curl --silent "https://api.github.com/repos/ElrondNetwork/elrond-go/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

echo " " >> $CUSTOM_HOME/autoupdate.status
echo `date` >> $CUSTOM_HOME/autoupdate.status

if [ -z "$CURRENT" ]; then
                        echo "Could not get latest current version !!! Node(s) not running ! Aborting..." >> $CUSTOM_HOME/autoupdate.status
                        echo " " >> $CUSTOM_HOME/autoupdate.status
    
                      else
                         
                        if [ -z "$LATEST" ]; then
                                              echo "Couldn't get the latest tag from Github !!! Aborting..." >> $CUSTOM_HOME/autoupdate.status
                                              echo " " >> $CUSTOM_HOME/autoupdate.status
                                            
                                            else 

                                              echo "Your current version is:  $CURRENT" >> $CUSTOM_HOME/autoupdate.status
                                              if [[ $CURRENT != *$LATEST* ]]; then
                                                                                echo "Latest tag from github: $LATEST" >> $CUSTOM_HOME/autoupdate.status
                                                                                echo "Triggering automated upgrade !" >> $CUSTOM_HOME/autoupdate.status
                                                                                cd $SCRIPTPATH && bash script.sh auto_upgrade
                              
                                                                              else
                                                                                echo "Latest tag from github: $LATEST" >> $CUSTOM_HOME/autoupdate.status
                                                                                echo "Nothing to do here... you are on the latest tag !" >> $CUSTOM_HOME/autoupdate.status
                                                                              fi
              
                                          fi

  fi
