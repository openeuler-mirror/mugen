#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   duanxuemin
# @Contact   :   52515856@qq.com
# @Date      :   2020-05-07
# @License   :   Mulan PSL v2
# @Desc      :   Activate a logical volume with a missing device
# ############################################
source ../common/storage_disk_lib.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    check_free_disk
    pvcreate -y /dev/${local_disk} /dev/${local_disk1}
    vgcreate openeulertest /dev/${local_disk}
    vgcreate opentest /dev/${local_disk1}
    lvcreate -y -L 50MB -n test openeulertest /dev/${local_disk}
    lvcreate -y -L 50MB -n test1 opentest /dev/${local_disk1}
    LOG_INFO "Loading data is complete!"
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    lvchange -ay openeulertest/test --activationmode degraded openeulertest
    CHECK_RESULT $?
    lvchange -ay openeulertest/test --activationmode degraded
    CHECK_RESULT $?
    lvchange -ay opentest/test1 --activationmode degraded opentest
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    vgremove -y openeulertest
    vgremove -y opentest
    pvremove /dev/${local_disk} /dev/${local_disk1}
    LOG_INFO "Finish environment cleanup."
}

main $@
