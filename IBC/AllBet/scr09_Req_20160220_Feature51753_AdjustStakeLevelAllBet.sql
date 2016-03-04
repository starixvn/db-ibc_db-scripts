CREATE TABLE #updatestake (stakelevelid int, gametypeid int, minlabel varchar(50),maxlabel varchar(50),minstake decimal(19,8),maxstake decimal(19,8))
GO
INSERT INTO #updatestake
SELECT 	2 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel ,  2  AS minstake,  500  AS maxstake
UNION ALL 	
SELECT 	3 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	4 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	5 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	6 AS stakelevelid, 2401 AS gametypeid, '5' AS minlabel, '1,000' AS maxlabel , 5 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	7 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '2,500' AS maxlabel , 20 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	8 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	9 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	10 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	11 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	12 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	13 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	14 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '10,000' AS maxlabel , 50 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	15 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '25,000' AS maxlabel , 250 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	16 AS stakelevelid, 2401 AS gametypeid, '1,000' AS minlabel, '50,000' AS maxlabel , 1000 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	17 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	18 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,500' AS maxlabel , 10 AS minstake, 1500 AS maxstake	
UNION ALL 
SELECT 	19 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '5,000' AS maxlabel , 50 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	20 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	21 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '25,000' AS maxlabel , 500 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	22 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	23 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	24 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	25 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	26 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	27 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	28 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	29 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	30 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	31 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	32 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	33 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	34 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,500' AS maxlabel , 10 AS minstake, 1500 AS maxstake	
UNION ALL 
SELECT 	35 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '5,000' AS maxlabel , 50 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	36 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	37 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '25,000' AS maxlabel , 500 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	38 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	39 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	40 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	41 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	42 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	43 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	44 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	45 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	46 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	47 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	48 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	49 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	54 AS stakelevelid, 2401 AS gametypeid, '25,000' AS minlabel, '1,000,000' AS maxlabel , 25000 AS minstake, 1000000 AS maxstake	
UNION ALL 
SELECT 	55 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	56 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	57 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	58 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	59 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	60 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	61 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	62 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	63 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '10,000' AS maxlabel , 50 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	64 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '25,000' AS maxlabel , 250 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	65 AS stakelevelid, 2401 AS gametypeid, '1,000' AS minlabel, '50,000' AS maxlabel , 1000 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	66 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	67 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '20,000' AS maxlabel , 100 AS minstake, 20000 AS maxstake	
UNION ALL 
SELECT 	68 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '50,000' AS maxlabel , 500 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	69 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	70 AS stakelevelid, 2401 AS gametypeid, '5,000' AS minlabel, '250,000' AS maxlabel , 5000 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	71 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '20,000' AS maxlabel , 100 AS minstake, 20000 AS maxstake	
UNION ALL 
SELECT 	72 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '50,000' AS maxlabel , 500 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	73 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	74 AS stakelevelid, 2401 AS gametypeid, '5,000' AS minlabel, '250,000' AS maxlabel , 5000 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	75 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	76 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	77 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	78 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	79 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	80 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	81 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	82 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	83 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	84 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	85 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	86 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	87 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	88 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	89 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	90 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	91 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	92 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	93 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	94 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	95 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	96 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	97 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	98 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	99 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	100 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	101 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	102 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	103 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '20,000' AS maxlabel , 100 AS minstake, 20000 AS maxstake	
UNION ALL 
SELECT 	104 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '50,000' AS maxlabel , 500 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	105 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	106 AS stakelevelid, 2401 AS gametypeid, '5,000' AS minlabel, '250,000' AS maxlabel , 5000 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	107 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '10,000' AS maxlabel , 50 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	108 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '25,000' AS maxlabel , 250 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	109 AS stakelevelid, 2401 AS gametypeid, '1,000' AS minlabel, '50,000' AS maxlabel , 1000 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	110 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	111 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	112 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	113 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	114 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	115 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '300,000' AS maxlabel , 2500 AS minstake, 300000 AS maxstake	
UNION ALL 
SELECT 	116 AS stakelevelid, 2401 AS gametypeid, '7,500' AS minlabel, '750,000' AS maxlabel , 7500 AS minstake, 750000 AS maxstake	
UNION ALL 
SELECT 	117 AS stakelevelid, 2401 AS gametypeid, '25,000' AS minlabel, '1,000,000' AS maxlabel , 25000 AS minstake, 1000000 AS maxstake	
UNION ALL 
SELECT 	118 AS stakelevelid, 2401 AS gametypeid, '75,000' AS minlabel, '3,000,000' AS maxlabel , 75000 AS minstake, 3000000 AS maxstake	
UNION ALL 
SELECT 	119 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	120 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	121 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	122 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	123 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	124 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	125 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	126 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	127 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	128 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	129 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	130 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	131 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	132 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	133 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	134 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	135 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	136 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	137 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	138 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	139 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	140 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	141 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	142 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	143 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,500' AS maxlabel , 10 AS minstake, 1500 AS maxstake	
UNION ALL 
SELECT 	144 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '5,000' AS maxlabel , 50 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	145 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	146 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '25,000' AS maxlabel , 500 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	147 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,500' AS maxlabel , 10 AS minstake, 1500 AS maxstake	
UNION ALL 
SELECT 	148 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '5,000' AS maxlabel , 50 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	149 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	150 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '25,000' AS maxlabel , 500 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	151 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,500' AS maxlabel , 10 AS minstake, 1500 AS maxstake	
UNION ALL 
SELECT 	152 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '5,000' AS maxlabel , 50 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	153 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	154 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '25,000' AS maxlabel , 500 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	155 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '10,000' AS maxlabel , 50 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	156 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '25,000' AS maxlabel , 250 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	157 AS stakelevelid, 2401 AS gametypeid, '1,000' AS minlabel, '50,000' AS maxlabel , 1000 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	158 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	159 AS stakelevelid, 2401 AS gametypeid, '5' AS minlabel, '1,000' AS maxlabel , 5 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	160 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '2,500' AS maxlabel , 20 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	161 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	162 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	163 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '10,000' AS maxlabel , 50 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	164 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '25,000' AS maxlabel , 250 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	165 AS stakelevelid, 2401 AS gametypeid, '1,000' AS minlabel, '50,000' AS maxlabel , 1000 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	166 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	167 AS stakelevelid, 2401 AS gametypeid, '5' AS minlabel, '1,000' AS maxlabel , 5 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	168 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '2,500' AS maxlabel , 20 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	169 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	170 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	171 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '20,000' AS maxlabel , 100 AS minstake, 20000 AS maxstake	
UNION ALL 
SELECT 	172 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '50,000' AS maxlabel , 500 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	173 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	174 AS stakelevelid, 2401 AS gametypeid, '5,000' AS minlabel, '250,000' AS maxlabel , 5000 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	175 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	176 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	177 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	178 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	179 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	180 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	181 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	182 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	183 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	184 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	185 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	186 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	187 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,500' AS maxlabel , 10 AS minstake, 1500 AS maxstake	
UNION ALL 
SELECT 	188 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '5,000' AS maxlabel , 50 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	189 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	190 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '25,000' AS maxlabel , 500 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	191 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	192 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	193 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	194 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '1,000' AS maxlabel , 1 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	195 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	196 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	197 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	198 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	199 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	200 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	201 AS stakelevelid, 2402 AS gametypeid, '50' AS minlabel, '50,000' AS maxlabel , 50 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	202 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	203 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	204 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	205 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	206 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	207 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	208 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	209 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	210 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	211 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	212 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	213 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	214 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	215 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	216 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	217 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	218 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	219 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	220 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	221 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	222 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	223 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	224 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	225 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	226 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	228 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '20' AS maxlabel , 10 AS minstake, 20 AS maxstake	
UNION ALL 
SELECT 	229 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	230 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	231 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	232 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	233 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	234 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	235 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	236 AS stakelevelid, 2402 AS gametypeid, '50' AS minlabel, '50,000' AS maxlabel , 50 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	237 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	238 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	239 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	240 AS stakelevelid, 2402 AS gametypeid, '250' AS minlabel, '250,000' AS maxlabel , 250 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	241 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	242 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	243 AS stakelevelid, 2402 AS gametypeid, '250' AS minlabel, '250,000' AS maxlabel , 250 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	244 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	245 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	246 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	247 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	248 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	249 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	250 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	251 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	252 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	253 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	254 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	255 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	256 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	257 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	258 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	259 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	260 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	261 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	262 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	263 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	264 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	265 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	266 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	267 AS stakelevelid, 2402 AS gametypeid, '250' AS minlabel, '250,000' AS maxlabel , 250 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	268 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	269 AS stakelevelid, 2402 AS gametypeid, '50' AS minlabel, '50,000' AS maxlabel , 50 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	270 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	271 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	272 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	273 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	274 AS stakelevelid, 2402 AS gametypeid, '300' AS minlabel, '300,000' AS maxlabel , 300 AS minstake, 300000 AS maxstake	
UNION ALL 
SELECT 	275 AS stakelevelid, 2402 AS gametypeid, '1,500' AS minlabel, '1,500,000' AS maxlabel , 1500 AS minstake, 1500000 AS maxstake	
UNION ALL 
SELECT 	276 AS stakelevelid, 2402 AS gametypeid, '3,000' AS minlabel, '3,000,000' AS maxlabel , 3000 AS minstake, 3000000 AS maxstake	
UNION ALL 
SELECT 	277 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	278 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	279 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	280 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	281 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	282 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	283 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	284 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	285 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	286 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	287 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	288 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	289 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	290 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	291 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	292 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	293 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	294 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	295 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	296 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	297 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	298 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	299 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	300 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	301 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	302 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	303 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	304 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	305 AS stakelevelid, 2402 AS gametypeid, '50' AS minlabel, '50,000' AS maxlabel , 50 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	306 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	307 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '1,000' AS maxlabel , 1 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	308 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	309 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	310 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	311 AS stakelevelid, 2402 AS gametypeid, '50' AS minlabel, '50,000' AS maxlabel , 50 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	312 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	313 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '1,000' AS maxlabel , 1 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	314 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	315 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	316 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	317 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	318 AS stakelevelid, 2402 AS gametypeid, '250' AS minlabel, '250,000' AS maxlabel , 250 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	319 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	320 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	321 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	322 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	323 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	324 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	325 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	326 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	327 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	328 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	329 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	330 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL
Select 331 AS stakelevelid,2401 AS gametypeid, '10' AS minlabel,'1,000' AS maxlabel ,10  AS minstake, 1000 AS maxstake 
UNION ALL 
Select 332 AS stakelevelid,2401 AS gametypeid, '100' AS minlabel,'5,000' AS maxlabel ,100 AS minstake, 5000 AS maxstake 
UNION ALL 
Select 333 AS stakelevelid,2401 AS gametypeid, '2'  AS minlabel,'500' AS maxlabel ,2  AS minstake, 500 AS maxstake 
UNION ALL 
Select 334 AS stakelevelid,2401 AS gametypeid, '50' AS minlabel,'2,500' AS maxlabel ,50  AS minstake, 2500 AS maxstake 
UNION ALL 
Select 335 AS stakelevelid,2402 AS gametypeid, '1'  AS minlabel,'500' AS maxlabel ,1  AS minstake, 500 AS maxstake 
UNION ALL 
Select 336 AS stakelevelid,2402 AS gametypeid, '2'  AS minlabel,'2,500' AS maxlabel ,2  AS minstake, 2500 AS maxstake 
UNION ALL 
Select 337 AS stakelevelid,2402 AS gametypeid, '5'  AS minlabel,'5,000' AS maxlabel ,5  AS minstake, 5000 AS maxstake

UPDATE stakenew WITH(ROWLOCK,UPDLOCK)
SET stakenew.MinLabel=u.minlabel,
	stakenew.MaxLabel=u.maxlabel,
	stakenew.MinStake=u.minstake,
	stakenew.MaxStake=u.maxstake
FROM StakeLevel stakenew 
INNER JOIN #updatestake u ON stakenew.StakeLevelID=u.stakelevelid AND stakenew.GameTypeID=u.gametypeid

drop table #updatestake