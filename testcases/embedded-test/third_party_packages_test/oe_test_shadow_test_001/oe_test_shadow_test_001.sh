#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   s-c-c
#@Contact   	:   shichuchao@huawei.com
#@Date      	:   2020-08-25 11:03:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run shadow testsuite
#####################################

source ../comm_lib.sh

function pre_test() {
    LOG_INFO "Start shadow preparation."

    sed -i 's/build_path=.*$/build_path=$(dirname $(readlink -f \"$PWD\"))\/..\//g' ./tmp_test/tests/common/config.sh

    pushd ./tmp_test/tests
    allExp=$(find ./ -name "*.exp")
    # for oneExp in ${allExp[@]}; do
    # sed -i "s/uid=424243(testsuite)/uid=424243/g" $oneExp
    # sed -i "s/uid=424242(myuser) gid=424242(myuser) groups=424242(myuser)/uid=424242 gid=424242 groups=424242/g" $oneExp
    # done
    allExp=$(find ./su/02 -name "*.exp")
    for oneExp in ${allExp[@]}; do
    sed -i 's#PATH=\\"/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games\\"\\r#PATH=\\"/usr/local/bin:/usr/bin:/bin\\"#g' $oneExp
    sed -i 's#PATH=\\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\\"\\r#PATH=\\"/sbin:/usr/sbin:/usr/local/sbin:/root/bin:/usr/local/bin:/usr/bin:/bin\\"#g' $oneExp
    done
    popd

    LOG_INFO "End of shadow preparation!"
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run shadow test."

    pushd ./tmp_test/tests

    chmod +x run_embedded
    ./run_embedded
    while read line; do
        echo "$line" | grep -q "# Status of test * FAILURE"
        CHECK_RESULT $? 0 1 "shadow run_embedded failed! info : $line"
    done < testsuite.log

    popd

    LOG_INFO "End to run shadow test."
}

main "$@"
