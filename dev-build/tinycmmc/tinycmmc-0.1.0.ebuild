# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Grumbel/${PN}.git"
else
	SRC_URI="https://github.com/Grumbel/${PN}/archive/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~riscv"
fi

DESCRIPTION="Tiny CMake Module Collections"
HOMEPAGE="https://github.com/Grumbel/tinycmmc"

LICENSE="GPL-3+"
SLOT="0"

PATCHES=( "${FILESDIR}"/${PN}-0.1.0-cmake4.patch )
