#!/bin/bash
findProc(){
proce=$(ps -eo pid,comm,%cpu | sort -nrk3 | head -1)
ti=$(date +%F%t%T%t)
all=$ti$proce
echo $all
if [ ! -d "$HOME/log" ]
then $(mkdir /home/$(whoami)/log) 
fi
if [ ! -d "$HOME/log/$(date +%Y-%m)" ]
then $(mkdir /home/$(whoami)/log/$(date +%Y-%m)) 
fi
if [  -e "$HOME/log/$(date +%Y-%m)/load$(date +-%d).log" ]
then $(echo $all>>/home/$(whoami)/log/$(date +%Y-%m)/load$(date +-%d).log)
else $(echo $all>/home/$(whoami)/log/$(date +%Y-%m)/load$(date +-%d).log)
fi
}
cleanUp(){
oldmo=$(echo "$(date +%m) - 1"|bc)
oldye=$(echo "$(date +%Y) - 1"|bc)
olddir="$HOME/log/$(date +%Y-0$oldmo)"
if [  "$oldmo" -eql 0  ]
then olddir="$HOME/log/$oldye-01)"
fi
if [ -d "$olddir" ]
then $(find $olddir/ -type f -mtime +30 -delete)
if [ ! "$(ls -A $olddir)"  ]
then $(rm -r $olddir)
fi
fi
}
clean(){
find $HOME/log/ -type f -mtime +30 -delete
find $HOME/log/ -type d -empty -delete
}
echo "starting"
nc=$(grep "^core id" /proc/cpuinfo | sort -u | wc -l)
loada=$(head -1 /proc/loadavg)
nc=$(expr $nc*0.8 | bc)
echo $nc
echo $loada
STR_ARRAY=(`echo $loada | tr "," "\n"`)
IFS=' ' read -ra loa <<< "$loada"
echo ${loa[0]}
load=${loa[0]}
echo $load
if [ $(echo "$load<$nc" | bc) -ne 0  ] 
then findProc
clean
fi
