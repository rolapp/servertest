##!/usr/bin/env bash
#
#  servertest.sh
#  
#  Copyright 2016 Steffen Rolapp <sw@rolapp.de>
#  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/
#  
#  


#check if log dir exists

LOGDIR="/var/log/servertest"
if ! [ -d "$LOGDIR" ]
		then
			mkdir "$LOGDIR"
fi
# Check if there are any usable config files

if ls $(dirname $0)/server.d/*.config 1> /dev/null 2>&1; then
   
   # Loop through configs
   for f in $(dirname $0)/server.d/*.config
   do
	   source $f
	   
	   #test for logdir
	   IPDIR="$LOGDIR/$IP"
	   if ! [ -d "$IPDIR" ]
		then
			mkdir "$IPDIR"
	   fi
	   
	   # old Log merge
	   find $IPDIR -name 'test-*' | xargs cat >> $IPDIR/test.log
	   echo >> $IPDIR/test.log
	   echo `date +%Y-%m-%d_%H-%M` >> $IPDIR/test.log
	   echo >> $IPDIR/test.log
	   rm -rf $IPDIR/test-*.log
	   
	   LOG="$IPDIR/test-`date +%Y-%m-%d_%H-%M`.log"
	   FAIL="$IPDIR/fail-`date +%Y-%m-%d_%H-%M`.log"
	   
	   nc -zv $IP $PORTS 2> $LOG
	   cat $LOG | grep failed 1> /dev/null 2>&1
	   if [ $? = 0 ]
	   then
		 cat $LOG | grep failed > $FAIL
		 mail -s "Server ist down" $MAIL < $FAIL
	   fi
	
	   unset IPDIR
	   unset PORTS
	   unset IP 
	   unset MAIL
	   unset LOG
	   unset FAIL
   done  
else
   echo "There does not seem to be any config file available in $(dirname $0)/server.d/." ; exit 1;
fi
