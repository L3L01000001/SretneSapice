# SretneSapice

1. Prije testiranja potrebno je uključiti Developer mode.

2. Odraditi docker-compose build 

3. Odraditi docker-compose up

RABBITMQ: Konfirmacijski email se šalje useru kada dog walker prihvati njegov service request.

Kredencijali outlook maila s kojeg se šalju mailovi:
mail: sretnesapice@outlook.com
pass: sapice123

ENV FAJL ZA PAY PAL SECRET_KEY I CLIENT_ID:

Prije builda UI mobile aplikacije potrebno je napraviti .env fajl u UI/sretnesapice_mobile u kojem se nalaze CLIENT_ID_VALUE i SECRET_KEY_VALUE za PAYPAL GATEWAY. Vrijednosti će biti poslane na sljedeće mailove: amel.music@edu.fit.ba i rs.ii@edu.fit.ba i također dodani u komentar prilikom predavanja rada.

POKRETANJE UI APLIKACIJA

desktop: flutter run -d windows

mobile: flutter run 


Kredencijali za testiranje:

Admin
username: desktop
password: test

User
username: mobile
password: test

DogWalker
username: dogwalker
password: test

Dog Walker Verifier
username: dogwalkerverifier
password: test

Sandbox Paypal kredencijali za plaćanje:
mail: sb-s7kat32112762@personal.example.com
password: sapice123
