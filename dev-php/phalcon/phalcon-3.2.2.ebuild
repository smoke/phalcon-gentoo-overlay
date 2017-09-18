# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PHP_EXT_NAME="phalcon"
PHP_EXT_INI="yes"
USE_PHP="php7-1 php7-0 php5-6 php5-5"

S="${WORKDIR}/cphalcon-${PV}"
PHP_EXT_S="${S}/ext"
PHP_EXT_ECONF_ARGS="--enable-phalcon"
DOCS=( README.md )

# Phalcon provides pre-prepared extension sources with their released versions,
# so take advantage of those in the ebuild
MY_PHALCON_IS_RELEASED_VERSION=true
if [[ ${PV} == *9999 ]]; then
	MY_PHALCON_IS_RELEASED_VERSION=false
fi

inherit flag-o-matic php-ext-source-r3

if [[ "${MY_PHALCON_IS_RELEASED_VERSION}" == false ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/phalcon/cphalcon.git"
	EGIT_BRANCH="${PV/9999/x}"
	if [[ ${EGIT_BRANCH} != 9999 ]]; then
		EGIT_BRANCH="${PV/9999/x}"
	else
		EGIT_BRANCH="master"
	fi
	EGIT_CHECKOUT_DIR="${S}"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/phalcon/cphalcon/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi

DESCRIPTION="A full-stack PHP framework delivered as a C-extension"
HOMEPAGE="https://phalconphp.com/"
# "New BSD License" according to https://phalconphp.com/
LICENSE="BSD"
SLOT="0"
IUSE="+json pdo mysqli postgres sqlite"

# Phalcon uses PDO for each of its adapters
REQUIRED_USE="
	mysqli? ( pdo )
	postgres? ( pdo )
	sqlite? ( pdo )"

for target in ${USE_PHP}; do
	slot=${target/php}
	slot=${slot/-/.}
	PHPUSEDEPEND="${PHPUSEDEPEND}
	php_targets_${target}? (
		dev-lang/php:${slot}[pcre(+)]
		dev-lang/php:${slot}[json=]
		dev-lang/php:${slot}[pdo?]
		dev-lang/php:${slot}[mysqli?]
		dev-lang/php:${slot}[postgres?]
		dev-lang/php:${slot}[sqlite?]
	)"
done

DEPEND="${PHPUSEDEPEND}"
RDEPEND="${DEPEND}"

if [[ "${MY_PHALCON_IS_RELEASED_VERSION}" == false ]]; then
	# TODO: Implement and depend on dev-php/zephir
	DEPEND="${DEPEND}
		dev-util/re2c"
fi

# Phalcon provides its own specialized version for major PHP slot and ARCH
# so php-ext-source-r3_src_unpack will not work out of the box
# and we need this specialized version
phalcon-ext-source_src_unpack() {
	default

	local slot orig_s php_major_slot arch_specialized
	case "$ARCH" in
		amd64)
			arch_specialized="64bits"
			;;
		x86)
			arch_specialized="32bits"
			;;
		*)
			arch_specialized="safe"
	esac
	for slot in $(php_get_slots); do
		# php7.0 -> php7
		php_major_slot="${slot:0:4}"
		orig_s="${S}/build/${php_major_slot}/${arch_specialized}"
		einfo "Using Phalcon specialized ext sources from ${orig_s} ..."
		cp --recursive --preserve "${orig_s}" "${WORKDIR}/${slot}" || \
			die "failed to copy sources from ${orig_s} to ${WORKDIR}/${slot}"
		# copy over if possible Phalcon provided README.md into php slot dirs
		cp --preserve "${S}/README.md" "${WORKDIR}/${slot}/" || true
	done
}

phalcon-ext-source_src_build_internal() {
	# Use Zephir to prepare build/php{5,7}/{32bits,64bits,safe} extension sources
	# TODO: Implement me
	ewarn "TODO: phalcon-ext-source_src_build_internal needs implementation and this build might not be up to date"
}

src_unpack() {
	if [[ "${MY_PHALCON_IS_RELEASED_VERSION}" == false ]]; then
		git-r3_src_unpack
		phalcon-ext-source_src_build_internal
	fi
	# php-ext-source-r3_src_unpack
	phalcon-ext-source_src_unpack
}

src_configure() {
	append-cppflags -DPHALCON_RELEASE
	# NOTE: No idea if the flags below are required or even good idea,
	# but still trying to compile as close as phalcon/build/install script
	# also note that he rest of the flags are skipped as the -Ox or the user should have taken care of those
	append-flags -fvisibility=hidden
	php-ext-source-r3_src_configure
}

src_install() {
	php-ext-source-r3_src_install
	php-ext-source-r3_addtoinifiles ";phalcon.db.escape_identifiers" '"1"'
	php-ext-source-r3_addtoinifiles ";phalcon.db.force_casting" '"0"'
	php-ext-source-r3_addtoinifiles ";phalcon.orm.cast_on_hydrate" '"0"'
	php-ext-source-r3_addtoinifiles ";phalcon.orm.column_renaming" '"1"'
	php-ext-source-r3_addtoinifiles ";phalcon.orm.enable_implicit_joins" '"1"'
	php-ext-source-r3_addtoinifiles ";phalcon.orm.enable_literals" '"1"'
	php-ext-source-r3_addtoinifiles ";phalcon.orm.events" '"1"'
	php-ext-source-r3_addtoinifiles ";phalcon.orm.exception_on_failed_save" '"0"'
	php-ext-source-r3_addtoinifiles ";phalcon.orm.ignore_unknown_columns" '"0"'
	php-ext-source-r3_addtoinifiles ";phalcon.orm.late_state_binding" '"0"'
	php-ext-source-r3_addtoinifiles ";phalcon.orm.not_null_validations" '"1"'
	php-ext-source-r3_addtoinifiles ";phalcon.orm.virtual_foreign_keys" '"1"'
}
