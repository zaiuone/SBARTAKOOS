<html><head><meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/><title>STORM.SH</title></head><body><p dir="ltr">THIS_DIR=$(cd $(dirname $0); pwd)</p>
<p dir="ltr">cd $THIS_DIR</p>
<p dir="ltr">install() {</p>
<p dir="ltr">wget "https://valtman.name/files/telegram-cli-1222"</p>
<p dir="ltr">mv telegram-cli-1222 tg</p>
<p dir="ltr">sudo chmod +x tg</p>
<p dir="ltr">echo -e "</p>
<p dir="ltr">__ ___________ ___ _____ __ __</p>
<p dir="ltr">/ | |___ ___| / _ \ | ___ } | \/ |</p>
<p dir="ltr">\_ \ | | | | | | | |_) } | |\/| |</p>
<p dir="ltr">_) | | | | |_| | | _&lt; \ | | | |</p>
<p dir="ltr">|__/ |_| \___/ |_| \_\ |_| |_|</p>
<p dir="ltr">BY @Zaiuone1 DEV : ZAIUON "</p>
<p dir="ltr">echo -e "" </p>
<p dir="ltr">echo -e "" </p>
<p dir="ltr">}</p>
<p dir="ltr">if [ "$1" = "install" ]; then</p>
<p dir="ltr">install</p>
<p dir="ltr">else</p>
<p dir="ltr">if [ ! -f ./tg ]; then</p>
<p dir="ltr">echo "" </p>
<p dir="ltr">echo ""</p>
<p dir="ltr">exit 1</p>
<p dir="ltr">fi</p>
<p dir="ltr">./tg -s STORM.lua</p>
<p dir="ltr">fi</p>
</body></html>
