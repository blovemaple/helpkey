#!/bin/bash

signal=$1

ps aux\
|awk -v me=`whoami` '{if($1==me){print $2,$3,$11}}'\
|awk '
BEGIN{
	max = 0;
	pid=-1;
	cmd="";
}
{
	if ($2>max){
		max=$2;
		pid=$1;
		cmd=$3;
	}
}
END{
print pid,max,cmd
}
'|while read pid cpu cmd
do
	if [ -z $signal ]
	then
		kill $pid
	else
		kill -$signal $pid
	fi

	if [ $? -eq 0 ]
	then
		result='succeeded'
	else
		result='failed'
	fi
	echo ${result}: kill $pid using cpu ${cpu}% - $cmd
done
