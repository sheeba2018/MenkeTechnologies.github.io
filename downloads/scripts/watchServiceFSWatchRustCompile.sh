#!/usr/bin/env bash
#created by JAKOBMENKE --> Sat Jan 14 18:12:20 EST 2017 

#example usage = bash "$SCRIPTS/watchServiceFSWatchRustCompile.sh" . "untitled.rs"
DIR_WATCHING="$1"
while read -d "" event; do
	
	fileName=`basename $event`
	watchingFile=`basename $2`

	#ignored the intermediate files that are changing
	if [[ $fileName == $watchingFile ]]; then
		#grab error output
		output="$(rustc $2 2>&1)"

		if [[ $? = 0 ]]; then
			#if successful compilation get compiled file name
			compiled=${fileName%*.rs}
			#clear screen to maintain 
		    clear
		    #execute compiled file and then delete it
		    ./$compiled && rm $compiled
		else
			#we have and error in compilation so show the error
		    clear
		    echo "$output"
		fi
			
		# echo "match @ $fileName"
	else
		:
		# echo "no match @ $fileName"
	fi

	

done < <(fswatch -r -0 -E "$DIR_WATCHING" -e "/\.." )
