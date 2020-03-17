#!/bin/bash
set -e

echo -e
echo 'This script is to generate your new keys, be sure you have your repos at least on version 1.0.94.'
echo -e
echo 'Use this script only once time in the same machine'

read -p "What's your keys folder name? (default VALIDATOR_KEYS) : " FOLDERNAME
if [ "$FOLDERNAME" = "" ]
  then
      FOLDERNAME="VALIDATOR_KEYS"
  fi

echo 'you have choose '$FOLDERNAME

if [ -d "$HOME/$FOLDERNAME" ]; then
  echo "Folder ${FOLDERNAME} found ..."
	OLD_COPY=$FOLDERNAME"_old"
	echo -e
	echo "A backup of your old keys will be moved to $OLD_COPY"
	if [ -d "$HOME/$OLD_COPY" ]; then
		echo "Error: $OLD_COPY found. You had executed this two times. Can not continue."
	else
		echo "Proceding with the key generation..."
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
				zip node-$INDEX.zip *.pem
				mv node-$INDEX.zip $HOME/$FOLDERNAME/
				rm *.pem 
			done

	fi
else
  echo "Error: ${FOLDERNAME} not found. Can not continue."
  exit 1
fi



