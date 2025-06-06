# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd tmpfiles
GIT_COMMIT=5bca08ec1

DESCRIPTION="Highly-available key value store for shared configuration and service discovery"
HOMEPAGE="https://github.com/etcd-io/etcd"
SRC_URI="https://github.com/etcd-io/etcd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
LICENSE+=" BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 ~loong ~riscv"
IUSE="doc +server"

COMMON_DEPEND="server? (
	acct-group/etcd
	acct-user/etcd
	)"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

# Unit tests attempt to download go modules.
RESTRICT="test"

src_prepare() {
	export FORCE_HOST_GO=1 GO_BUILD_FLAGS="-v -x"
	default
	sed -e "s|GIT_SHA=.*|GIT_SHA=${GIT_COMMIT}|" \
		-i "${S}"/build.sh || die
	sed -e 's:\(for p in \)shellcheck :\1 :' \
		-e 's:^      goword \\$:\\:' \
		-e 's:^      gofmt \\$:\\:' \
		-e 's:^      govet \\$:\\:' \
		-e 's:^      revive \\$:\\:' \
		-e 's:^      mod_tidy \\$:\\:' \
		-e "s|GO_BUILD_FLAGS=\"[^\"]*\"|GO_BUILD_FLAGS=\"${GO_BUILD_FLAGS}\"|" \
		-e "s|go test |go test ${GO_BUILD_FLAGS} |" \
		-e 's|PASSES=${PASSES:-"fmt bom dep build unit"}|PASSES=${PASSES:-"fmt dep unit"}|' \
		-i ./test.sh || die
}

src_compile() {
	./build.sh || die
}

src_test() {
	./test || die
}

src_install() {
	dobin bin/etcdctl
	use doc && dodoc -r Documentation
	if use server; then
		insinto /etc/${PN}
		sed -e 's|^data-dir:|\0 /var/lib/etcd|' -i etcd.conf.yml.sample || die
		newins etcd.conf.yml.sample etcd.conf.yml
		dobin bin/etcd
		dodoc README.md
		systemd_newunit "${FILESDIR}/${PN}.service-r1" "${PN}.service"
		newtmpfiles "${FILESDIR}/${PN}.tmpfiles.d.conf" ${PN}.conf
		newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
		newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
		insinto /etc/logrotate.d
		newins "${FILESDIR}/${PN}.logrotated" "${PN}"
		keepdir /var/lib/${PN} /var/log/${PN}
		fowners ${PN}:${PN} /var/lib/${PN} /var/log/${PN}
		fperms 0700 /var/lib/${PN}
		fperms 0755 /var/log/${PN}
	fi
}

pkg_postinst() {
	if use server; then
		tmpfiles_process ${PN}.conf
	fi
}
