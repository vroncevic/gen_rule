#!/bin/bash
#
# @brief   List UDEV rule file templates
# @version ver.1.0.0
# @date    Wed Nov 30 15:49:54 CET 2016
# @company None, free sowtware to use 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

#
# @brief  List UDEV rule file templates
# @param  None
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __list_udev_files
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
function __list_udev_files {
    local FUNC=${FUNCNAME[0]} MSG="None" STATUS I
    MSG="Listing udev rule templates"
    info_debug_message "$MSG" "$FUNC" "$GEN_RULE_TOOL"
    local CFG="${GEN_RULE_HOME}/conf/${config_gen_rule_util[UDEVN]}"
    declare -A rule_names=()
    load_util_conf "$CFG" rule_names
    STATUS=$?
    if [ $STATUS -eq $NOT_SUCCESS ]; then
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$GEN_RULE_TOOL"
        return $NOT_SUCCESS
    fi
    for I in "${!rule_names[@]}"
    do
        printf "%s\n" "Target device board [${I}]"
    done
    info_debug_message_end "Done" "$FUNC" "$GEN_RULE_TOOL"
    return $SUCCESS
}

