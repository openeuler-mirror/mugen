#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   saarloos
#@Contact   	:   9090-90-90-9090@163.com
#@Date      	:   2020-08-12 11:03:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run e2fsprogs testsuite
#####################################

source ../comm_lib.sh

CUR_DATE=`date +'%Y-%m-%d %H:%M:%S'`

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    pushd ./tmp_test/
    #更新时间
    timestap=`stat -c %Y tests/test_config`
    formart_date=`date '+%Y-%m-%d %H:%M:%S' -d @$timestap`
    date -s "$formart_date"

    #建立软连接，对应test_config中的FSCK
    mkdir -p e2fsck
    fsck=$(which e2fsck)
    ln -s ${fsck} e2fsck
    popd

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    declare -A ignoreFail
    getCasesFromFile ignoreFail ignore.txt

    pushd ./tmp_test/tests

    chmod 777 ./test_*

    source ./test_config
    
    SKIP_SLOW_TESTS=yes ./test_script > tmp_run_srcipt.log 2>&1

    while read line || [[ -n $line ]]; do
        if [[ $line =~ ":" ]]; then
            resultTitle=${line%%:*}
            resultTail=${line##*:}
            testcase=`echo $resultTitle | sed -e 's/^[ \t]//g' -e 's/[ \t]*$//g'`
            resultTail=`echo $resultTail | sed -e 's/^[ \t]//g' -e 's/[ \t]*$//g'`
            [[ ${ignoreFail[$testcase]} -eq 1 ]] && continue
            if [[ "${resultTail}" == "failed" ]]; then
                CHECK_RESULT 1 0 0 "run e2fsprogs testcase fail info: $line"
            fi
        fi

    done < tmp_run_srcipt.log

    popd

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf /var/volatile/tmp/*e2fsprogs*

    date -s "$CUR_DATE"

    LOG_INFO "End to restore the test environment."
}

main "$@"
