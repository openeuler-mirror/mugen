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
# @Contact   :   duanxuemin@163.com
# @Date      :   2022/10/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in podman package
# ############################################

source "../common/common3.4.4.2_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    podman pull registry.access.redhat.com/ubi8-minimal
    podman run --name postgres registry.access.redhat.com/ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    podman stop postgres
    podman logs -f $(podman ps -aq)
    CHECK_RESULT $? 0 0 'check podman logs -f $(podman ps -aq) failed'
    podman logs -l
    CHECK_RESULT $? 0 0 'check podman logs -l failed'
    podman logs --since 2020-12-31 $(podman ps -aq)
    CHECK_RESULT $? 0 0 'check podman logs --since 2020-12-31 $(podman ps -aq) failed'
    podman logs --tail 10 $(podman ps -aq)
    CHECK_RESULT $? 0 0 'check podman logs --tail 10 failed'
    podman logs -t $(podman ps -aq)
    CHECK_RESULT $? 0 0 'check podman logs -t failed'
    podman start postgres
    podman save -q -o alpine.tar registry.access.redhat.com/ubi8-minimal
    podman import --change CMD=/bin/bash --change ENTRYPOINT=/bin/sh --change LABEL=blue=image alpine.tar image-imported
    CHECK_RESULT $? 0 0 'check podman import --change CMD=/bin/bash --change ENTRYPOINT=/bin/sh --change LABEL=blue=image alpine.tar image-imported failed'
    cat alpine.tar | podman import -q --message "importing the alpine.tar tarball" - image-imported
    CHECK_RESULT $? 0 0 'check cat alpine.tar | podman import -q --message failed'
    podman export -o redis-container.tar $(podman ps -aq)
    CHECK_RESULT $? 0 0 'check podman export -o redis-container.tar failed'
    test -f redis-container.tar
    CHECK_RESULT $? 0 0 'check test -f redis-container.tar failed'
    podman tag $(podman images -q) test && podman images | grep test
    CHECK_RESULT $? 0 0 'check podman tag failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
