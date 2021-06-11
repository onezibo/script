#!/bin/bash
export SAMPLE_X86=/root/PMP/samples/VirusShareLinux_2020_x86/VirusShare_ELF_X86_2020
export SAMPLE_X64=/root/PMP/samples/VirusShareLinux_2020_x86/VirusShare_ELF_X64_2020
export PMP=/root/PMP/pmp.sh
export SAMPLE_TEST=/root/PMP/samples/test
export SAMPLE_LOG=/root/PMP/script/log
export SAMPLE_FAILED=/root/PMP/samples/failed
export SAMPLE_SUCCESS_X86=/root/PMP/samples/success_x86
export SAMPLE_SUCCESS_X64=/root/PMP/samples/success_x64
export SAMPLE_SUCCESS_TEST=/root/PMP/samples/success_test
export WORKDIR=/root/PMP/work


WAITING_TIME=300

do_analysis_x86(){
    for i in $SAMPLE_X86/*
    do
    dir="$WORKDIR/${i##*/}/"
    if [ ! -d $dir ]; then
        Command="$PMP $i PDFE --pp-only"
        echo ${Command}
        ${Command} &
        Commandpid=$!
        {
            sleep ${WAITING_TIME};
            if ps -p ${Commandpid} >/dev/null 2>&1 ; then
                Commandppid=$(ps -p ${Commandpid} -o ppid= 2>/dev/null)
                if [ X${Commandppid//\ } = X$$ ];then
                    kill -9 ${Commandpid};
                    rm ${i}_running
                    mv $i $SAMPLE_FAILED
                    echo "kill command" ${Commandpid}
                fi
            fi
        } &
        MonitorPid=$!
        wait ${Commandpid}
        if ps -p ${MonitorPid} >/dev/null 2>&1 ;then
            MonitorPPid=$(ps -p ${MonitorPid} -o ppid= 2>/dev/null)
            if [ X${MonitorPPid//\ } = X$$ ];then
                kill -9 ${MonitorPid}
                rm ${i}_running
                mv $i $SAMPLE_SUCCESS_X86
                echo "kill monitor"
            fi
        else 
            echo ${Command} timeout!
        fi
    else
        echo -e "\nFile $i Has Been Analyzed\n"
    fi
    done
}

#do_analysis_x64
do_analysis_x86
