#
# MIT License
#
# (C) Copyright 2022 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#

# Default of where trace files get stored at script exit, can be set at runtime
# elsewhere.
TRACEDIR="${TRACEDIR:-${TMPDIR:-/tmp}/csm-common-trace}"

# This is null by default, unless tracing is enabled in which case it will be
# the scripts trace dir. Used by other functions/hooks.
TRACEPREFIX=

# Wrapper around install to create our trace dir if its missing
mktracedir() {
  install -dm755 "${TRACEDIR}"
}

# Scripts opt into tracing features or not
# Side effect of call:
# - will create a dir $TRACEDIR/NAME/$(date +%s) that holds all the tracing output
# - will create a file timeline in ^^^ that contains basic runtime information/data (what all to collect?)
enable_tracing() {
  _enable_tracing_script="${1?}"
  shift > /dev/null 2>&1 || :
  # Overrideable to allow for easier unit testing
  _enable_tracing_subdir=${1:-$(date +%s)}

  mktracedir
  _enable_tracing_prefix="${TRACEDIR}/${_enable_tracing_script}/${_enable_tracing_subdir}"
  _enable_tracing_info="${_enable_tracing_prefix}/timeline"
  install -dm755 "${_enable_tracing_prefix}"

  export TRACEPREFIX="${_enable_tracing_prefix}"

  cat > "${_enable_tracing_info}" << EOF
trace enabled at ${_enable_tracing_subdir} for ${_enable_tracing_script}
cwd: $(pwd)
tty: $(tty)
who: $(who)
start: $(date +%s)
EOF

  trap tracing_cleanup_hook EXIT
}

# Responsible for cleaning up the directory storing stuff and then tarring up
# the dir and outputting that so users can clean it up or give it to us for
# debugging.
tracing_cleanup_hook() {
  # Do not use -z here! Even if you want to, trust me.
  if [ "${SUT}" != "" ]; then
    cat >> "${_enable_tracing_info}" << EOF
done: $(date +%s)
EOF
    _tracing_cleanup_hook_txz="${_enable_tracing_prefix}.txz"
    if cd "${_enable_tracing_prefix}"; then
      tar -cJf "${_tracing_cleanup_hook_txz}" "." > /dev/null 2>&1
      printf "tracefile: %s\n" "${_tracing_cleanup_hook_txz}" >&2
      # Cleanup the uncompressed dir to help kesp space usage down
      rm -fr "${_enable_tracing_prefix}"
    else
      printf "warning: could not change to trace dir %s trace data not saved\n" "${_enable_tracing_prefix}" >&2
    fi
  fi
}
