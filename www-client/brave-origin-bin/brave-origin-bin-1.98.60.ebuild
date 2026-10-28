# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# use EAPI 8 instead of 9 cuz inherited eclasses dont support 9 yet
EAPI=8

inherit chromium-2 desktop xdg

DESCRIPTION="Brave Origin web browser"
HOMEPAGE="https://brave.com/"
SRC_URI="https://github.com/brave/brave-browser/releases/download/v${PV}/brave-origin-${PV}-linux-amd64.zip"

# change this from default ${WORKDIR}/${P} to just ${WORKDIR} cuz brave-origin*.zip unzips directly into directory without creating a new folder.
# do this so i dont have to change how src_unpack works.
S="${WORKDIR}"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="strip"

pkg_setup() {
	# Ensures the system kernel supports features needed for SUID and User namespaces sandbox to work.
	# got this from helium-bin
	chromium_suid_sandbox_check_kernel_config
}

src_install() {
	# create top level dir to contain all extracted files
	dodir /opt/brave-origin

	# move all extracted files and dirs into top level dir
	mv "${S}"/* "${ED}/opt/brave-origin" || die

	# remove qt5 shim cuz i only have qt6
	rm "${ED}/opt/brave-origin/libqt5_shim.so" || die

	# symlink to /usr/bin
	dosym -r /opt/brave-origin/brave-origin /usr/bin/brave-origin

	# add desktop file and icon
	newicon -s 256 "${ED}/opt/brave-origin/product_logo_256.png" brave-origin.png
	domenu "${FILESDIR}/brave-origin.desktop"
}
