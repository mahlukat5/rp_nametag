ayarlar = {}
ayarlar.drawDistance = 20 -- nametag ve ikonların gözükmesi için gereken en az uzaklık
ayarlar.items = "wrp_items" -- item sisteminizin script ismini girin. (badge ve maske güncellemesini çekmek için)
--> Nametag ayarları
ayarlar.fontscale = 10 -- font boyutu
ayarlar.font = dxCreateFont ( "fonts/Roboto.ttf" , ayarlar.fontscale)
ayarlar.textscale = 1 -- nametag yazı boyutu
ayarlar.ypos = 0.40 -- nametag oyuncu kafasından ne kadar yukarda olcak? (ne kadar arttırsanız, o kadar yukarı çıkar)
ayarlar.golge = tocolor(0, 0, 0, 255) -- nametag yazı gölge rengi
--> Can ve Zırh barları
ayarlar.canbar = false -- "yazi","bar",false
ayarlar.zirhbar = false -- "yazi","bar",false
ayarlar.canyazirenk = tocolor(255, 255,255, 255) -- can yazısının rengi (yeşil standart)
ayarlar.zirhyazirenk = tocolor(61, 55, 54, 255) -- zırh yazısının rengi (gri standart)
--> İkon ayarları
ayarlar.icons = { 
	maxIconsPerLine = 6, -- bir sırada max kaç adet ikon gözükcek?
	konum="samp/", -- ikon konumları
	genislik=24, -- ikon genişliği
	uzunluk=24,  -- ikon uzunluğu
	ypos = 20, -- ikonların nametag ile uzaklığı (ne kadar arttırırsanız, o kadar uzaklaşır)
	extraicons = {
		--{"data ismi","icon",koşul}
		--icon yerine %s eklerseniz, datası ile tamamlanır. ÖRNEK: oyuncunu vip3 var ise, iconu otomatikmen vip3 olarak eklenicektir.
		{"vip","vip%s","%s ~= 0"}, -- eğer oyuncunun vip datası varsa ve  0'dan başka ise
		{"etiket","isimetiketleri%s","%s ~= 0"}, -- eğer oyuncunun etiket datası varsa ve 0'dan başka ise
		{"hud:minimized","minimized",true},  -- eğer oyuncunun hud:minimized datası true ise
		{"hoursplayed","newplayer","%s < 5"}, -- -- eğer oyuncunun hoursplayed datası 5'den küçükse
		{"smoking","cigarette",true}, -- eğer smoking datası true ise
	},
}
--> Bayrak sistemi ayarları
ayarlar.bayrak = false -- bayrak sistemi açık mı kapalımı? açık ise true kapalı ise false yazın
ayarlar.bayrakdataname = "ulke" -- bayrak data ismi
ayarlar.bayrakboyut = {30,15} -- bayrak png boyutları 30x15
ayarlar.bayrakkonum= ":wrp_nametag/bayrak/%s.png" -- bayrak pngleri nerden çekilcek?
--> Bandana item idleri
ayarlar.bandanalar = { 
	[122]=true,
	[123]=true,
	[124]=true,
	[125]=true,
	[135]=true,
	[136]=true,
	[158]=true,
	[168]=true,
}
ayarlar.updateDatas = { 
	-- bu datalardan biri değişince, iconlar güncellenicek (extraicons içine girdiğiniz dataları buraya eklemenize gerek yok.)
	"hiddenadmin","duty_admin","admin_level","supporter_level","duty_supporter",
	"donation:nametag","donation:lifeTimeNameTag","cellphoneGUIStateSynced","player.Cuffed",ayarlar.bayrakdataname,
	"seatbelt","fakename","vehicle:windowstat","playerid"
}