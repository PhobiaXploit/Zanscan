#!/bin/bash

clear
f=3 b=4s
for j in f b; do
  for i in {0..7}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done

time=`date +"%T"`

useragents="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0"

echo "${f4}  ______ _______ __   _${f1} ,d88b.d88b ${f4} _______ _______ _______ __   _"
echo "${f4}   ____/ |_____| | \  |${f1} 88888888888${f4} |______ |       |_____| | \  |"
echo "${f4}  /_____ |     | |  \_|${f1}  Y8888888Y ${f4} ______| |_____  |     | |  \_|"
echo "${f7} --------------------------${f1}Y888Y${f7}----------------------------------"
echo "${f6} [${f3}WELCOME TO ZANSCAN${f6}]${f1}        Y"
echo "${f6}             [${f1}1${f6}]${f4} RCE SCANNER${f6}   [${f1}4${f6}]${f4} TAKE OVER SCANNER"
echo "${f6}             [${f1}2${f6}]${f4} LFI SCANNER${f6}   [${f1}5${f6}]${f4} ADMIN PAGE SCANNER"
echo "${f6}             [${f1}3${f6}]${f4} LFI SCANNER${f6}   [${f1}6${f6}]${f4} SHELL BACKDOOR SCANNER"

saved="result.txt"
con=1
miring=/

rce(){
    scan=$(curl -s -A '${useragent}' -o /dev/null -w '%{http_code}' ${url}${miring}${zrce})
    if [[ $scan == 200 ]] || [[ $scan = 301 ]] || [[ $scan =~ "/etc/passwd" ]]; then
        echo "${f6}[${f3}$time${f6}]${f2} $url$miring$zrce ~> ${f6}[${f7}OK${f6}]${f2}"
        echo "$url$miring$zrce" >> $saved
    elif [[ $scan =~ "/etc/passwd" ]]; then
            echo "${f6}[${f3}$time${f6}]${f2} $url$miring$zrce ~> ${f6}[${f7}OK${f6}]${f2}"
            echo "$url$miring$zrce" >> $saved
        else
            echo "${f6}[${f3}$time${f6}]${f2} $url$miring$zrce ~> ${f6}[${f1}FAIL${f6}]${f2}"
        fi
}
lfi(){
	scan=$(curl -s -A '${useragents}' -o /dev/null -w '%{http_code}' ${urlz}${miring}${zlfi})
	if [[ $scan == 200 ]] || [[ $scan == 301 ]] || [[ $scan =~ "/etc/passwd" ]]; then
		echo "${f2}[${f3}$time${f2}] $url$miring$zlfi ~> ${f6}[${f7}OK${f6}]${f2}"
		echo "$urlz$miring$zlfi" >> $saved
	elif [[ $scan =~ "/bin/bash" ]]; then
			echo "${f2}[${f3}$time${f2}] $url$miring$zlfi ~> ${f6}[${f3}OK${f6}]${f2}"
			echo "$urlz$miring$zlfi" >> $saved
		else
			echo "${f2}[${f3}$time${f2}] $url$miring$zlfi ~> ${f6}[${f1}FAIL${f6}]${f2}"
	fi
}

# func rfi
rfi(){
	scan2=$(curl -s -A '${useragents}' -o /dev/null -w '%{http_code}' ${url}${miring}${zrfi})
	if [[ $scan2 == 200 ]] || [[ $scan2 == 301 ]] || [[ $scan2 =~ "/etc/passwd" ]]; then
		echo "${f2}[${f3}$time${f2}] $url$miring$zrfi ~> ${f6}[${f7}OK${f6}]${f2}"
		echo "$urlz$miring$zrfi" >> $saved
	else
		echo "${f2}[${f3}$time${f2}] $url$miring$zrfi ~> ${f6}[${f1}FAIL${f6}]${f2}"
	fi
	
}
admin(){
    scan=$(curl -s -A '${useragents}' -o /dev/null -w '%{http_code}' ${url}${miring}${admin})
    if [[ $scan == 200 ]]; then
        echo "${f2}[${f3}$time${f2}] $url$miring$admin ~> ${f6}[${f7}OK${f6}]${f2}"
        echo "${url}${miring}$admin" >> $saved
    else
        echo "${f2}[${f3}$time${f2}] $url$miring$admin  ~> ${f6}[${f1}FAIL${f6}]${f2}"
    fi
}    
takeover(){
    scan=$(curl -s -A '${useragents}' -o /dev/null -w '%{http_code}' ${list})
    if [[ $scan == 200 ]]; then
        echo "${f2}[${f3}$time${f2}] $ztake ~> ${f6}[${f7}VULN${f6}]${f2}"
        echo "${url}${miring}$admin" >> $saved  
    else
        echo "${f2}[${f3}$time${f2}] $ztake  ~> ${f6}[${f1}FAIL${f6}]${f2}" 
    fi
}     
shell(){
    scan=$(curl -s -A '${useragents}' -o /dev/null -w '%{http_code}' ${url}${miring}${shells})
    if [[ $scan == 200 ]]; then
        echo "${f2}[${f3}$time${f2}] $url$miring$shells ~> ${f6}[${f7}OK${f6}]${f2}"
        echo "${url}${miring}$shells" >> $saved
    else
        echo "${f2}[${f3}$time${f2}] $url$miring$shells ~> ${f6}[${f1}FAIL${f6}]${f2}"
    fi
}                  

listtake(){
listtake=$(wc -l $list | cut -f1 -d '')
echo "Total LIST WEB ~> $listtake"
}
listrce(){
listrce=$(wc -l rce/RCE | cut -f1 -d '')
echo "Total RCE List ~> $listrce"
}
listlfi(){
listlfi=$(wc -l lfi/LFI | cut -f1 -d '')
echo "Total LFI List ~> $listlfi"
}

listrfi(){
listrfi=$(wc -l rfi/RFI | cut -f1 -d '')
echo "Total RFI List ~> $listrce"
}
listadmin(){
listadmin=$(wc -l admin/ADMIN | cut -f1 -d '')
echo "Total ADMIN List ~> $listadmin"
}
listshell(){
listshell=$(wc -l shell/SHELL | cut -f1 -d '')
echo "Total SHELL List ~> $listshell"
}

luptake(){
for ztake in $(cat $list)
do
    takeover &
    con=$[$con+1]
done
wait
}    
lupshell(){
for shells in $(cat shell/SHELL)
do
    shell &
    con=$[$con+1]
done
wait
}    
luprce(){
for zrce in $(cat rce/RCE)
do
    rce &    
    con=$[$con+1]
done
wait 
}
lupadmin(){
for admin in $(cat admin/ADMIN)
do
    admin &
    con=$[$con+1]
done
wait
}    
luplfi(){
for zlfi in $(cat lfi/LFI)
do 
	lfi & 
	con=$[$con+1]
done
wait 
}
luprfi(){
for zrfi in $(cat rfi/RFI)
do 
	rfi & 
	con=$[$con+1]
done
wait 
}

read -p "${f6}Option > ${f7}" opt;
if [[ $opt = 1 ]]; then
    read -p "${f6}Input URL > ${f7}" url;  
    echo "Scanning....."
    sleep 2
    listrce
    sleep 1
    luprce  
elif [[ $opt = 2 ]]; then
    read -p "${f6}Input URL > ${f7}" url; 
    echo "Scanning....."
    sleep 2
    listlfi
    sleep 1
    luplfi    
elif [[ $opt = 3 ]]; then
    read -p "${f6}Input URL > ${f7}" url;
    echo "Scanning....."
    sleep 2
    listrfi
    sleep 1
    luprfi
elif [[ $opt = 4 ]]; then
    read -p "${f6}Input LIST > ${f7}" list;
    echo "Scanning........"
    sleep 2
    listtake
    sleep 1
    luptake     
elif [[ $opt = 5 ]]; then
    read -p "${f6}Input URL > ${f7}" url;
    echo "Scanning........"
    sleep 2
    listadmin
    sleep 1
    lupadmin   
elif [[ $opt = 6 ]]; then
    read -p "${f6}Input URL > ${f7}" url;
    echo "Scanning........"
    sleep 2
    listshell
    sleep 1
    lupshell    
fi                   
 
