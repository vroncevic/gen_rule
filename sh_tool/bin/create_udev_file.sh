#!/bin/bash
#
# @brief   UDEV rule generator
# @version ver.2.0
# @date    Thu 02 Dec 2021 01:18:25 AM CET
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#

declare -A CREATE_UDEV_RULE_USAGE=(
    [USAGE_TOOL]="__create_udev_file"
    [USAGE_ARG1]="[UDEV Target name] Name of target board"
    [USAGE_EX_PRE]="# Creating UDEV rule file"
    [USAGE_EX]="__create_udev_file \$UDEVF"
)

#
# @brief  Creating UDEV rule in system
# @param  Value required target name
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __create_udev_file $TN
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function __create_udev_file {
    local UDEVN=$1
    if [ -n "${UDEVN}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        MSG="Generate udev rule!"
        info_debug_message "$MSG" "$FUNC" "$GEN_RULE_TOOL"
        local CFGT="${GEN_RULE_HOME}/conf/${config_gen_rule_util[UDEVT]}"
        declare -A rule_templates=()
        load_util_conf "$CFGT" rule_templates
        STATUS=$?
        if [ $STATUS -eq $NOT_SUCCESS ]; then
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$GEN_RULE_TOOL"
            return $NOT_SUCCESS
        fi
        local UDEVT=${rule_templates[${UDEVN}]} H="#"
        local UDEVF="${config_gen_rule_util[UDEVD]}/${UDEVN}.rules"
        local UDEVTF="${GEN_RULE_HOME}/conf/${UDEVT}"
        MSG="Generate file [${UDEVF}]"
        info_debug_message "$MSG" "$FUNC" "$GEN_RULE_TOOL"
        while read UDEVL
        do
            eval echo "${UDEVL}" >> ${UDEVF}
        done < ${UDEVTF}
        MSG="Set permission!"
        info_debug_message "$MSG" "$FUNC" "$GEN_RULE_TOOL"
        eval "chmod 644 ${UDEVF}"
        local UDEVTOOL=${config_gen_rule_util[UDEV]}
        check_tool "${UDEVTOOL}"
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            eval "${UDEVTOOL}"
        else
            MSG="Generate file [${UDEVF}] with udevadm"
            info_debug_message "$MSG" "$FUNC" "$GEN_RULE_TOOL"
            eval "udevadm control --reload"
        fi
        info_debug_message_end "Done" "$FUNC" "$GEN_RULE_TOOL"
        return $SUCCESS
    fi
    usage CREATE_UDEV_RULE_USAGE
    return $NOT_SUCCESS
}

