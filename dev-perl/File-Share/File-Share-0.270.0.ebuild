# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=INGY
DIST_VERSION=0.27
inherit perl-module

DESCRIPTION="Extend File::ShareDir to local libraries"

SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86"

RDEPEND="
	>=dev-perl/File-ShareDir-1.30.0
	>=dev-perl/Readonly-2.50.0
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	perl_rm_files t/release-pod-syntax.t
	perl-module_src_test
}
