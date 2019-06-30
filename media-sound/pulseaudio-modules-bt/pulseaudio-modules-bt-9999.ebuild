# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils git-r3

DESCRIPTION="Sony LDAC, aptX, aptX HD, AAC codecs (A2DP Audio) support to PulseAudio on Linux"
HOMEPAGE="https://github.com/EHfive/pulseaudio-modules-bt"
EGIT_REPO_URI="https://github.com/EHfive/${PN}"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS=""

IUSE="+pulseaudio +ffmpeg"

REQUIRED_USE="pulseaudio ffmpeg"

DEPEND="media-sound/pulseaudio
                  app-portage/portage-utils"

RDEPEND="media-sound/pulseaudio[bluetooth]
                    media-video/ffmpeg"

# pulseaudio-modules-bt does not work yet with ninja which is default in cmake-utils
CMAKE_MAKEFILE_GENERATOR="emake"

pkg_setup() {
  # Compile for specific pulseaudio version installed currently on user system.
  # This way minimize possible compatibility issues.
  local pulseaudio_version=$(qatom -F '%{PV}' $(best_version media-sound/pulseaudio))
  EGIT_OVERRIDE_COMMIT_PULSEAUDIO_PULSEAUDIO="v"$pulseaudio_version
}

src_prepare() {  
  cmake-utils_src_prepare
}

src_configure() {
    cmake-utils_src_configure
}

pkg_postinst() {
    elog ""
    ewarn "To avoid package collisions make sure to add COLLISION_IGNORE to /etc/portage/make.conf:"
    ewarn "COLLISION_IGNORE=\"/usr/lib/pulse-*/modules/module-bluez5-discover.so  /usr/lib/pulse-*/modules/libbluez5-util.so /usr/lib/pulse-*/modules/module-bluez5-device.so /usr/lib/pulse-*/modules/module-bluetooth-discover.so /usr/lib/pulse-*/modules/module-bluetooth-policy.so\""
    ewarn "After adding COLLISION_IGNORE make sure to emerge pulseaudio again. And then emerge this package."
    elog ""
    elog "To restart pulseaudio with new modules: run pulseaudio -k"
    elog "Or use corresponding service if pulseaudio runs on system level"
}
