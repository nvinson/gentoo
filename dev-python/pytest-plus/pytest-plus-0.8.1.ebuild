# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="PyTest Plus Plugin - extends pytest functionality"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-plus/
	https://pypi.org/project/pytest-plus/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv"

RDEPEND="
	>=dev-python/pytest-7.4.2[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-7.0.5[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
