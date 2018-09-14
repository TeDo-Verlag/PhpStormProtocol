#!/bin/sh
URL="$1"

REGEX="^phpstorm://([^/?]+)/?\?(url=file://|file=)(.*)&line=(.*)$"

if [[ ${URL} =~ $REGEX ]]; then
    PC=${BASH_REMATCH[1]}
    FILE=${BASH_REMATCH[3]}
    LINE=${BASH_REMATCH[4]}
    PROJECT_DIR=''

    MAPPER="${HOME}/phpstorm-mapper.php"

    if [ -f ${MAPPER} ]; then

        set -f; OLD_IFS=$IFS; IFS=$'\n'
        RESULT=( $( "$(which php)" "${MAPPER}" "${PC}" "${FILE}" ) )
        set +f; IFS=${OLD_IFS}

        if [ 0 == $? ]; then
            FILE=${RESULT[0]}
            PROJECT_DIR=${RESULT[1]}
        fi
    fi

    if [ -z ${TERM} ]; then
        /usr/local/bin/pstorm "${PROJECT_DIR}" "${FILE}":${LINE}
    else
        echo ""
        echo "File: $FILE"
        [[ -n ${PROJECT_DIR} ]] && \
        echo "Dir:  $PROJECT_DIR"
    fi
fi