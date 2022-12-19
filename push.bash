cat <<EOF > PKGBUILD
# Maintainer: NSK-1010 <kotone[dot]olin1010[at]gmail[dot]com>
pkgname=floorp
pkgver=$(curl https://api.github.com/repos/Floorp-Projects/Floorp/releases | jq '.[0].tag_name' | sed s/\"v//g | sed s/\"//g)
pkgrel=$(if [ $(curl "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=floorp" | grep 'pkgver=' | sed s/pkgver=//) = $(curl https://api.github.com/repos/Floorp-Projects/Floorp/releases | jq '.[0].tag_name' | sed s/\"v//g | sed s/\"//g) ];then echo $(($(curl "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=floorp" | grep 'pkgrel=' | sed s/pkgrel=//) + 1));else echo 1;fi)
pkgdesc="Firefox-based browser with excellent privacy protection, developed by a community of students in Japan"
url="http://floorp.ablaze.one"
arch=('x86_64' 'aarch64')
license=('MPL2')
depends=('gtk3' 'libxt' 'mime-types' 'dbus-glib' 'nss' 'ttf-font')
optdepends=('ffmpeg: H264/AAC/MP3 decoding'
            'networkmanager: Location detection via available WiFi networks'
            'libnotify: Notification integration'
            'pulseaudio: Audio support'
            'speech-dispatcher: Text-to-Speech'
            'hunspell-en_US: Spell checking, American English')
makedepends=('imagemagick')
conflicts=()
replaces=()
backup=()
source=("https://github.com/Floorp-Projects/About-Floorp-Projects/raw/main/Creater-pack/Creater_pack_Floorp.zip"
            "floorp.desktop"
            $(curl https://api.github.com/repos/Floorp-Projects/Floorp/releases | jq '.[0].assets[] | select(.browser_download_url | contains("linux"))' | jq '.browser_download_url' | head -n 1 | sed s/$(curl https://api.github.com/repos/Floorp-Projects/Floorp/releases | jq '.[0].tag_name' | sed s/\"v//g | sed s/\"//g)/\${pkgver}/g | sed s/x86_64/\${arch}/g | sed s/aarch64/\$arch/g))
md5sums=('c12cf6c807ad562188e648c60b2b7289'
            'cecce3f030f194da95819cfaffe020e3')

if test "\$CARCH" == x86_64; then
    md5sums+=('$(curl -L -C - -F $(curl https://api.github.com/repos/Floorp-Projects/Floorp/releases | jq '.[0].assets[] | select(.browser_download_url | contains("linux"))' | jq '.browser_download_url' | head -n 1 | sed s/aarch64/x86_64/g) | md5sum -b - | sed "s/ \*\-//g")')
elif test "\$CARCH" == aarch64; then
    md5sums+=('$(curl -L -C - -F $(curl https://api.github.com/repos/Floorp-Projects/Floorp/releases | jq '.[0].assets[] | select(.browser_download_url | contains("linux"))' | jq '.browser_download_url' | head -n 1 | sed s/x86_64/aarch64/g) | md5sum -b - | sed "s/ \*\-//g")')
fi

package() {
  cd "\${srcdir}/\${pkgname}"
  install -Ddvm755 "\${pkgdir}/usr/lib/\${pkgname}"
  cp -rfv ./* "\${pkgdir}/usr/lib/\${pkgname}/"
  cd "\${srcdir}"
  mkdir -p "\${pkgdir}/usr/share/icons/hicolor/128x128/apps"
  convert -resize 128x128 "Creater_pack_Floorp/Floorp_imgs/Floorp_Legacy/png/icons.png" "\${pkgdir}/usr/share/icons/hicolor/128x128/apps/\${pkgname}.png"
  chmod 644 "\${pkgdir}/usr/share/icons/hicolor/128x128/apps/\${pkgname}.png"
  mkdir -p "\${pkgdir}/usr/share/icons/hicolor/256x256/apps"
  convert -resize 256x256 "Creater_pack_Floorp/Floorp_imgs/Floorp_Legacy/png/icons.png" "\${pkgdir}/usr/share/icons/hicolor/256x256/apps/\${pkgname}.png"
  chmod 644 "\${pkgdir}/usr/share/icons/hicolor/256x256/apps/\${pkgname}.png"
  mkdir -p "\${pkgdir}/usr/share/icons/hicolor/512x512/apps"
  convert -resize 512x512 "Creater_pack_Floorp/Floorp_imgs/Floorp_Legacy/png/icons.png" "\${pkgdir}/usr/share/icons/hicolor/512x512/apps/\${pkgname}.png"
  chmod 644 "\${pkgdir}/usr/share/icons/hicolor/256x256/apps/\${pkgname}.png"
  install -Dvm644 "Creater_pack_Floorp/Floorp_imgs/Floorp_Legacy/svg/icons.svg" "\${pkgdir}/usr/share/icons/hicolor/scalable/apps/\${pkgname}.svg"
  install -Dvm644 "\${pkgname}.desktop" "\${pkgdir}/usr/share/applications/\${pkgname}.desktop"
  install -Dvm755 /dev/stdin "\${pkgdir}/usr/bin/\${pkgname}" << END
#!/bin/sh
exec /usr/lib/\${pkgname}/\${pkgname} "\\$@"
END
}

EOF
