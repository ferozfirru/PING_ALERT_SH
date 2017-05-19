#!/bin/bash
#by fer

hts=()
hts[000]="Timedout/Down"
hts[100]="Continue"
hts[101]="Switching Protocols"
hts[102]="Processing"
hts[200]="OK"
hts[201]="Created"
hts[202]="Accepted"
hts[203]="Non-Authoritative Information"
hts[204]="No Content"
hts[205]="Reset Content"
hts[206]="Partial Content"
hts[207]="Multi-Status"
hts[300]="Multiple Choices"
hts[301]="Moved Permanently"
hts[302]="Found"
hts[303]="See Other"
hts[304]="Not Modified"
hts[305]="Use Proxy"
hts[306]="Switch Proxy"
hts[307]="Temporary Redirect"
hts[400]="Bad Request"
hts[401]="Unauthorized"
hts[402]="Payment Required"
hts[403]="Forbidden"
hts[404]="Not Found"
hts[405]="Method Not Allowed"
hts[406]="Not Acceptable"
hts[407]="Proxy Authentication Required"
hts[408]="Request Timeout"
hts[409]="Conflict"
hts[410]="Gone"
hts[411]="Length Required"
hts[412]="Precondition Failed"
hts[413]="Request Entity Too Large"
hts[414]="Request-URI Too Long"
hts[415]="Unsupported Media Type"
hts[416]="Requested Range Not Satisfiable"
hts[417]="Expectation Failed"
hts[418]="Im a teapot"
hts[422]="Unprocessable Entity"
hts[423]="Locked"
hts[424]="Failed Dependency"
hts[425]="Unordered Collection"
hts[426]="Upgrade Required"
hts[449]="Retry With"
hts[450]="Blocked by Windows Parental Controls"
hts[500]="Internal Server Error"
hts[501]="Not Implemented"
hts[502]="Bad Gateway"
hts[503]="Service Unavailable"
hts[504]="Gateway Timeout"
hts[505]="HTTP Version Not Supported"
hts[506]="Variant Also Negotiates"
hts[507]="Insufficient Storage"
hts[509]="Bandwidth Limit Exceeded"
hts[510]="Not Extended"

google="https://www.google.com"

mails="youremail@server.com"

sct=0
while true
do
chk=0

sta="$(curl -A "alerts" --connect-timeout 6 -o /dev/null --silent --head --write-out '%{http_code}' "$google")"
if (( $sta != 200 && $sct != 1 ))
then
cdt="$(date)"
ctd2=$(date)
mail -S from=alerts@server.com -s "󾭥 google.com : $sta (${hts[$sta]}) " "$mails" << END_MAIL
"$google" is responded with status code : "$sta" on "$cdt"
END_MAIL
chk=1
sct=1
elif (( $sct == 1  &&  $sta == 200 ))
then

ctd1=$(date)
ctop=$(( ( $(date -ud "$ctd1" +'%s') - $(date -ud "$ctd2" +'%s') ) ))
if [[ "$ctop" -lt "60" ]]; then
ctres="$ctop second(s)"
else
ctres="$(( $ctop / 60 )) min(s)"
fi
mail -S from=alerts@server.com -s "󾭦 google.com is UP : $sta (${hts[$sta]}) ($ctres)" "$mails" << END_MAIL
"$google" is Fine : "$(date)"
END_MAIL
sct=0
ctd2=""
ctres=""
else
    r=1
fi

sleep 1
done
