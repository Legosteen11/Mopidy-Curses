#!/bin/bash

HEIGHT=15
WIDTH=60
CHOICE_HEIGHT=5
TITLE="Music Player"
MENU="Select Action"
OPTIONS=(0 "Track"
	 1 "Play"
	 2 "Pause"
	 3 "Search"
	 4 "Previous"
	 5 "Next"
 	 4 "Clear")
TIMEOUT=2
URL=${1-localhost}

echo $url

while :
do
	CHOICE=$(dialog --clear \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
	clear

	case $CHOICE in
		0)
			pplaying=$(./../curl/track.sh $URL | jq '.result.track')
			palbum=$(echo $pplaying | jq -r '.album.name')
			pdate=$(echo $pplaying | jq -r '.album.date')
			ptrack=$(echo $pplaying | jq -r '.name')
			partist=$(echo $pplaying | jq -r '.artists[0].name')


			dialog --clear --title "$TITLE" --msgbox "$ptrack\n$palbum\n$partist\n$pdate" $HEIGHT $WIDTH
			;;
		1)
			./../curl/play.sh $URL
			dialog --clear --title "$TITLE" --pause "Playing" $HEIGHT $WIDTH $TIMEOUT
			;;
		2)
			./../curl/pause.sh $URL
			dialog --clear --title "$TITLE" --pause "Paused" $HEIGHT $WIDTH $TIMEOUT
			;;
		3)
			if ! SEARCH=$(dialog --clear \
				--title "$TITLE" \
				--inputbox "Search albums" \
				$HEIGHT $WIDTH \
				2>&1 >/dev/tty)
			then
				continue
			fi
			searchresult=$(./../curl/search-album.sh $URL "$SEARCH" | jq '.result[0].albums[0:5]')
			searchoptions=(0 "$(echo $searchresult | jq -r '.[0].artists[0].name') - $(echo $searchresult | jq -r '.[0].name')"
				 1 "$(echo $searchresult | jq -r '.[1].artists[0].name') - $(echo $searchresult | jq -r '.[1].name')"
				 2 "$(echo $searchresult | jq -r '.[2].artists[0].name') - $(echo $searchresult | jq -r '.[2].name')"
			 	 3 "$(echo $searchresult | jq -r '.[3].artists[0].name') - $(echo $searchresult | jq -r '.[3].name')"
			 	 4 "$(echo $searchresult | jq -r '.[4].artists[0].name') - $(echo $searchresult | jq -r '.[4].name')")

			if ! searchchoice=$(dialog --clear \
					--title "$TITLE" \
					--menu "Choose album:" \
					$HEIGHT $WIDTH $CHOICE_HEIGHT \
					"${searchoptions[@]}" \
					2>&1 >/dev/tty)
			then
				continue
			fi
			searchuri=$(echo $searchresult | jq -r ".[$searchchoice].uri")

			./../curl/clear-queue.sh $URL
			./../curl/play-uri.sh $URL $searchuri
			./../curl/play.sh $URL

			dialog --clear --title "$TITLE" --pause "Playing $(echo $searchresult | jq -r ".[$searchchoice].name")" $HEIGHT $WIDTH $TIMEOUT

			;;
		4)
			./../curl/previous.sh $URL
			;;
		5)
			./../curl/next.sh $URL
			;;
		6)
			./../curl/clear-queue.sh $URL
			dialog --clear --title "$TITLE" --pause "Cleared" $HEIGHT $WIDTH $TIMEOUT
			;;
	esac
done
