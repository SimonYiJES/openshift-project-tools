#!/bin/bash

OCTOOLSBIN=$(dirname $0)

usage() {
  cat <<-EOF
  Tags the project's images

  Usage: $0 [ -h -x ] -s <source_tag> -t <destination_tag>

  OPTIONS:
  ========
    -s the source tag name
    -t the tag to apply
    -h prints the usage for the script
    -x run the script in debug mode to see what's happening

    Update settings.sh and settings.local.sh files to set defaults
EOF
exit 1
}

# In case you wanted to check what variables were passed
# echo "flags = $*"
while getopts s:t:hx FLAG; do
  case $FLAG in
    s) export SOURCE_TAG=$OPTARG ;;
    t) export DESTINATION_TAG=$OPTARG ;;
    x ) export DEBUG=1 ;;
    h ) usage ;;
    \?) #unrecognized option - show help
      echo -e \\n"Invalid script option"\\n
      usage
      ;;
  esac
done

# Shift the parameters in case there any more to be used
shift $((OPTIND-1))
# echo Remaining arguments: $@

if [ -f ${OCTOOLSBIN}/settings.sh ]; then
  . ${OCTOOLSBIN}/settings.sh
fi

if [ -f ${OCTOOLSBIN}/ocFunctions.inc ]; then
  . ${OCTOOLSBIN}/ocFunctions.inc
fi

if [ ! -z "${DEBUG}" ]; then
  set -x
fi

if [ -z "${SOURCE_TAG}" ] || [ -z "${DESTINATION_TAG}" ]; then
  echo -e \\n"Missing parameters - source or destination tag"\\n
  usage
fi
# ==============================================================================

echo -e \\n"Tagging images for dev environment deployment ..."\\n
for image in ${images}; do
  oc tag ${image}:latest ${image}:dev -n ${TOOLS}
  exitOnError
done
