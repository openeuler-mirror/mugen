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
#@Desc      	:   Run dosfstools testsuite
#####################################

source ../comm_lib.sh

CUR_DATE=`date +'%Y-%m-%d %H:%M:%S'`

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    pushd ./tmp_test/
    #更新时间
    timestap=`stat -c %Y test/test-driver`
    formart_date=`date '+%Y-%m-%d %H:%M:%S' -d @$timestap`
    date -s "$formart_date"
    popd

    export LOGROTATE=/usr/sbin/logrotate

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    declare -A ignoreFail
    getCasesFromFile ignoreFail ignore.txt

    pushd ./tmp_test/test

    chmod 777 ./*

    runList=$(find ./ -name "test-0*.sh" | sort)
    failTitles=("XPASS" "ERROR" "FAIL")
    for onetest in ${runList[@]}; do
        testName=${onetest##*/}
        testName=`echo $testName | sed -e 's/^[ \t]//g' -e 's/[ \t]*$//g'`
        [[ ${ignoreFail[$testName]} -eq 1 ]] && continue
        echo "Run: ./test-driver --test-name ${testName} --log-file ${testName}.log --trs-file ${testName}.trs $onetest"
        outStr=$(./test-driver --test-name ${testName} --log-file ${testName}.log --trs-file ${testName}.trs $onetest)
        echo "Output: $outStr"
        outTitle=${outStr%%:*}
        outTitle=`echo $outTitle | sed -e 's/^[ \t]//g' -e 's/[ \t]*$//g'`
        if [[ "${failTitles[*]}" =~ "${outTitle}" && "${outTitle}" != "PASS" ]]; then
            CHECK_RESULT 1 0 0 "run logrotate testcase $testName fail"
            cat ${testName}.log
        fi
    done

    popd

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    date -s "$CUR_DATE"

    LOG_INFO "End to restore the test environment."
}

main "$@"
