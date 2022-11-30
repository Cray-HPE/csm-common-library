#!/usr/bin/env sh
#-*-mode: Shell-script; coding: utf-8;-*-
_base=$(basename "$0")
_dir=$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P || exit 126)
export _base _dir

# Just an example of making this whole hook rigamarole optional if DEBUG is set
# or not.
#shellcheck source=./../sh/lib.sh
. ${SOURCEPREFIX:=$(dirname $(readlink -f ${_dir}/../sh/lib.sh))}/lib.sh

# Constrain this *ONLY* to do debug stuff when its set to trace
if [ -n "${DEBUG}" ] && [ "trace" = "${DEBUG}" ]; then
  # Declare we want to enable tracing and give a name for what we want to
  # consider this script. Can simply pass in ${_base} computed above if you want
  # the scripts name as the group. Note underneath is the $(date +%s ) of when
  # the script was started so multiple runs all end up in that basic dir.
  #
  # Ideally callers just pass in $(basename "$0") here.
  enable_tracing "${_base}"

  # For the log functionality, *ALL* log output/calls get written to a log file
  # in the trace
  #
  # For the wrapcmd command all of the stdin/out/err and wrapped command info get stored in a
  # wrapcmd dir with $(date +s) as the containing dir storing (may expand in future):
  # - TRACEDIR/BREADCRUMB/cmd/$(date +%s)/info
  # - TRACEDIR/BREADCRUMB/cmd/$(date +%s)/{stdin,stdin-is-a-pipe}
  # - TRACEDIR/BREADCRUMB/cmd/$(date +%s)/{stdout,stdout-is-a-pipe}
  # - TRACEDIR/BREADCRUMB/cmd/$(date +%s)/{stderr,stderr-is-a-pipe}

  # Wrapcmd setup
  DEFAULTPOSTHOOK="${DEFAULTPOSTHOOK:-defaultposthook}"
  DEFAULTTRACEHOOK="${DEFAULTTRACEHOOK:-defaulttracehook}"

  # We don't want word splitting here with this var.
  #shellcheck disable=SC2086
  wrapcmd ${WRAP:-jq ls}
fi

jq -r . << EOF
this is not json
EOF

ls /does/not/exist

emerg "red alert!"
warn "This goes to the screen and to the trace file if enabled"
# So start/done in the timeline have a different epoch
sleep 1
info "This only goes to the trace file by default"
debug "Debug also only goes to the trace file by default"
