#!/bin/bash

#-------------------------------------------
#    Capture the SIGINT signal
#    and terminate child processes
#-------------------------------------------

term() { 
  echo -e "\nCaught SIGINT signal!" 

  for child in $(jobs -p)
  do
      kill -TERM "$child" 2>/dev/null
  done
  exit
}

trap term SIGINT


#-------------------------------------------
#    Define the task
#-------------------------------------------

function run_task {
sleep 3
echo Completed  $1 $2 $3
}



#-------------------------------------------
#    Start a list/loop of tasks, handled
#    by groups of cores
#-------------------------------------------

Nproc=4
Tasks=0

for i in {1..3}
do
    for j in {1..3}
    do
        for k in {1..3}
        do

            if (( Tasks >= Nproc ))
            then
                wait -n
                ((Tasks--))
            fi

            run_task $i $j $k   &
            ((Tasks++)) 

        done
    done
done

wait
