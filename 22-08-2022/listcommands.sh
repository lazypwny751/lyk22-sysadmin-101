#!/bin/bash

# Bash (Bourne Again SHell):
#   "Bir bilgisayar açıldığında, bir çekirdek (Linux, BSD, Mach veya NT olsun) tüm fiziksel donanımı tanır ve her bileşenin
#   birbiriyle konuşmasını ve bazı temel yazılımlar tarafından düzenlenmesini sağlar. Bir bilgisayarın en temel talimat dizisi,
#   bilgisayarı açık ve güvenli bir durumda tutar: aşırı ısınmayı önlemek için fanları düzenli aralıklarla etkinleştirmek,
#   disk alanını izlemek için alt sistemleri kullanmak veya yeni takılan aygıtları "dinlemek" vb. Tüm bilgisayarların yaptığı bu olsaydı,
#   konveksiyonlu bir fırın kadar ilginç olacaklardı.
#
#   Bilgisayar bilimcileri bunu çok erken fark ettiler, bu yüzden Unix bilgisayarları için çekirdeğin dışında
#   (veya doğadaki bir kabuk gibi çekirdeğin etrafında) çalışan ve insanların istedikleri zaman bilgisayarla etkileşime girmesine
#   izin veren bir kabuk geliştirdiler."
#
#   yani kısacası bash, işletim sistemi ile etkileşime geçmemizi sağlayan bir programdır, bash'e terminal emülatörleri ile kolayca
#   erişmek mümkündür, ayrıca bash bir kabuk programlama dilidir bash ile sistem otomasyonları, servisler vb.. yazılabilir.

# Internal Field Separator (Dahili Alan Ayırıcı):
#   bu demek oluyor ki 'bash' ona gönderdiğimiz kelimeleri birbirinden ayırt etmek için
#   belirli bir ayraç kullanır, işte bu ayraca dahili alan ayırıcı denilir ve bu ayracı
#   'IFS' adlı özel değişken belirler. İstersek bu ayracı değiştirebiliriz.

export IFS=":"

# For Loop (For Döngüsü):
#   bash aynı diğer betikleme dilleri gibi döngülere, değişkenlere, özel değişkenlere, ifadelere,
#   özel ifadelere vb.. sahiptir mesela IFS bir özel değişkendir. For loop'ta aynı diğer dillerde
#   olduğu gibi bir döngüdür.

for dizin in ${PATH} ; do
    # 'PATH (yol)' path özel bir değişkendir aynı IFS gibi, PATH'i anlamak için komut nedir bunu bilmemiz gerekir
    # komutlar aslında dosya sisteminin bir köşesinde çağırılmayı bekleyen programlardır, bu programları biz shell
    # ile çağırabiliriz lakin bu komutlar dosya sisteminin herhangi bir köşesinde olduğundan komutları çağırmak için
    # onların tam adresini belirtmemiz gerekir ve bu da epey yorucu bir hal alır, mesela 'ls' komutu, bu komutun tam yolunu
    # öğrenmek için shell'e 'which ls' yazıyoruz, ls komutumuzun tam yolu '/usr/bin/ls' imiş yani shell'e bu yolu girerekte
    # ls'i çağırmam mümkün lakin her komut için bunu yapmamız çok zahmetli olacağından PATH sistemi geliştirilmiş
    # bu değişken içerisinde yolunu girmeden sadece dosyanın adı ile çağırmamızı sağlayan dizinleri listeler ve dizinler
    # ':' ile ayrıştırılır, başta IFS'e ':' atamamızın sebebi de buydu bu sayede PATH değişkeninde ':' ile ayrıştırılan
    # dizinleri for loop için işlenebilir hale getirdik ve ls komutu ile bu dizinleri teker teker listeledik.

    ls "${dizin}" 2> /dev/null

    # ls (list directories and files):
    #   ls komutu core-utils paketi ile birlikte gelen her dağıtımda bulunan temel bir komuttur bu komutu
    #   bir dizinin içerisindeki dosya ve dizinleri listelemek için kullanılır.
done

# Builtin commands (yerleşik komutlar):
#   Yerleşik komutlar ise shell ile birlikte gelen komutlardır, bildiğimiz üzre shell'de bir programdır ve biz buna emülatörler
#   vasıtası ile erişebiliriz burada kabukta gelmesi kereken standart komutlar ve opsiyonel komutlar vardır bu komutlar dosya sisteminde
#   direkt olarak barınmaz shell'in içinde fonksiyon olarak barınırlar bu komutlara Built in (yerleşik) komutlar denilir.
#
#   Bash'te yerleşik komutları listelemek:
#       compgen -b

# kaynakça:
#   - https://bash.cyberciti.biz/guide/$IFS
#   - https://opensource.com/resources/what-bash
#   - https://www.cyberciti.biz/faq/bash-for-loop
#   - https://man7.org/linux/man-pages/man1/ls.1.html

# IFS=":" ; ls ${PATH} 2> /dev/null # one line