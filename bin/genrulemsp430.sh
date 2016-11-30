#!/bin/bash
#
# @brief   UDEV rules setup for MSP430 interface board
# @version ver.1.0
# @date    Wed Nov 30 15:49:54 CET 2016
# @company None, free sowtware to use 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=$UTIL_ROOT/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/checkroot.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/sendmail.sh
. $UTIL/bin/loadconf.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/progressbar.sh

GENRULEMSP430_TOOL=genrulemsp430
GENRULEMSP430_VERSION=ver.1.0
GENRULEMSP430_HOME=$UTIL_ROOT/$GENRULEMSP430_TOOL/$GENRULEMSP430_VERSION
GENRULEMSP430_CFG=$GENRULEMSP430_HOME/conf/$GENRULEMSP430_TOOL.cfg
GENRULEMSP430_UTIL_CFG=$GENRULEMSP430_HOME/conf/${GENRULEMSP430_TOOL}_util.cfg
GENRULEMSP430_LOG=$GENRULEMSP430_HOME/log

declare -A GENRULEMSP430_USAGE=(
	[USAGE_TOOL]="$GENRULEMSP430_TOOL"
	[USAGE_ARG1]="[OPTION] --install | --uninstall"
	[USAGE_EX_PRE]="# Instaling UDEV rule"
	[USAGE_EX]="$GENRULEMSP430_TOOL --install"
)

declare -A GENRULEMSP430_LOGGING=(
	[LOG_TOOL]="$GENRULEMSP430_TOOL"
	[LOG_FLAG]="info"
	[LOG_PATH]="$GENRULEMSP430_LOG"
	[LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
	[BAR_WIDTH]=50
	[MAX_PERCENT]=100
	[SLEEP]=0.01
)

TOOL_DBG="false"

#
# @brief  Remove UDEV rule
# @param  None
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __remove_udev_file
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # return $NOT_SUCCESS
#   # or
#   # exit 128
# fi
#
function __remove_udev_file() {
	if [ -e "${configgenrulemsp430[UDEV_FILE]}" ]; then
		rm -f "${configgenrulemsp430[UDEV_FILE]}"
		if [ $? -ne 0 ]; then
			local MSG="Failed to remove ${configgenrulemsp430[UDEV_FILE]}"
			if [ "${configgenrulemsp430[LOGGING]}" == "true" ]; then
				GENRULEMSP430_LOGGING[LOG_MSGE]="$MSG"
				GENRULEMSP430_LOGGING[LOG_FLAG]="error"
				__logging GENRULEMSP430_LOGGING
			fi
			if [ "${configgenrulemsp430[EMAILING]}" == "true" ]; then
				__sendmail "$MSG" "${configgenrulemsp430[ADMIN_EMAIL]}"
			fi
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$GENRULEMSP430_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$GENRULEMSP430_TOOL" "$MSG"
			fi
			return $NOT_SUCCESS
		fi
		MSG="Removed UDEV rule file: ${configgenrulemsp430[UDEV_FILE]}"
		if [ "${configgenrulemsp430[LOGGING]}" == "true" ]; then
			GENRULEMSP430_LOGGING[LOG_MSGE]="$MSG"
			GENRULEMSP430_LOGGING[LOG_FLAG]="info"
			__logging GENRULEMSP430_LOGGING
		fi
		return $SUCCESS
	fi
	return $NOT_SUCCESS	
}

#
# @brief   Main function 
# @params  Values required option
# @exitval Function __genrulemsp430 exit with integer value
#			0   - tool finished with success operation 
#			128 - missing argument(s) from cli 
#			129 - failed to load tool script configuration from file 
#			130 - failed to load tool script utilities configuration from file
#			131 - missing external tool 
#			132 - falied to remove UDEV rule file
#			133 - falied to remove UDEV rule file
#			134 - wrong option
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __genrulemsp430 e "/opt/origin.txt"
#
function __genrulemsp430() {
	local OPTION=$1
	if [ -n "$OPTION" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="Loading basic and util configuration"
		printf "$SEND" "$GENRULEMSP430_TOOL" "$MSG"
		__progressbar PB_STRUCTURE
		printf "%s\n\n" ""
		declare -A configgenrulemsp430=()
		__loadconf $GENRULEMSP430_CFG configgenrulemsp430
		local STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Failed to load tool script configuration"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$GENRULEMSP430_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$GENRULEMSP430_TOOL" "$MSG"
			fi
			exit 129
		fi
		declare -A configgenrulemsp430util=()
		__loadutilconf $GENRULEMSP430_UTIL_CFG configgenrulemsp430util
		STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Failed to load tool script utilities configuration"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$GENRULEMSP430_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$GENRULEMSP430_TOOL" "$MSG"
			fi
			exit 130
		fi
		__checktool "${configgenrulemsp430util[UDEV]}"
		STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Missing external tool ${configgenrulemsp430util[UDEV]}"
			if [ "${configgenrulemsp430[LOGGING]}" == "true" ]; then
				GENRULEMSP430_LOGGING[LOG_MSGE]="$MSG"
				GENRULEMSP430_LOGGING[LOG_FLAG]="error"
				__logging GENRULEMSP430_LOGGING
			fi
			if [ "${configgenrulemsp430[EMAILING]}" == "true" ]; then
				__sendmail "$MSG" "${configgenrulemsp430[ADMIN_EMAIL]}"
			fi
			exit 131
		fi
		if [ "$OPTION" == "--install" ]; then
			__remove_udev_file
			STATUS=$?
			if [ $STATUS -eq $NOT_SUCCESS ]; then
				exit 132
			fi
			local MSP430UIF="ATTRS{idVendor}==\"2047\",ATTRS{idProduct}==\"0010\",MODE=\"0666\""
    		local MSP430EZ="ATTRS{idVendor}==\"2047\",ATTRS{idProduct}==\"0013\",MODE=\"0666\""
    		local MSP430HID="ATTRS{idVendor}==\"2047\",ATTRS{idProduct}==\"0203\",MODE=\"0666\""
			local LINES="#TI MSP430UIF\n$MSP430UIF\n$MSP430EZ\n$MSP430HID\n"
		    echo -e "$LINES" > ${configgenrulemsp430util[UDEV_FILE]}
		    chmod 644 ${configgenrulemsp430util[UDEV_FILE]}
			eval "${configgenrulemsp430util[UDEV]}"
		    if [ $? -ne 0 ]; then
		        MSG="Failed to restart udev, reboot required"
				GENRULEMSP430_LOGGING[LOG_MSGE]="$MSG"
				GENRULEMSP430_LOGGING[LOG_FLAG]="error"
				__logging GENRULEMSP430_LOGGING
				printf "$SEND" "$OSSL_TOOL" "Done"
		    fi
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$OSSL_TOOL" "$FUNC" "Done"
			else
				printf "$SEND" "$OSSL_TOOL" "Done"
			fi
			exit 0
		elif [ "$OPTION" == "--uninstall" ]; then
			__remove_udev_file
			STATUS=$?
			if [ $STATUS -eq $NOT_SUCCESS ]; then
				exit 133
			fi
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$OSSL_TOOL" "$FUNC" "Done"
			else
				printf "$SEND" "$OSSL_TOOL" "Done"
			fi
			exit 0
		fi
		MSG="Wrong option: $OPTION"
		if [ "${configgenrulemsp430[LOGGING]}" == "true" ]; then
			GENRULEMSP430_LOGGING[LOG_MSGE]="$MSG"
			GENRULEMSP430_LOGGING[LOG_FLAG]="error"
			__logging GENRULEMSP430_LOGGING
		fi
		__usage GENRULEMSP430_USAGE
		exit 134
	fi
	__usage GENRULEMSP430_USAGE
	exit 128
}

#
# @brief   Main entry point of script tool
# @params  Values required option
# @exitval Script tool genrulemsp430 exit with integer value
#			0   - tool finished with success operation 
# 			127 - run tool script as root user from cli
#			128 - missing argument(s) from cli 
#			129 - failed to load tool script configuration from file 
#			130 - failed to load tool script utilities configuration from file
#			131 - missing external tool 
#			132 - falied to remove UDEV rule file
#			133 - falied to remove UDEV rule file
#			134 - wrong option
#
printf "\n%s\n%s\n\n" "$GENRULEMSP430_TOOL $GENRULEMSP430_VERSION" "`date`"
__checkroot
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
	__genrulemsp430 $1
fi

exit 127

