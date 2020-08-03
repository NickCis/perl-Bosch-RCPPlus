%define __perl_requires %{nil}

%define perl_vendorlib %(eval "`%{__perl} -V:installvendorlib`"; echo $installvendorlib)
%define perl_vendorarch %(eval "`%{__perl} -V:installvendorarch`"; echo $installvendorarch)

%define real_name Bosch-RCPPlus

Name: perl-%{real_name}
Version: 1.0
Release: tws%{?dist}
Summary: Bosch::RCPPlus Perl 5 implementation of the Bosch RCP+ remote procedure call.
Group: Applications/CPAN
License: GNU/GPL v3
URL: https://github.com/NickCis/perl-Bosch-RCPPlus

Source: https://github.com/NickCis/%{name}/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{_release}-root-%(%{__id_u} -n)

BuildArch: noarch
BuildRequires: perl
BuildRequires: perl(ExtUtils::MakeMaker)

Requires: perl
Requires: perl(URI)
Requires: perl(XML::LibXML)
Requires: perl(HTTP::Request)
Requires: perl(LWP::UserAgent)

%description

Perl 5 implementation of the Bosch RCP+ remote procedure call.

%prep
echo prep
%setup -n %{name}-%{version}
echo setup

%build
echo build
%{__perl} Makefile.PL INSTALLDIRS="vendor" PREFIX="%{buildroot}%{_prefix}"
%{__make} %{?_smp_mflags}

%install
%{__rm} -rf %{buildroot}
%{__make} pure_install

### Clean up buildroot
find %{buildroot} -name .packlist -exec %{__rm} {} \;

%files
%defattr(-, root, root, 0755)
%doc %{_mandir}/man3/Bosch::RCPPlus*
%dir %{perl_vendorlib}/Bosch/
%dir %{perl_vendorlib}/Bosch/RCPPlus/
%{perl_vendorlib}/Bosch/RCPPlus.pm
%{perl_vendorlib}/Bosch/RCPPlus/Commands.pm
%{perl_vendorlib}/Bosch/RCPPlus/Response.pm
%{perl_vendorlib}/Bosch/RCPPlus/AuthError.pm

