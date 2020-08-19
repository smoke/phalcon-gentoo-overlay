# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PHP_EXT_NAME="psr"
USE_PHP="php7-3 php7-4"

inherit php-ext-source-r3

SRC_URI="https://github.com/jbboehr/php-psr/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 ~arm ~arm64 x86"

DESCRIPTION="Interfaces from the PSR standards as established by the PHP-FIG group"
HOMEPAGE="https://github.com/jbboehr/php-psr"
LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

