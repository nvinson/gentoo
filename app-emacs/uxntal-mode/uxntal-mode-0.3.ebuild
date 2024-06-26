# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="GNU Emacs major mode for the uxntal assembly language"
HOMEPAGE="https://github.com/non/uxntal-mode/"
SRC_URI="https://github.com/non/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
