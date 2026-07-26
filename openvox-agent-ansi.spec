%define gem_name ansi
%define gem_cache_dir /opt/puppetlabs/puppet/share/gems

Summary:   A collection of ANSI escape code
Name:      openvox-agent-%{gem_name}
Version:   1.6.0
Release:   1%{?dist}
Group:     Development/Languages
License:   BSD-2
URL:       https://github.com/rubyworks/ansi
Source0:   https://rubygems.org/gems/%{gem_name}-%{version}.gem
Requires:  openvox-agent >= 8
Requires:  openvox-agent < 9
Requires:  /opt/puppetlabs/puppet/bin/gem
BuildArch: noarch
Obsoletes: puppet-agent-ansi

%description
The ANSI project is a collection of ANSI escape code related libraries
enabling ANSI code based colorization and stylization of output. It is
very nice for beautifying shell output.

%prep
%setup -q -c -T
cp -a %{SOURCE0} ./

%build

%install
mkdir -p %{buildroot}%{gem_cache_dir}
cp -a ./%{gem_name}-%{version}.gem %{buildroot}%{gem_cache_dir}

%files
%{gem_cache_dir}/%{gem_name}-%{version}.gem

%post
/opt/puppetlabs/puppet/bin/gem install --local %{gem_cache_dir}/%{gem_name}-%{version}.gem >/dev/null

%preun
if [ $1 == 0 ]; then  # uninstall
  /opt/puppetlabs/puppet/bin/gem uninstall -x -v %{version} %{gem_name} >/dev/null
else  # upgrade
  # Only uninstall on upgrade if there are multiple gem versions installed, as the package
  # is probably changing version, not only undergoing a release bump
  if ! /opt/puppetlabs/puppet/bin/gem list %{gem_name} | grep %{gem_name} | grep -q '(%{version})'; then
    /opt/puppetlabs/puppet/bin/gem uninstall -x -v %{version} %{gem_name} >/dev/null
  fi
fi

%changelog
* Sun Jul 26 2026 Lennart Betz <lbetz@prefork.de> - 1.6.0-1
- Update to v1.6.0, rename package, remove requirement of puppet-agent, remove OpenVox 7 support
* Fri May 09 2025 Thomas Widhalm <thomas.widhalm@netways.de> - 1.5.0-2
- Add OpenVox as alternative to Puppet Agent
* Fri Aug 30 2024 Lennart Betz <lennart.betz@netways.de> - 1.5.0-1
- Release 1.5.0
