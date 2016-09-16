if [[ $# -eq 2  ]]; then
	echo "Using roku ip: $2"
	rokuip=$2
else
	rokuip="192.168.0.13"
fi

if [[ $# -eq 0  ]]; then
	echo "ERROR: usage - $0 <MODE> $<IP>"
	echo "required - <MODE>=r for release, <MODE>=d for dev"
	echo "optional - <IP>=roku ip address"
elif [[ $1 == "r" ]]; then
	curl -d '' http://$rokuip:8060/keypress/home
	ruby sideload.rb r $rokuip
elif [[ "d" == $1 ]]; then
	curl -d '' http://$rokuip:8060/keypress/home
	echo "Sending new version to roku device"
	ruby sideload.rb d $rokuip
else
	echo "ERROR"
fi
