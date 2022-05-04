%{!?directory:%define directory /usr}

%define buildroot %{_tmppath}/%{name}

Name:          tksvg
Summary:       Read the SVG image format from Tk
Version:       0.10
Release:       0
License:       BSD-3-Clause
Group:         Development/Libraries/Tcl
Source:        %name-%version.tar.gz
URL:           https://github.com/oehhar/tksvg
BuildRequires: autoconf
BuildRequires: make
BuildRequires: tcl-devel >= 8.5
BuildRequires: tk-devel >= 8.5
Requires:      tcl >= 8.5
Requires:      tk >= 8.5
BuildRoot:     %{buildroot}

%description
This package adds support to read the SVG image format from Tk.
The actual code to parse and raster the SVG comes from nanosvg.

%prep
%setup -q -n %{name}-%{version}

sed -i 's/\@INSTALL_PROGRAM\@ \$(INSTALL_FLAGS)/\@INSTALL_PROGRAM\@/g' Makefile.in

%build
%{__autoconf}
./configure \
	--prefix=%{directory} \
	--exec-prefix=%{directory} \
	--libdir=%{directory}/%{_lib} \
%ifarch x86_64
	--enable-64bit=yes \
%endif
	--with-tcl=%{directory}/%{_lib}
make 

%install
make DESTDIR=%{buildroot} pkglibdir=%{tcl_archdir}/%{name}%{version} install

%clean
rm -rf %buildroot

%files
%defattr(-,root,root)
%{tcl_archdir}

