-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2023. Ápr 15. 13:19
-- Kiszolgáló verziója: 10.4.6-MariaDB
-- PHP verzió: 7.3.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `foci`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `ertekeles`
--

CREATE TABLE `ertekeles` (
  `felhasznalonev` varchar(50) COLLATE utf8_hungarian_ci NOT NULL,
  `datum` date NOT NULL,
  `uzenet` varchar(200) COLLATE utf8_hungarian_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `felhasznalok`
--

CREATE TABLE `felhasznalok` (
  `id` int(11) NOT NULL,
  `email` varchar(50) COLLATE utf8_hungarian_ci NOT NULL,
  `jelszo` varchar(25) COLLATE utf8_hungarian_ci NOT NULL,
  `nev` varchar(50) COLLATE utf8_hungarian_ci NOT NULL,
  `lakcim` varchar(100) COLLATE utf8_hungarian_ci NOT NULL,
  `telefonszam` varchar(20) COLLATE utf8_hungarian_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `felhasznalok`
--

INSERT INTO `felhasznalok` (`id`, `email`, `jelszo`, `nev`, `lakcim`, `telefonszam`) VALUES
(1, 'odry.attila@keri.mako.hu', '1234Aa', 'Ódry Attila', 'Szeged', '+36301231234'),
(2, 'levente@citromail.hu', '1234Aa', 'Levente', 'Magyarcsanád', '+36309994444'),
(3, 'danika@citromail.hu', '1234Aa', 'Danika', 'Makó', '+36309994444'),
(4, 'kristof@citromail.hu', '1234Aa', 'Kristóf', 'Maroslele', '+36309994444'),
(5, 'ivonn@citromail.hu', '1234Aa', 'Ivonn', 'Kiszombor', '+36301231234'),
(6, 'letti@citrommail.hu', '1234Aa', 'Letti', 'Makó', '+36301231234'),
(7, 'jdfjkfdjkjdfkjkfd@fkldklfdkldf.hu', '1234Aa', 'Félix', 'dsdsdssdsd', ' 3615616512');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `rendeles`
--

CREATE TABLE `rendeles` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `nev` varchar(50) NOT NULL,
  `szallitasicim` varchar(50) NOT NULL,
  `telefonszam` varchar(20) NOT NULL,
  `fizetesimod` char(1) NOT NULL,
  `megjegyzes` varchar(200) DEFAULT NULL,
  `osszeg` int(10) UNSIGNED NOT NULL,
  `datum` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `rendeles`
--

INSERT INTO `rendeles` (`id`, `user_id`, `nev`, `szallitasicim`, `telefonszam`, `fizetesimod`, `megjegyzes`, `osszeg`, `datum`) VALUES
(1, 1, 'Ódry Attila', 'Szeged', ' +36301231234', 'C', NULL, 80998, '2023-04-15 02:09:16'),
(2, 1, 'Ódry Attila', 'Szeged', ' +36301231234', 'C', NULL, 84596, '2023-04-15 08:38:15'),
(3, 1, 'Ódry Attila', 'Szeged', '+ 36301231234', 'C', NULL, 30998, '2023-04-15 08:39:05'),
(4, 1, 'Ódry Attila', 'Szeged', ' +36301231234', 'C', NULL, 48196, '2023-04-15 09:06:46'),
(5, 7, 'Félix', 'dsdsdssdsd', '+ 3615616512', 'U', '', 80998, '2023-04-15 13:05:15'),
(6, 7, 'Félix', 'dsdsdssdsd', '+3615616512', 'U', 'Sürgős!!!', 47180, '2023-04-15 13:14:07'),
(7, 7, 'Félix', 'dsdsdssdsd', ' 3615616512', 'C', 'fdfdfdfd', 47180, '2023-04-15 13:17:39');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `rendelesi_tetel`
--

CREATE TABLE `rendelesi_tetel` (
  `id` int(10) UNSIGNED NOT NULL,
  `rendeles_id` int(11) NOT NULL,
  `termek_id` int(11) NOT NULL,
  `meret` varchar(50) NOT NULL,
  `darab` tinyint(4) NOT NULL,
  `ar` int(11) NOT NULL,
  `osszeg` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `rendelesi_tetel`
--

INSERT INTO `rendelesi_tetel` (`id`, `rendeles_id`, `termek_id`, `meret`, `darab`, `ar`, `osszeg`) VALUES
(1, 1, 1, '43', 1, 39999, 39999),
(2, 1, 8, '40', 1, 40999, 40999),
(3, 2, 8, '40', 1, 40999, 40999),
(4, 2, 7, '39', 1, 39999, 39999),
(5, 2, 30, '140x20 cm', 1, 2299, 2299),
(6, 2, 32, '140x20 cm', 1, 1299, 1299),
(7, 3, 40, '8', 1, 15999, 15999),
(8, 3, 36, '8', 1, 14999, 14999),
(9, 4, 1, '43', 1, 39999, 39999),
(10, 4, 28, '110x20 cm', 1, 2599, 2599),
(11, 4, 28, '110x20 cm', 1, 2599, 2599),
(12, 4, 25, '140x20 cm', 1, 2999, 2999),
(13, 5, 1, '43', 1, 39999, 39999),
(14, 5, 8, '40', 1, 40999, 40999),
(15, 6, 29, '140x20 cm', 3, 4999, 14997),
(16, 6, 25, '140x20 cm', 1, 2999, 2999),
(17, 6, 28, '110x20 cm', 3, 2599, 7797),
(18, 6, 31, '140x20 cm', 1, 2499, 2499),
(19, 6, 26, '120x20 cm', 3, 1999, 5997),
(20, 6, 30, '140x20 cm', 1, 2299, 2299),
(21, 6, 27, '140x20 cm', 1, 1499, 1499),
(22, 6, 32, '140x20 cm', 7, 1299, 9093),
(23, 7, 29, '140x20 cm', 3, 4999, 14997),
(24, 7, 25, '140x20 cm', 1, 2999, 2999),
(25, 7, 28, '110x20 cm', 3, 2599, 7797),
(26, 7, 31, '140x20 cm', 1, 2499, 2499),
(27, 7, 26, '120x20 cm', 3, 1999, 5997),
(28, 7, 30, '140x20 cm', 1, 2299, 2299),
(29, 7, 27, '140x20 cm', 1, 1499, 1499),
(30, 7, 32, '140x20 cm', 7, 1299, 9093);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `termekek`
--

CREATE TABLE `termekek` (
  `termek_id` int(50) NOT NULL,
  `megnevezes` varchar(50) COLLATE utf8_hungarian_ci NOT NULL,
  `tipus` varchar(10) COLLATE utf8_hungarian_ci NOT NULL,
  `tipus_path` varchar(10) COLLATE utf8_hungarian_ci NOT NULL,
  `url_id` varchar(50) COLLATE utf8_hungarian_ci NOT NULL,
  `ar` int(50) NOT NULL,
  `leiras` varchar(100) COLLATE utf8_hungarian_ci NOT NULL,
  `kep` varchar(50) COLLATE utf8_hungarian_ci NOT NULL,
  `meret` varchar(200) COLLATE utf8_hungarian_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `termekek`
--

INSERT INTO `termekek` (`termek_id`, `megnevezes`, `tipus`, `tipus_path`, `url_id`, `ar`, `leiras`, `kep`, `meret`) VALUES
(1, 'Adidas X Speedportal', 'cipők', 'cipok', 'Adidas', 39999, 'Kényelmes, fűző nélküli focicipő.', 'adidas x speedportal-min.png', '39,40,41,42,43,44,45'),
(2, 'Nike Mercurial Dragonfly', 'cipők', 'cipok', 'Mercurial', 35999, 'Magasszárú, olcsóbb kategóriás focicipő.', 'dragonfly.jpg', '39,40,41,42,43,44,45'),
(3, 'NEMEZIZ 17.4 FXG', 'cipők', 'cipok', 'Nemeziz', 30999, 'Középkategóriás, kényelmes focicipő.', 'nemeziz.png', '44,45,46'),
(4, 'NEW BALANCE', 'cipők', 'cipok', 'New Balance', 30999, 'Modernszerű focicipő, kényelmes.', 'newbalance.png', '37,38,39,40'),
(5, 'NIKE MAGISTA', 'cipők', 'cipok', 'Magista', 26999, 'Old school, magasszárú focicipő. ', 'magista.png', '41,42,43,44'),
(6, '2022 NIKE MERCURIAL VAPOR 14', 'cipők', 'cipok', 'Mercurial', 34999, 'Nagyon kényelmes, piros mintájú, memóriahabos cipő.', 'mercurialvapor.png', '36,37,38'),
(7, 'NIKE ZOOM MERCURIAL SUPERFLY 9', 'cipők', 'cipok', 'Mercurial', 39999, 'Stílusos, rendkívül kényelmes focicipő.', 'superfly.png', '41,42,43'),
(8, '2023 PUMA FUTURE 18.1', 'cipők', 'cipok', 'Puma', 40999, 'Kényelmes, stílusos, focicipő.', 'pumafuture.png', '40,41,42,43,44,45,46'),
(9, 'Bundesliga Derbystar', 'labdák', 'labdak', 'Bundesliga', 15000, 'Természetes és műfüves talajra ajánljuk', 'bundesliga.jpg', '5,6,7'),
(10, 'Adidas Finale Istanbul 2020', 'labdák', 'labdak', 'Adidas', 24999, 'Bajnokok Ligájára döntőjére tervezett labda, nagyon jó anyagú és egyedi designja van. ', 'ucl2020.jpg', '5,6'),
(11, 'Vanarama Nations League 2022/23', 'labdák', 'labdak', 'Adidas', 33999, 'Egyedi tervezéssel készült labda a Nemzetek Ligája 2022-es mérkőzéseire.', 'nationsleague.jpg', '6,7'),
(12, 'Molten Europa League 22/23', 'labdák', 'labdak', 'Molten', 21999, 'Az Európa liga 2022/2023-as szezonjára készült labda amelyik kiváló anyagból készült erre.', 'moltenel.jpg', '5,6,7,8'),
(13, 'Jabulani', 'labdák', 'labdak', 'Jabulani', 13999, 'A 2010-es világbajnokságra készült labda amelyikkel Spanyolország a döntőig menetelt.', 'jabulani.jpg', '5,6,7,8,9'),
(14, 'Brazuca', 'labdák', 'labdak', 'Brazuca', 16999, 'A 2014-es Brazília világbajnokságára készült labda. A labda kiváló anyagból készült.', 'brazuca.jpg', '5,6,7,8,9'),
(15, 'Al Rihla', 'labdák', 'labdak', 'Rihla', 41999, 'A 2022-es világbajnokságra készült labda amelyik különleges anyagból készült a jobb lövések miatt.', 'alrihla.jpg', '5,6,7,8,9'),
(16, 'La Liga 17/18', 'labdák', 'labdak', 'Laliga', 12999, 'A spanyol bajnokság 2017/18-as szezonjára készült labda amelyik több rétegből áll.', 'laligaball.jpg', '5,6,7'),
(17, 'Al-Nassr hazai mez 2022/2023', 'mezek', 'mezek', 'Al-Nassr', 23999, 'Kiváló anyagból készült Al-Nassr hazai mez amelyik csapatot többek között Cristiano Ronaldo erősít.', 'alnassr.jpg', 'XXS,XS,S,M,L,XL'),
(18, 'Argentin válogatott hazai mez 2022/2023', 'mezek', 'mezek', 'Argentin hazai', 27500, 'Az argentin-válogatott meze amit a világbajnokság előtt nem sokkal adtak ki. Kiváló anyagból készült', 'argentina.jpg', 'XS,S,M,L,XL,XXL'),
(19, 'FC Barcelona hazai mez 2022/2023', 'mezek', 'mezek', 'Barcelona', 32999, 'Az FC Barcelona idei szezonjára kiadott hazai meze, kiváló anyagból készült, több méretben.', 'Barca.jpg', 'XXS,XS,S,M,L,XL,XXL'),
(20, 'Brazília válogatott idegenbeli mez 2022/2023', 'mezek', 'mezek', 'Brazília', 33999, 'A brazil-válogatott idegenbeli meze amelyet még a világbajnokság előtt adtak ki nem sokkal.', 'brasil.jpg', 'S,M,L,XL'),
(21, 'Borussia Dortmund hazai mez 2022/2023', 'mezek', 'mezek', 'Dortmund', 24999, 'A német Dortmund csapatnak az idei szezonjára kiadott mez, kiváló anyagból készült.', 'dortmund.jpg', 'XXXS,S,L,XL'),
(22, 'Real Madrid hazai mez 2022/2023', 'mezek', 'mezek', 'Madrid', 34999, 'A Real Madrid C.F idei szezonjára kiadott meze, szokásos fehér színben és kiváló anyagból', 'madrid.jpg', 'XXS,XS,S,M,L,XL,XXL'),
(23, 'Monaco FC hazai mez 2022/2023', 'mezek', 'mezek', 'Monaco', 20999, 'A francia Monaco FC idei szezonjára kiadott meze a szokásos piros-fehér színben.', 'monaco.jpg', 'S,M,L,XL,XXL'),
(24, 'Manchester United hazai mez 2022/2023', 'mezek', 'mezek', 'Manchester United', 26999, 'Az angol Manchester United idei szezonjára kiadott meze. Szokásosan pirosban adták ki ezt is.', 'mu.jpg', 'S,M,L,XL,XXL'),
(25, 'Chelsea szurkolói sál', 'sálak', 'salak', 'Chelsea', 2999, 'Az angol Chelsea csapatának az egyik kék-fehér szurkolói sálja olcsón.', 'chelsea.jpg', '110x20,120x20,130x20'),
(26, 'Finn-válogatott szurkolói sál', 'sálak', 'salak', 'Finn', 1999, 'Kiváló válogatott sál az adott ország meccseinek szurkolásához. A sál az ország szineinek megfelelő.', 'finn.jpg', '110x20,120x20,130x20'),
(27, 'SC Heerenveen szurkolói sál', 'sálak', 'salak', 'Heerenveen', 1499, 'A holland labdarúgóklub szurkolói sálja amelyik kék és fehér színben pompázik piros szívekkel. ', 'heerenveen.jpg', '110x20,120x20,130x20'),
(28, 'TSG 1899 Hoffenheim szurkolói sál', 'sálak', 'salak', 'Hoffenheim', 2599, 'A német csapat szurkolói sálja kék-fehér színben pompázik és különböző szurkolói szöveget tartalmaz', 'hoffenheim.jpg', '120x20,130x20,140x20'),
(29, 'FC Internazionale Milano szurkolói sál', 'sálak', 'salak', 'Inter', 4999, 'A milánói csapat szurkolói sálja fekete-kékben lett készítve hiszen ez a hazai színeket is jellemzi', 'inter.jpg', '110x20,120x20,140x20'),
(30, 'Reading FC szurkolói sál', 'sálak', 'salak', 'Reading', 2299, 'Az angol klub szurkolói sálja a csapat nevével van ellátva és olyan színben van elkészítve.', 'reading.jpg', '110x20,120x20,130x20'),
(31, 'FC Zürich szurkolói sál', 'sálak', 'salak', 'Zürich', 2499, 'A svájci első osztályú csapat szurkolói sálja a címerrel van ellátva és a csapat színeiben készül el', 'zurich.jpg', '130x20,140x20,150x20'),
(32, 'Rangers FC szurkolói sál', 'sálak', 'salak', 'Rangers', 1299, 'A skót Rangers FC sálja a csapat színeiben készül azaz kék-fehér színben. ', 'rangers.jpg', '120x20,130x20,140x20'),
(33, 'Puma kapuskesztyű', 'kesztyűk', 'kesztyuk', 'Adidas', 12999, 'Nagyon minőségi kapuskesztyű. Ajánlott felnőtteknek és gyerekeknek egyaránt. ', 'puma.jpg', '8,9'),
(34, 'Pro Touch kapuskesztyű', 'kesztyűk', 'kesztyuk', 'Forza', 8999, 'A Pro Touch kapuskesztyű ajánlott kezdőknek hiszen szivacsos ezáltal jól felfogja a labdát.', 'protouch.jpg', '6,7,8'),
(35, 'Forza kapuskesztyű', 'kesztyűk', 'kesztyuk', 'Forza', 9999, 'Az alábbi Forza kesztyű haladó kapusoknak kiváló hiszen remekül épül fel a kesztyű szerkezete', 'forza.jpg', '9,10'),
(36, 'Rebook kapuskesztyű', 'kesztyűk', 'kesztyuk', 'Rebook', 14999, 'A Rebook kapuskesztyű inkább haladók és profik számára ajánlott, kapható feketében és fehérben is', 'rebook.jpg', '6,7,8,9'),
(37, 'Pope kapuskesztyű', 'kesztyűk', 'kesztyuk', 'Pope', 11999, 'A Pope kapuskesztyű kezdőknek és haladóknak is ajánlott fekete-fehérben kapható a kesztyű.', 'pope.jpg', '6,7,8,9'),
(38, 'Nike Mercurial kapuskesztyű', 'kesztyűk', 'kesztyuk', 'Nike', 7500, 'A Nike Mercurial kapuskesztyű egyaránt ajánlott kezdőknek és haladóknak is.', 'nikemercurial.jpg', '8,9'),
(39, 'Goalie kapuskesztyű', 'kesztyűk', 'kesztyuk', 'Goalie', 8999, 'A Goalie kapuskesztyű ajánlott haladóknak és szivacsos felülete miatt könnyen védhetünk benne.', 'goalie.jpg', '7,8,9'),
(40, 'Willpower kapuskesztyű', 'kesztyűk', 'kesztyuk', 'Willpower', 15999, 'A Willpower kezdőknek és haladóknak is ajánlott kapuskesztyű. Kapható feketében és fehérben is.', 'willpower.jpg', '5,6,7,8');


-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `termekkep`
--

CREATE TABLE `termekkep` (
  `termek_id` int(50) NOT NULL,
  `szam` int(50) NOT NULL,
  `kep` varchar(50) COLLATE utf8_hungarian_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `ertekeles`
--
ALTER TABLE `ertekeles`
  ADD PRIMARY KEY (`felhasznalonev`);

--
-- A tábla indexei `felhasznalok`
--
ALTER TABLE `felhasznalok`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `EMAIL` (`email`);

--
-- A tábla indexei `rendeles`
--
ALTER TABLE `rendeles`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `rendelesi_tetel`
--
ALTER TABLE `rendelesi_tetel`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `termekek`
--
ALTER TABLE `termekek`
  ADD PRIMARY KEY (`termek_id`);

--
-- A tábla indexei `termekkep`
--
ALTER TABLE `termekkep`
  ADD PRIMARY KEY (`termek_id`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `felhasznalok`
--
ALTER TABLE `felhasznalok`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT a táblához `rendeles`
--
ALTER TABLE `rendeles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT a táblához `rendelesi_tetel`
--
ALTER TABLE `rendelesi_tetel`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
