#!/usr/bin/bash
# Copyright (c) [2021] Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author  : saarloos   
# @email   : 9090-90-90-9090@163.com
# @Date    : 2022-08-30 15:11:47
# @License : Mulan PSL v2
# @Version : 1.0
# @Desc    :
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

tar -xf tmp_test.tar

pushd ../
if [[ -z "${RUNTEST}" ]]; then
    CUR=`pwd`
    tar -xf dejagnu.tar
    RUNTEST=${CUR}/dejagnu/bin/runtest
    chmod +x ${RUNTEST}
    export RUNTEST
fi
popd

function getCasesFromFile() {
    declare -n array="$1"
    filename=$2
    while read line || [[ -n $line ]] ; do
        [[ $line =~ ^#.* ]] && continue
        [[ -z "$line" ]] && continue
        if [[ $line =~ "#" ]]; then
            casename=${line%%#*}
        else
            casename=$line
        fi
        casename=`echo $casename | sed -e 's/^[ \t]//g' -e 's/[ \t]*$//g'`
        array[$casename]=1
    done < $filename
}