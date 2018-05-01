-- BAZA DANYCH

CREATE DATABASE [Projekt_11065];
GO

--TABELE

CREATE TABLE [dbo].[Marki]
(
    [MarkaId] INT, --PK (NOT NULL),  przez polecenie ON DELETE SET NULL ON UPDATE SET NULL nie mo¿e byæ tu 'NOT NULL'
    [NazwaMarki] NVARCHAR(160) NOT NULL,
    CONSTRAINT [PK_Marki] PRIMARY KEY CLUSTERED ([MarkaId])
);
GO

CREATE TABLE [dbo].[Modele]
(
    [ModelId] INT, --PK (NOT NULL),
	[MarkaId] INT, --FK 
    [NazwaModelu] NVARCHAR(25)NOT NULL,
    [KolorModelu] NVARCHAR(15),
    [DataProdukcji] DATETIME CHECK(DataProdukcji<getDate()),
    [DataRejestracji] DATETIME CHECK(DataRejestracji<= getDate())NOT NULL,
    [PojemnoscSilnika] NVARCHAR (4),
    [DataPrzyjecia] DATETIME DEFAULT(getDate()),
    [DataSprzedazy] DATETIME CHECK(DataSprzedazy<= getDate()),
	[Rezerwacja] BIT,
	[NumerVIN] NVARCHAR (17) NOT NULL,
    [TypNadwozia] NVARCHAR(10),  
	[RodzajPojazdu] NVARCHAR(15),  
    CONSTRAINT [PK_Modele] PRIMARY KEY CLUSTERED ([ModelId])
);
GO

CREATE TABLE [dbo].[Pracownicy]
(
	[PracownikId] INT,  --PK (NOT NULL),
	[ImiePracownika] NVARCHAR (15) NOT NULL,
	[NazwiskoPracownika] NVARCHAR (25) NOT NULL,
	[PESELPracownika] NCHAR (11) UNIQUE NOT NULL, -- zawsze 11 cyfr, bez potrzeby operacji algebraicznych
	[DataZatrudnienia] DATETIME DEFAULT(getDate()),
    CONSTRAINT [PK_Pracownicy] PRIMARY KEY CLUSTERED ([PracownikId])
);
GO

CREATE TABLE [dbo].[Klienci]
(
	[KlientId] INT, --PK (NOT NULL),
	[ImieKlienta] NVARCHAR (15) NOT NULL,
	[NazwiskoKlienta] NVARCHAR (25) NOT NULL,
	[NrDowoduOsobistego] NCHAR (9) UNIQUE NOT NULL, -- zawsze 3 litery i 6 cyfr
	CONSTRAINT [PK_Klienci] PRIMARY KEY CLUSTERED ([KlientId])
);
GO

CREATE TABLE [dbo].[Cennik]
(
	[CenaId] INT,  --PK (NOT NULL),
	[ModelId] INT, --FK (NOT NULL),
	[Cena] MONEY CHECK(Cena > 0) NOT NULL, -- w z³
	[DataOdKiedyObowiazujeCena] DATETIME NOT NULL,
	[DataDoKiedyObowiazujeCena] DATETIME ,
	CONSTRAINT [PK_Cennik] PRIMARY KEY CLUSTERED ([CenaId])
);
GO

CREATE TABLE [dbo].[Zamowienia]
(
	[ZamowienieId] INT,		--PK (NOT NULL),
	[ModelId] INT,			--FK (NOT NULL),
	[PracownikId] INT,		--FK (NOT NULL),
	[KlientId] INT,			--FK (NOT NULL),
	[Cena] MONEY CHECK(Cena > 0) NOT NULL,
	[DataZamowienia] DATETIME DEFAULT(GetDate())NOT NULL,
	[DataPlanowanegoOdbioru] DATETIME,
	[Realizacja] BIT NOT NULL, --  czy zamówienie zosta³o ju¿ zrealizowane 
	[Oplata] BIT NOT NULL, --  czy zamówienie zosta³o ju¿ op³acone
	CONSTRAINT [PK_Zamowienia] PRIMARY KEY CLUSTERED ([ZamowienieId])
);
GO

--KLUCZE OBCE I INDEKSY DO NICH

ALTER TABLE [dbo].[Modele] ADD CONSTRAINT [FK_ModelMarkaId]
    FOREIGN KEY ([MarkaId]) REFERENCES [dbo].[Marki] ([MarkaId]) ON DELETE SET NULL ON UPDATE SET NULL;
GO

CREATE INDEX [IFK_ModeleMarkaId] ON [dbo].[Modele] ([MarkaId]);
GO


ALTER TABLE [dbo].[Cennik] ADD CONSTRAINT [FK_CenaModelId]
    FOREIGN KEY ([ModelId]) REFERENCES [dbo].[Modele] ([ModelId]) ON DELETE SET NULL ON UPDATE SET NULL;
GO

CREATE INDEX [IFK_CenaModelId] ON [dbo].[Cennik] ([ModelId]);
GO


ALTER TABLE [dbo].[Zamowienia] ADD CONSTRAINT [FK_ZamowienieKlientId]
    FOREIGN KEY ([KlientId]) REFERENCES [dbo].[Klienci] ([KlientId]) ON DELETE SET NULL ON UPDATE SET NULL;
GO

CREATE INDEX [IFK_ZamowienieKlientId] ON [dbo].[Zamowienia] ([KlientId]);
GO


ALTER TABLE [dbo].[Zamowienia] ADD CONSTRAINT [FK_ZamowienieModelId]
    FOREIGN KEY ([ModelId]) REFERENCES [dbo].[Modele] ([ModelId]) ON DELETE SET NULL ON UPDATE SET NULL;
GO

CREATE INDEX [IFK_ZamowienieModelId] ON [dbo].[Zamowienia] ([ModelId]);
GO


ALTER TABLE [dbo].[Zamowienia] ADD CONSTRAINT [FK_ZamowieniePracownikId]
    FOREIGN KEY ([PracownikId]) REFERENCES [dbo].[Pracownicy] ([PracownikId]) ON DELETE SET NULL ON UPDATE SET NULL;
GO

CREATE INDEX [IFK_ZamowieniePracownikId] ON [dbo].[Pracownicy] ([PracownikId]);
GO

-- WYPE£NIENIE TABEL

--marki
INSERT INTO [dbo].[Marki] ([MarkaId], [NazwaMarki]) VALUES (1, 'Ford'); 
GO
INSERT INTO [dbo].[Marki] ([MarkaId], [NazwaMarki]) VALUES (2, 'Toyota'); 
GO
INSERT INTO [dbo].[Marki] ([MarkaId], [NazwaMarki]) VALUES (3, 'Nissan'); 
GO

-- modele (wszystkie nr vin s¹ dla Volkswagenów)
INSERT INTO [dbo].[Modele] ([ModelId], [MarkaId], [NazwaModelu], [KolorModelu], [DataProdukcji], 
							[DataRejestracji], [PojemnoscSilnika], [DataPrzyjecia], [DataSprzedazy], 
							[Rezerwacja], [NumerVIN], [TypNadwozia],  [RodzajPojazdu]) 
VALUES 
--[ModId][MarId][Nazwa][Kolor][Produkcji][Rejestracji][silnik][Przyjecia][Sprzedazy][Rezerwacja][VIN][Nadwozie][RodzajPojazdu]
(1, 1, 'Mustang VI', '¯ó³ty',	2014/09/08, 2014/10/01, 4.2, 2014/09/28,	NULL, 0, 'WVWZZZAUZHW141416', 'Coupé','Osobowe' ),
(2, 1, 'Mustang VI', 'Czarny',	2014/09/08, 2014/10/01, 4.2, 2014/09/28,	NULL, 1, 'WVWZZZ1KZ7W181754', 'Coupé','Osobowe' ),
(3, 1, 'Mondeo Mk V', 'Srebny',	2013/02/15, 2013/05/08, 2.5, 2013/04/30,	NULL, 1, 'WVWZZZ50ZKK004420', 'Liftback','Osobowe' ),
(4, 1, 'Mondeo Mk V', 'Bia³y',	2013/02/15, 2013/05/08, 2.5, 2013/04/30,	NULL, 0, 'WVWZZZ6RZEU029017', 'Liftback','Osobowe' ),
(5, 1, 'Mondeo Mk V', 'Czarny',	2013/02/15, 2013/05/08, 2.5, 2013/04/30,	NULL, 0, 'WVWZZZ3BZYE268659', 'Liftback','Osobowe' ),
(6, 2, 'Yaris WRC', 'Czarny',	2017/04/18, 2017/05/23, 1.6, 2017/04/28,	2018/01/10, 1, 'WVWZZZ16ZJM008149', 'Hatchback','Osobowe' ),
(7, 2, 'Yaris WRC', 'Srebny',	2017/04/18, 2017/05/23, 1.6, 2017/04/28,	NULL, 0, 'WVWZZZ3BZYE268659', 'Hatchback','Osobowe' ),
(8, 2, 'Yaris WRC', 'Czerwony',	2017/04/18, 2017/05/23, 1.6, 2017/04/28,	NULL, 0, 'WVWZZZ6NZ1Y308155', 'Hatchback','Osobowe' ),
(9, 3, 'Skyline GT-R', 'Czarny',2015/08/28, 2015/12/03, 3.8, 2014/09/28,	NULL, 1, 'WVWZZZAUZGW200547', 'Liftback','Osobowe' ),
(10,3,'Skyline GT-R','Czerwony',2015/08/28, 2015/12/03, 3.8, 2014/09/28,	NULL, 0, 'WVWZZZ13ZAV430088', 'Liftback','Osobowe' ),
(11,3, 'Xterra', 'Srebny',		2016/06/11, 2016/09/01, 2.4, 2016/07/11,	2016/10/15,	1, 'WVWZZZ3DZ58001141', 'SUV','Osobowe' );
GO

-- pracownicy
INSERT INTO [dbo].[Pracownicy]([PracownikId],[ImiePracownika], [NazwiskoPracownika], [PESELPracownika],[DataZatrudnienia]) VALUES 
(1, 'Karol', 'Nowak', '76051245450', 2012/05/01),
(2, 'Julia', 'Kowalska', '82111755225', 2012/05/09),
(3, 'Miko³aj', 'Styczeñ', '71121400011',2015/08/04),
(4, 'Anna', 'Jêdrajczyk', '85040156527', 2016/01/25);
GO

-- klienci
INSERT INTO [dbo].[Klienci] VALUES (1, 'Jakub', 'Nocoñ', 'CCD579426'); 
GO
INSERT INTO [dbo].[Klienci] VALUES (2, 'Karolina', 'Budyñ', 'UJD758620'); 
GO
INSERT INTO [dbo].[Klienci] VALUES (3, 'Micha³', 'Siano', 'DGI785587'); 
GO
INSERT INTO [dbo].[Klienci] VALUES (4, 'Joanna', 'Moduch', 'HUD875321'); 
GO

-- cennik
INSERT INTO [dbo].[Cennik] ([CenaId], [ModelId], [Cena], 
			[DataOdKiedyObowiazujeCena], [DataDoKiedyObowiazujeCena])VALUES 
(1, 1, 148200,	2017/02/12, 2018/01/25),
(2, 1, 160200,	2018/01/25, 2018/08/30),
(3, 2, 150100,	2018/02/12, 2018/08/25),
(4, 3, 78500,	2017/09/15, 2017/12/20),
(5, 3, 75500,	2017/12/20, 2018/07/20),
(6, 4, 77900,	2018/02/12, 2018/07/20),
(7, 5, 77200,	2018/02/12, NULL),
(8, 6, 159880,	2018/02/12, 2018/09/16),
(9, 7, 159100,	2017/05/04, 2018/04/30),
(10, 7, 170000,	2018/04/30, 2018/09/16),
(11, 8, 159700,	2018/02/12, 2018/09/16),
(12, 9, 541000,	2017/05/12, 2018/05/02),
(13, 9, 561000,	2018/05/02, 2018/10/02),
(14, 10, 540800,2018/02/12, NULL),
(15, 11, 39500,	2018/02/12, 2018/10/12);
GO

-- zamówenia
INSERT INTO [dbo].[Zamowienia] ([ZamowienieId],[ModelId], [PracownikId],[KlientId], [Cena],[DataZamowienia], [DataPlanowanegoOdbioru],[Realizacja],[Oplata]) 
VALUES 
--[ZamId][ModlId][PracoId][KlId]
--		[Cena][DZamowienia][DPOdbioru][Realiz][Oplata]
(1,2,1,1, 148200, 2018/03/15, NULL,	1, 1),
(2,3,1,2, 75200,  2018/04/17, NULL,	0, 0),
(3,6,2,3, 159880, 2017/12/26, 2018/01/10, 1, 1),
(4,9,3,1, 560000, 2018/04/10, NULL,	0, 0),
(5,11,4,4,39000,  2016/10/01, 2016/10/15, 1, 1),
(6,4,3,2, 77800,  2018/01/03, 2018/01/15, 1, 1);
GO

--Widoki Raporty]

CREATE SCHEMA [Raporty]
GO
-- widok 1.

	CREATE VIEW [Raporty].[Widok1]
	AS

	SELECT
		[ma].[NazwaMarki]	AS [Marki],
		COUNT(*)			AS [Iloœæ zamówieñ],
		SUM ([Cena])		AS [Sumaryczna kwota sprzeda¿y]

	FROM
					[dbo].[Marki] AS [ma]
		INNER JOIN	[dbo].[Modele] AS [mo] ON [ma].[MarkaId] = [mo].[MarkaId]
		INNER JOIN	[dbo].[Zamowienia] AS [za] ON [mo].[ModelId] = [za].[ModelId]
	GROUP BY
		[ma].[NazwaMarki]
	GO

	SELECT *
	FROM [Raporty].[Widok1]
	GO;

-- widok  2.

	CREATE VIEW [Raporty].[Widok2]
	AS

	SELECT
		[za].[ZamowienieId] AS [Lista zamówieñ],
		(([ce].[Cena] - [za].[Cena])/[ce].[Cena])*100 AS [Rabat w %]
	FROM
					[dbo].[Zamowienia]	AS [za]
		INNER JOIN	[dbo].[Cennik]		AS [ce] ON [za].[ModelId] = [ce].[ModelId]
	GROUP BY
		[za].[ZamowienieId],
		[za].[Cena],
		[ce].[Cena]
	GO

	SELECT *
	FROM [Raporty].[Widok2]
	GO


-- widok  3.

	CREATE VIEW [Raporty].[Widok3]
	AS

	SELECT
		[ma].[NazwaMarki],
		[mo].[NazwaModelu],
		[mo].[NumerVIN],
		[mo].[KolorModelu],
		[mo].[PojemnoscSilnika],
		[mo].[TypNadwozia],
		[mo].[RodzajPojazdu]
		
	FROM
				[dbo].[Modele]		AS [mo]
	LEFT JOIN	[dbo].[Zamowienia]	AS [za] ON [mo].[ModelId] = [za].[ModelId]
	INNER JOIN	[dbo].[Marki]		AS [ma] ON [mo].[MarkaId] = [ma].[MarkaId]
	WHERE
		[za].[ZamowienieId] IS NULL
	GO

	SELECT *
	FROM [Raporty].[Widok3]
	GO

	-- widok  4.

	CREATE VIEW [Raporty].[Widok4]
	AS

	SELECT
		[p].ImiePracownika,
		[p].NazwiskoPracownika,
		[p].PESELPracownika,
		[p].DataZatrudnienia,
		COUNT (*) AS [Ile zamówieñ],
		SUM ([Cena])AS [£¹czna kwota]		
	FROM
				[dbo].[Pracownicy]	AS [p]
	LEFT JOIN	[dbo].[Zamowienia]	AS [za] ON [p].[PracownikId] = [za].[PracownikId]
	GROUP BY
		[p].PracownikId,
		[p].ImiePracownika,
		[p].NazwiskoPracownika,
		[p].PESELPracownika,
		[p].DataZatrudnienia
	GO

	SELECT *
	FROM [Raporty].[Widok4]
	GO

