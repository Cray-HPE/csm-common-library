# MIT License
# 
# (C) Copyright [2022] Hewlett Packard Enterprise Development LP
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

%define doc_dir /usr/share/doc/%(echo $NAME)/
%define doc_example_dir %{doc_dir}examples/
%define doc_shell_dir %{doc_dir}sh/
%define install_dir /usr/lib/%(echo $NAME)/
%define install_shell_dir %{install_dir}sh
Name: %(echo $NAME)
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}
License: MIT
Summary: A library for providing common functions to Cray System Management procedures and operations.
Version: %(echo $VERSION)
Release: 1
Source: %{name}-%{version}.tar.bz2
Vendor: Hewlett Packard Enterprise Development LP

%description

%prep
%setup -n %{name}-%{version}

%build

%install
install -d -m 755 ${RPM_BUILD_ROOT}/%{doc_dir}
install -m 644 ./README.adoc ${RPM_BUILD_ROOT}/%{doc_dir}README.adoc
install -d -m 755 ${RPM_BUILD_ROOT}/%{doc_example_dir}
cp -pvr ./examples/* ${RPM_BUILD_ROOT}%{doc_example_dir} | awk '{print $3}' | sed "s/'//g" | sed "s|$RPM_BUILD_ROOT||g" | tee -a INSTALLED_FILES

install -d -m 755 ${RPM_BUILD_ROOT}/%{doc_shell_dir}
install -m 644 ./sh/README.adoc ${RPM_BUILD_ROOT}/%{doc_shell_dir}README.adoc
install -d -m 755 ${RPM_BUILD_ROOT}/%{install_shell_dir} 
cp -pvr ./sh/*.sh ${RPM_BUILD_ROOT}/%{install_shell_dir} | awk '{print $3}' | sed "s/'//g" | sed "s|$RPM_BUILD_ROOT||g" | tee -a INSTALLED_FILES

cat INSTALLED_FILES | xargs -i sh -c 'test -L {} && exit || test -f $RPM_BUILD_ROOT/{} && echo {} || echo %dir {}' > INSTALLED_FILES_2

%clean

%files -f INSTALLED_FILES_2
%doc_dir %{doc_dir}
%attr(644, root, root) %doc %{doc_dir}README.adoc
%attr(644, root, root) %doc %{doc_example_dir}README.adoc
%attr(644, root, root) %doc %{doc_shell_dir}README.adoc
%defattr(755,root,root)
%dir %{install_dir}
%license LICENSE

%changelog
