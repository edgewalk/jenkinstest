#! /bin/bash

JAVA_PATH=/usr/local/service/jdk1.8.0_181/bin
JAVA_OPS=" -Xmx128m -Xms128m -Dserver.port=8090 "
SERVICEPATH=/data/jenkinstest/
SERVICENAME=jenkinstest-1.0-SNAPSHOT.jar

start() {
    PROCESSID=$( ps aux |grep ${SERVICEPATH}/${SERVICENAME}| grep -v 'grep' | awk -F ' ' '{print $2}' )
    if [ ! $PROCESSID ]
    then
        nohup ${JAVA_PATH}/java -jar $JAVA_OPS ${SERVICEPATH}/${SERVICENAME} >nohup.out 2>&1 &
        sleep 1
        echo "start...processid="$( ps aux |grep ${SERVICEPATH}/${SERVICENAME}| grep -v 'grep' | awk -F ' ' '{print $2}' )
    else
        echo  "Process already start processid=${PROCESSID}"
    fi
}
stop() {
    PROCESSID=$( ps aux |grep ${SERVICEPATH}/${SERVICENAME}| grep -v 'grep' | awk -F ' ' '{print $2}' )
    if [ ! $PROCESSID ]
    then
        echo  "Process already stoped"
    else
        echo -n "Killing..."
         ps aux |grep ${SERVICEPATH}/${SERVICENAME}| grep -v 'grep' | awk -F ' ' '{print $2}' | xargs kill -s 9
         while [ $( ps aux |grep ${SERVICEPATH}/${SERVICENAME}| grep -v 'grep' | awk -F ' ' '{print $2}' ) ];
         do
              echo -n "."
              sleep 1
         done
         rm -f nohup.out
         echo -ne " Done\n"
    fi
}

restart() {
    PROCESSID=$( ps aux |grep ${SERVICEPATH}/${SERVICENAME}| grep -v 'grep' | awk -F ' ' '{print $2}' )
    if [ ! $PROCESSID ]
    then
        #进程不存在  start
        start
    else
        # 进程存在  stop->start
        stop
        start
    fi
}

status() {
  PROCESSID=$( ps aux |grep ${SERVICEPATH}/${SERVICENAME}| grep -v 'grep' | awk -F ' ' '{print $2}' )
    if [ ! $PROCESSID ]
    then
        #进程不存在
        echo "process is stop"
    else
        # 进程存在
       echo "process is start processid="$( ps aux |grep ${SERVICEPATH}/${SERVICENAME}| grep -v 'grep' | awk -F ' ' '{print $2}' )
    fi
}


case "$1" in
    start   )
      start
      exit $?
    ;;
    stop    )
      stop
      exit $?
    ;;
    restart  )
      restart
      exit $?
    ;;
    status  )
      status
      exit $?
    ;;
    *       )
      echo "  Unknown command: \`$1'"
      echo "  Usage: $0 ( commands ... )"
      echo "  commands:"
      echo "  start             Start "
      echo "  stop              Stop "
      echo "  restart           restart"
      echo "  status            status"
      echo "                    are you running?"
      exit 1
    ;;
esac