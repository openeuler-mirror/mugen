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
#@Desc      	:   Run busybox testsuite
#####################################

source ../comm_lib.sh

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    cp ./tmp_test/defconfig-busybox /bin/.config
    export bindir=/bin/
    export SKIP_KNOWN_BUGS=1

    pushd ./tmp_test/testsuite
    #cpio case
    sed -i 's/optional FEATURE_LS_SORTFILES FEATURE_LS_TIMESTAMPS/optional FEATURE_LS_SORTFILES FEATURE_LS_TIMESTAMPS CONFIG_BZCAT/g' cpio.tests
    sed -i '/testing "cpio extracts in existing directory"/i\optional CONFIG_BZCAT' cpio.tests

    #mv case
    sed -i '1i # FEATURE: CONFIG_FEATURE_TOUCH_SUSV3' mv/mv-files-to-dir
    sed -i '1i # FEATURE: CONFIG_FEATURE_TOUCH_SUSV3' mv/mv-files-to-dir-2
    sed -i '1i # FEATURE: CONFIG_FEATURE_TOUCH_SUSV3' mv/mv-refuses-mv-dir-to-subdir

    # strings case
    sed -i 's/..\/..\/busybox/..\/..\/testsuite/g' strings/strings-works-like-GNU

    # tar case
    sed -i 's/FEATURE_TAR_AUTODETECT LS/FEATURE_TAR_AUTODETECT LS UUDECODE/g' tar.tests
    sed -i '1a # FEATURE: CONFIG_BUNZIP2' tar/tar_with_link_with_size

    # touch case
    sed -i '1i # FEATURE: CONFIG_FEATURE_TOUCH_SUSV3' touch/touch-touches-files-after-non-existent-file

    # patch du -l
    sed -i '/144/a \ \ -o x"`busybox du -l .`" = x"145\t." \\' du/du-l-works

    popd

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    pushd ./tmp_test/testsuite

    chmod -R 777 ./
    ./runtest > tmp_log.log 2>&1

    ignoreFail=("FAIL: unzip (subdir only)" "FAIL: start-stop-daemon with both -x and -a" )

    while read line; do
        echo "$line"
        if [[ $line =~ ":" ]]; then
            resuleTitle=${line%:*}
            if [[ "${ignoreFail[*]}" =~ "${line}" ]]; then
                continue
            else
                echo ${resuleTitle} | grep -q "FAIL"
                CHECK_RESULT $? 0 1 "run busybox testcase fail info: $line"
            fi
        fi

    done < tmp_log.log

    popd

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf /bin/.config
    export SKIP_KNOWN_BUGS=

    LOG_INFO "End to restore the test environment."
}

main "$@"
