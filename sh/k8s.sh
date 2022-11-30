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

# Special purpose wrappers around kubectl, we can generalize/abuse eval at some
# future date.

# Wrapper around kubectl to get at *all* container id's for:
# - no args = k8s as a whole, e.g. kubectl get pods -A ...
# - namespace = for the whole namespace e.g. kubectl get pods -n foo ...
# - namespace pod = for just that pod e.g. kubectl get pods -n foo podbar ...
k8s_containerids() {
  # Not an issue in this use case
  #shellcheck disable=SC2046
  eval $(sut_k8s_containerids "$@")
}

# Used for unit testing, just outputs what the command *should* be based on the inputs given.
#
# Here to validate that we output the right command to stdout based on inputs for ^^^.
sut_k8s_containerids() {
  unset sut_k8s_containerids_namespace sut_k8s_containerids_pod sut_k8s_containerids_items sut_k8s_containerids_all
  sut_k8s_containerids_namespace=${1-}
  if [ $# -gt 0 ]; then
    shift
    sut_k8s_containerids_pod=${1-}
  fi

  [ -z "${sut_k8s_containerids_pod}" ] && sut_k8s_containerids_items='.items[*]'
  [ -z "${sut_k8s_containerids_namespace}" ] && [ -z "${sut_k8s_containerids_pod}" ] && sut_k8s_containerids_all=

  echo "kubectl get pods ${sut_k8s_containerids_all+--all-namespaces}${sut_k8s_containerids_namespace:+--namespace ${sut_k8s_containerids_namespace}${sut_k8s_containerids_pod:+ }${sut_k8s_containerids_pod-}} --output jsonpath=\"{${sut_k8s_containerids_items-}.status['initContainerStatuses', 'containerStatuses'][*]['containerID', 'state.terminated.containerID']}\""
}
