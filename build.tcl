#!/usr/bin/tclsh

set arch "x86_64"
set base "tksvg-0.2_git20190818"

set var [list git clone https://github.com/auriocus/tksvg $base]
exec >@stdout 2>@stderr {*}$var

cd $base

set var2 [list git checkout e21f521f6f101c883211100995fc9c100b668501]
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
