# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="am ar ar_SY bg ca cs da de el_GR en_GB en_US es et eu fa fi fr gl
he_IL hr hu id it ja ka ko ku lt mk ms_MY nl nn_NO pl pt pt_BR ro_RO ru_RU
sk sl_SI sq_AL sr sv th tr uk_UA uz vi_VN zh_CN zh_TW"
PLOCALE_BACKUP="en_US"

inherit l10n qmake-utils

DESCRIPTION="Great Qt GUI front-end for mplayer/mpv"
HOMEPAGE="http://www.smplayer.eu/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+ BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux"
IUSE="autoshutdown bidi debug mpris qt5 streaming"

COMMON_DEPEND="
	sys-libs/zlib
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtsingleapplication[X,qt4]
		autoshutdown? ( dev-qt/qtdbus:4 )
		mpris? ( dev-qt/qtdbus:4 )
		streaming? (
			dev-qt/qtcore:4[ssl]
			dev-qt/qtscript:4
		)
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtsingleapplication[X,qt5]
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		autoshutdown? ( dev-qt/qtdbus:5 )
		mpris? ( dev-qt/qtdbus:5 )
		streaming? (
			dev-qt/qtnetwork:5[ssl]
			dev-qt/qtscript:5
		)
	)
"
DEPEND="${COMMON_DEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
"
RDEPEND="${COMMON_DEPEND}
	|| (
		media-video/mplayer[bidi?,libass,png,X]
		(
			>=media-video/mpv-0.10.0[libass,X]
			streaming? ( >=net-misc/youtube-dl-2014.11.26 )
		)
	)
"
src_prepare() {
	use bidi || PATCHES+=( "${FILESDIR}"/${PN}-16.4.0-zero-bidi.patch )

	default

	# Upstream Makefile sucks
	sed -i -e "/^PREFIX=/ s:/usr/local:${EPREFIX}/usr:" \
		-e "/^DOC_PATH=/ s:packages/smplayer:${PF}:" \
		-e '/\.\/get_svn_revision\.sh/,+2c\
	cd src && $(DEFS) $(MAKE)' \
		Makefile || die
    }
src_configure() {
	cd src || die
	eqmake5
}

gen_translation() {
	local mydir="$(qt4_get_bindir)"
	if use qt5; then
		mydir="$(qt5_get_bindir)"
	fi

	ebegin "Generating $1 translation"
	"${mydir}"/lrelease ${PN}_${1}.ts
	eend $? || die "failed to generate $1 translation"
}

src_compile() {
	default

	cd src/translations || die
	l10n_for_each_locale_do gen_translation
}

src_install() {
	# remove unneeded copies of the GPL
	rm -f Copying* docs/*/gpl.html || die
	# don't install empty dirs
	rmdir --ignore-fail-on-non-empty docs/* || die

	default
}
