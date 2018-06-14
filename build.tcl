#!/usr/bin/tclsh

set arch "x86_64"
set base "tksvg-0.1_git20180216"

set var [list git clone https://github.com/auriocus/tksvg $base]
exec >@stdout 2>@stderr {*}$var

cd $base

set var2 [list git checkout 0ffe43230bf4332fd6f65543e872a998aa1c54f2]
exec >@stdout 2>@stderr {*}$var2

set var2 [list git reset --hard]
exec >@stdout 2>@stderr {*}$var2

file delete -force .git

cd ..

set var2 [list tar czvf ${base}.tar.gz $base]
exec >@stdout 2>@stderr {*}$var2

if {[file exists build]} {
    file delete -force build
}

file mkdir build/BUILD build/RPMS build/SOURCES build/SPECS build/SRPMS
file copy -force $base.tar.gz build/SOURCES

set buildit [list rpmbuild --target $arch --define "_topdir [pwd]/build" -bb tksvg.spec]
exec >@stdout 2>@stderr {*}$buildit

# Remove our source code
file delete -force $base
file delete -force $base.tar.gz
