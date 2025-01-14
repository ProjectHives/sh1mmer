source /usr/sbin/sh1mmer_gui.sh
source /usr/sbin/sh1mmer_optionsSelector.sh
shopt -s nullglob

showbg terminalGeneric.png

mapname() {
	case $1 in # you can't use return because bash sux
	'/usr/local/payloads/wifi.sh') printf 'Connect to wifi' ;;
	'/usr/local/payloads/autoupdate.sh') printf 'Fetch updated payloads. REQUIRES WIFI' ;;
	'/usr/local/payloads/stopupdates.sh') printf 'Update Disabler' ;;
	'/usr/local/payloads/troll.sh') printf "The Best Payload (troll.sh)" ;;
	'/usr/local/payloads/weston.sh') printf 'Launch the weston Desktop Environment. NEED A DEV SHIM' ;;
	'/usr/local/payloads/movie.sh') printf "Movie" ;;
	'/usr/local/payloads/mrchromebox.sh') printf "MrChromebox firmware-util.sh" ;;
	'/usr/local/payloads/caliginosity.sh') printf "Revert all changes made by sh1mmer (reenroll + ASN + more)" ;;
	'/usr/local/payloads/defog.sh') printf "Set GBB flags to allow devmode and unenrollment POST-112 (WP must be disabled)" ;;
    '/usr/local/payloads/defognew.sh') printf "Defog With DSN (WP must be disabled)"

	*) printf $1 ;;
	esac
}

selectorLoop() {
	selected=0
	while true; do
		idx=0
		for opt; do
			movecursor_generic $idx
			if [ $idx -eq $selected ]; then
				echo -n "--> $(mapname $opt)"
			else
				echo -n "    $(mapname $opt)"
			fi
			((idx++))
		done
		input=$(readinput)
		case $input in
		'kB') exit ;;
		'kE') return $selected ;;
		'kU')
			((selected--))
			if [ $selected -lt 0 ]; then selected=0; fi
			;;
		'kD')
			((selected++))
			if [ $selected -ge $# ]; then selected=$(($# - 1)); fi
			;;
		esac
	done
}
while true; do
	options=(/usr/local/payloads/*.sh)
	selectorLoop "${options[@]}"
	sel="$?"
	showbg terminalGeneric.png
	movecursor_generic 0
	bash "${options[$sel]}"
	sleep 2
	showbg terminalGeneric.png
done
