/*

Created: 20200320@Sophia
Task: Saba.club integrate [redmine: #130372]
DB: DBPRO.bodb02

*/
use bodb02
go 


INSERT INTO  Products  (ProductID,ProductName,Description,ProductPrefix,Enabled,BalanceType,SubProductBalanceType, GroupType,CasinoType,IsOfferPlayForFun, VendorId) VALUES (42,'Saba.club','Saba.club','SBC',1,3,NULL,0,1,0,42)


INSERT INTO  Sports  (Sporttype,SportName)VALUES (200,N'Saba.club')
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1620, 'Game 9',  1620,1620,'Game 9'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1621, 'Game 10',  1621,1621,'Game 10'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1622, 'Game 11',  1622,1622,'Game 11'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1623, 'Game 12',  1623,1623,'Game 12'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1624, 'Game 13',  1624,1624,'Game 13'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1625, 'Game 14',  1625,1625,'Game 14'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1626, 'Game 15',  1626,1626,'Game 15'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1627, 'Game 16',  1627,1627,'Game 16'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1628, 'Game 17',  1628,1628,'Game 17'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1629, 'Game 18',  1629,1629,'Game 18'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1630, 'Game 19',  1630,1630,'Game 19'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1631, 'Game 20',  1631,1631,'Game 20'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1632, 'Game 21',  1632,1632,'Game 21'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1633, 'Game 22',  1633,1633,'Game 22'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1634, 'Game 23',  1634,1634,'Game 23'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1635, 'Game 24',  1635,1635,'Game 24'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1636, 'Game 25',  1636,1636,'Game 25'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1637, 'Game 26',  1637,1637,'Game 26'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1638, 'Game 27',  1638,1638,'Game 27'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1639, 'Game 28',  1639,1639,'Game 28'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1640, 'Game 29',  1640,1640,'Game 29'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1641, 'Game 30',  1641,1641,'Game 30'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1642, 'Game 31',  1642,1642,'Game 31'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1643, 'Game 32',  1643,1643,'Game 32'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1644, 'Game 33',  1644,1644,'Game 33'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1645, 'Game 34',  1645,1645,'Game 34'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1646, 'Game 35',  1646,1646,'Game 35'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1647, 'Game 36',  1647,1647,'Game 36'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1648, 'Game 37',  1648,1648,'Game 37'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1649, 'Game 38',  1649,1649,'Game 38'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1650, 'Game 39',  1650,1650,'Game 39'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1651, 'Game 40',  1651,1651,'Game 40'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1652, 'Game 41',  1652,1652,'Game 41'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1653, 'Game 42',  1653,1653,'Game 42'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1654, 'Game 43',  1654,1654,'Game 43'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1655, 'Game 44',  1655,1655,'Game 44'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1656, 'Game 45',  1656,1656,'Game 45'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1657, 'Game 46',  1657,1657,'Game 46'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1658, 'Game 47',  1658,1658,'Game 47'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1659, 'Game 48',  1659,1659,'Game 48'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1660, 'Game 49',  1660,1660,'Game 49'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1661, 'Game 50',  1661,1661,'Game 50'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1662, 'Game 51',  1662,1662,'Game 51'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1663, 'Game 52',  1663,1663,'Game 52'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1664, 'Game 53',  1664,1664,'Game 53'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1665, 'Game 54',  1665,1665,'Game 54'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1666, 'Game 55',  1666,1666,'Game 55'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1667, 'Game 56',  1667,1667,'Game 56'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1668, 'Game 57',  1668,1668,'Game 57'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1669, 'Game 58',  1669,1669,'Game 58'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1670, 'Game 59',  1670,1670,'Game 59'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1671, 'Game 60',  1671,1671,'Game 60'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1672, 'Game 61',  1672,1672,'Game 61'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1673, 'Game 62',  1673,1673,'Game 62'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1674, 'Game 63',  1674,1674,'Game 63'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1675, 'Game 64',  1675,1675,'Game 64'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1676, 'Game 65',  1676,1676,'Game 65'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1677, 'Game 66',  1677,1677,'Game 66'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1678, 'Game 67',  1678,1678,'Game 67'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1679, 'Game 68',  1679,1679,'Game 68'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1680, 'Game 69',  1680,1680,'Game 69'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1681, 'Game 70',  1681,1681,'Game 70'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1682, 'Game 71',  1682,1682,'Game 71'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1683, 'Game 72',  1683,1683,'Game 72'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1684, 'Game 73',  1684,1684,'Game 73'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1685, 'Game 74',  1685,1685,'Game 74'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1686, 'Game 75',  1686,1686,'Game 75'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1687, 'Game 76',  1687,1687,'Game 76'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1688, 'Game 77',  1688,1688,'Game 77'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1689, 'Game 78',  1689,1689,'Game 78'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1690, 'Game 79',  1690,1690,'Game 79'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1691, 'Game 80',  1691,1691,'Game 80'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1692, 'Game 81',  1692,1692,'Game 81'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1693, 'Game 82',  1693,1693,'Game 82'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1694, 'Game 83',  1694,1694,'Game 83'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1695, 'Game 84',  1695,1695,'Game 84'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1696, 'Game 85',  1696,1696,'Game 85'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1697, 'Game 86',  1697,1697,'Game 86'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1698, 'Game 87',  1698,1698,'Game 87'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 1699, 'Game 88',  1699,1699,'Game 88'



insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1611,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1612,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1613,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1614,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1615,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1616,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1617,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1618,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1619,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1620,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1621,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1622,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1623,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1624,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1625,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1626,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1627,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1628,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1629,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1630,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1631,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1632,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1633,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1634,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1635,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1636,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1637,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1638,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1639,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1640,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1641,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1642,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1643,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1644,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1645,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1646,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1647,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1648,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1649,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1650,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1651,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1652,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1653,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1654,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1655,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1656,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1657,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1658,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1659,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1660,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1661,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1662,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1663,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1664,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1665,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1666,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1667,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1668,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1669,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1670,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1671,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1672,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1673,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1674,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1675,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1676,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1677,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1678,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1679,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1680,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1681,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1682,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1683,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1684,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1685,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1686,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1687,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1688,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1689,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1690,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1691,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1692,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1693,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1694,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1695,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1696,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1697,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1698,0,42,1,0,0,'',1)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (200,1699,0,42,1,0,0,'',1)


/*	
	Creator: Elodie
	Date: 20180703
	Task: Insert data into RefResource for Card Club
	DB: DBPRO/bodb02
*/
USE bodb02
GO

--Insert Remoting ref Product
DECLARE @RefId		VARCHAR(20)		= 'Product',
	@ResourceId		VARCHAR(20)		= 42,
	@Resource_en	NVARCHAR(50)	= 'Saba.club',
	@Resource_ch	NVARCHAR(50)	= '',
	@Resource_cs	NVARCHAR(50)	= '',
	@Resource_jp	NVARCHAR(50)	= '',
	@Resource_it	NVARCHAR(50)	= '',
	@Resource_th	NVARCHAR(50)	= '',
	@Resource_ko	NVARCHAR(50)	= '',
	@Resource_es	NVARCHAR(50)	= '',
	@Sort1			INT				= NULL,
	@Sort2			INT				= NULL,
	@Resource_el	NVARCHAR(50)	= '',
	@Resource_vn	NVARCHAR(50)	= '',
	@Resource_pl	NVARCHAR(50)	= NULL,
	@Resource_id	NVARCHAR(50)	= NULL,
	@Resource_hi	NVARCHAR(50)	= NULL,
	@Resource_mm	NVARCHAR(50)	= NULL,
	@Resource_fr	NVARCHAR(50)	= NULL,
	@Resource_ru	NVARCHAR(50)	= NULL,
	@Resource_pt	NVARCHAR(50)	= NULL,
	@Resource_de	NVARCHAR(50)	= NULL
							   
INSERT INTO RefResource (RefId, ResourceId, Resource_en, Resource_ch, Resource_cs, Resource_jp, Resource_it, Resource_th, Resource_ko, Resource_es, Sort1, Sort2, Resource_el, Resource_vn, Resource_pl, Resource_id, Resource_hi, Resource_mm, Resource_fr, Resource_ru, Resource_pt, Resource_de)
SELECT @RefId, @ResourceId, @Resource_en, @Resource_ch, @Resource_cs, @Resource_jp, @Resource_it, @Resource_th, @Resource_ko, @Resource_es, @Sort1, @Sort2, @Resource_el, @Resource_vn, @Resource_pl, @Resource_id, @Resource_hi, @Resource_mm, @Resource_fr, @Resource_ru, @Resource_pt, @Resource_de

SELECT * FROM RefResource WHERE RefId = 'Product'
 