# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="am ar ar_SY bg ca cs da de el_GR en_GB en_US es et eu fa fi fr gl
he_IL hr hu id it ja ka ko ku lt mk ms_MY nl nn_NO pl pt pt_BR ro_RO ru_RU
sk sl_SI sq_AL sr sv th tr uk_UA uz vi_VN zh_CN zh_TW"
PLOCALE_BACKUP="en_US"

inherit git-r3 eutils

DESCRIPTION="MPRIS plugin for mpv"
HOMEPAGE="https://github.com/hoyon/mpv-mpris"
EGIT_REPO_URI="https://github.com/hoyon/mpv-mpris.git"

LICENSE="GPL-2+ BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
        media-video/mpv[cplugins]
"

src_compile() {
        default
}

src_install() {
        insinto /usr/lib/mpv-mpris
	doins -r mpris.so
}

pkg_postinst() {
		elog "To use with smplayer open"
		elog "Options->Preferences and then Advanced tab."
		elog "Add in the options for mpv:"
		elog "--script /usr/lib/mpv-mpris/mpris.so"
		elog
}

