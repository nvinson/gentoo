# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_TASK_TEST="none"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="oauth2.gemspec"

inherit ruby-fakegem

DESCRIPTION="Wrapper for the OAuth 2.0 protocol with a similar style to the OAuth gem"
HOMEPAGE="https://gitlab.com/oauth-xx/oauth2"
SRC_URI="https://gitlab.com/oauth-xx/oauth2/-/archive/v${PV}/oauth2-${PV}.tar.bz2"
RUBY_S="oauth2-v${PV}-d41fb6e8feef3b0b0382dedc0ede82f5ca7854cd"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

ruby_add_rdepend "
	|| ( dev-ruby/faraday:2 dev-ruby/faraday:1 )
	dev-ruby/jwt:2
	>=dev-ruby/multi_json-1.3 =dev-ruby/multi_json-1*
	>=dev-ruby/multi_xml-0.5:0
	>=dev-ruby/rack-1.2:* <dev-ruby/rack-4:*"
ruby_add_bdepend "test? (
	>=dev-ruby/addressable-2.3
	>=dev-ruby/rexml-3.2:3
	dev-ruby/rspec:3
	dev-ruby/rspec-pending_for
	dev-ruby/rspec-stubbed_env
)"

all_ruby_prepare() {
	sed \
		-e '/silent/I s:^:#:' \
		-e '/require.*oauth2/arequire "oauth2/version"' \
		-i spec/helper.rb || die

	sed -i -e '/yardstick/,/^end/ s:^:#:' \
		-e '/bundler/I s:^:#:' Rakefile || die

	# Avoid spec that is too fragile in relation to ENV
	sed -i -e '/outputs to $stdout when OAUTH_DEBUG=true/a skip "fragile ENV stubbing"' spec/oauth2/client_spec.rb || die

	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	CI=true ${RUBY} -S rspec-3 --format progress spec || die
}
