# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils git-r3

DESCRIPTION="Sony LDAC, aptX, aptX HD, AAC codecs (A2DP Audio) support to PulseAudio on Linux"
HOMEPAGE="https://github.com/EHfive/pulseaudio-modules-bt"
EGIT_REPO_URI="https://github.com/EHfive/${PN}"

# libpulse-simple and libpulse link to libpulse-core; this is daemon's
# library and can link to gdbm and other GPL-only libraries. In this
# cases, we have a fully GPL-2 package. Leaving the rest of the
# GPL-forcing USE flags for those who use them.
LICENSE="GPL-2"

SLOT="0"
KEYWORDS=""

IUSE="+pulseaudio +ffmpeg"

REQUIRED_USE="pulseaudio ffmpeg"

DEPEND="media-sound/pulseaudio
                  app-portage/portage-utils"

RDEPEND="media-sound/pulseaudio[bluetooth]
                    media-video/ffmpeg"


src_unpack() {
    EGIT_OVERRIDE_COMMIT_PULSEAUDIO_PULSEAUDIO="v"$("qatom -F '%{PV}' `best_version media-sound/pulseaudio`")
    local pulseaudio_version=
    # extracts only version number this way in case I will get sources from git
    # local PPPD_VERSION="$(echo $(best_version net-dialup/ppp) | sed -e 's:net-dialup/ppp-\(.*\):\1:' -e 's:-r.*$::')"
    git-r3_fetch
}


src_prepare() {
    cmake-utils_src_prepare
}

src_configure() {
    local mycmakeargs=(
            -DFORCE_LARGEST_PA_VERSION=ON
    )
    cmake-utils_src_configure
}


pkg_postinst() {
		elog "To avoid package collisions make sure to add ignore to your config"
}
