#!/bin/bash
set -e

#Color to the people
RED='\x1B[0;31m'
CYAN='\x1B[0;36m'
GREEN='\x1B[0;32m'
NC='\x1B[0m'

echo -e
echo -e "${GREEN}This script will generate your new keys. Please make sure your repos are at least at version ${CYAN}1.0.94${GREEN}...${NC}"
echo -e
echo -e "${RED}Use this script only once on each of your machines !!!${NC}"
echo -e

read -p "What's your keys folder name? (default VALIDATOR_KEYS) : " FOLDERNAME
if [ "$FOLDERNAME" = "" ]
  then
      FOLDERNAME="VALIDATOR_KEYS"
  fi

echo -e "${GREEN}You have selected the ${CYAN}$FOLDERNAME${GREEN} folder.${NC}"

if [ -d "$HOME/$FOLDERNAME" ]; then
          echo -e "${GREEN}Folder ${CYAN}${FOLDERNAME}${GREEN} found ...${NC}"
	        OLD_COPY=$FOLDERNAME"_old"
	        echo -e
	        echo -e "${GREEN}A backup of your old keys will be moved to ${CYAN}$OLD_COPY${NC}"
	
  if [ -d "$HOME/$OLD_COPY" ]; then
		      echo -e "${RED}Error: $OLD_COPY${RED} found. You had executed this two times. Can't continue !${NC}"
	       else
		       echo -e "${GREEN}Proceding with the key generation...${NC}"
		       echo -e
		       read -p "How many keys do you want to generate ? : " NUMBEROFNODES
		       re='^[0-9]+$'
		       if ! [[ $NUMBEROFNODES =~ $re ]] && [ "$NUMBEROFNODES" -gt 0 ]
		             then
		               NUMBEROFNODES = 1
		  fi

	cd $HOME
	mv $FOLDERNAME $OLD_COPY 
	mkdir $FOLDERNAME
	cd $HOME/elrond-utils

	for i in $(seq 1 $NUMBEROFNODES); 
		do 
			INDEX=$(( $i - 1 ))
			./keygenerator
			cp *.pem $HOME/elrond-nodes/node-$INDEX/config
			echo "${GREEN}Zipping new keys for ${CYAN}node-$INDEX${GREEN}...${NC}"
			zip node-$INDEX.zip *.pem
			mv node-$INDEX.zip $HOME/$FOLDERNAME/
			rm *.pem
			echo -e "${GREEN}All done for ${CYAN}node-$INDEX${GREEN} !${NC}"
		done
	fi
else
  echo -e "${RED}Error: ${CYAN}${FOLDERNAME}${RED} not found. Can't continue !${NC}"
  exit 1
fi



