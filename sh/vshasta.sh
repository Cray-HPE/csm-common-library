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

#######################################
# Checks if a node is running on Google by checking for /etc/google_system
# Globals:
#   None
# Arguments:
#   None
# Output:
#   None
#   Returns 0 if /etc/google_system exists, 1 if not
#######################################
isgcp() {
  # defaults to /etc/google_system, but can be overridden
  _isgcp_identifier="${1:-/etc/google_system}"

  # if the file exists, it is likely on GCP
  if [ -e "${_isgcp_identifier}" ]; then
    return 0
  else
    return 1
  fi

  # TODO: some nodes boot metal images, so the file does not exit
  # a future enhancement will account for this
}
