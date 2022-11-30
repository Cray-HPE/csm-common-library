#!/usr/bin/env sh
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
_base=$(basename "$0")
_dir=$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P || exit 126)
export _base _dir

Describe 'k8s.sh'
  Include sh/k8s.sh

  Context 'sut_k8s_containerids constructs kubectl commandlines correctly'
    It 'uses -A and .items[*] in output when given no args'
      When call sut_k8s_containerids
      The output should equal "kubectl get pods --all-namespaces --output jsonpath=\"{.items[*].status['initContainerStatuses', 'containerStatuses'][*]['containerID', 'state.terminated.containerID']}\""
    End
    It 'uses --namespace and .items[*] in output when given one arg for namespace'
      When call sut_k8s_containerids namespace
      The output should equal "kubectl get pods --namespace namespace --output jsonpath=\"{.items[*].status['initContainerStatuses', 'containerStatuses'][*]['containerID', 'state.terminated.containerID']}\""
    End
    It 'uses --namespace and has no leading .items[*] in output when given both args for namespace and name'
      When call sut_k8s_containerids namespace podname
      The output should equal "kubectl get pods --namespace namespace podname --output jsonpath=\"{.status['initContainerStatuses', 'containerStatuses'][*]['containerID', 'state.terminated.containerID']}\""
    End
  End
End
