CREATE TABLE #updatestake (stakelevelid int, gametypeid int, minlabel varchar(50),maxlabel varchar(50),minstake decimal(19,8),maxstake decimal(19,8))
GO
INSERT INTO #updatestake
--SGD
SELECT 	352 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '5,000' AS maxlabel ,  10  AS minstake,  5000  AS maxstake
UNION ALL 	
SELECT 	353 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '8,000' AS maxlabel , 20 AS minstake, 8000 AS maxstake	
UNION ALL 
SELECT 	354 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '15,000' AS maxlabel , 50 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	355 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '1,000' AS maxlabel , 2 AS minstake, 1000 AS maxstake	
UNION ALL 
--MYR
SELECT 	356 AS stakelevelid, 2401 AS gametypeid, '25' AS minlabel, '7,000' AS maxlabel , 25 AS minstake, 7000 AS maxstake	
UNION ALL 
SELECT 	357 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '10,000' AS maxlabel , 100 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	358 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	359 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
--USD
SELECT 	360 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	361 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	362 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	363 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
--THB
SELECT 	364 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '10,000' AS maxlabel , 50 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	365 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '25,000' AS maxlabel , 250 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	366 AS stakelevelid, 2401 AS gametypeid, '1,000' AS minlabel, '50,000' AS maxlabel , 1000 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	367 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
--HKD
SELECT 	368 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,500' AS maxlabel , 10 AS minstake, 1500 AS maxstake	
UNION ALL 
SELECT 	369 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '5,000' AS maxlabel , 50 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	370 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	371 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '25,000' AS maxlabel , 500 AS minstake, 25000 AS maxstake	
UNION ALL 
--EUR
SELECT 	372 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	373 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	374 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	375 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
--AUD
SELECT 	376 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	377 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	378 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	379 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
--GBP
SELECT 	380 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	381 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	382 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	383 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
--CNY
SELECT 	384 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,500' AS maxlabel , 10 AS minstake, 1500 AS maxstake	
UNION ALL 
SELECT 	385 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '5,000' AS maxlabel , 50 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	386 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	387 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '25,000' AS maxlabel , 500 AS minstake, 25000 AS maxstake	
UNION ALL 
--IDR
SELECT 	388 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	389 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	390 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	391 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
--USD
SELECT 	392 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	393 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	394 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	395 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	396 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	397 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	398 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	399 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
--CAD
SELECT 	400 AS stakelevelid, 2401 AS gametypeid, '25,000' AS minlabel, '1,000,000' AS maxlabel , 25000 AS minstake, 1000000 AS maxstake	
UNION ALL 
SELECT 	401 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	402 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	403 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
--IDR
SELECT 	404 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	405 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	406 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	407 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
--TWD
SELECT 	408 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	409 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '10,000' AS maxlabel , 50 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	410 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '25,000' AS maxlabel , 250 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	411 AS stakelevelid, 2401 AS gametypeid, '1,000' AS minlabel, '50,000' AS maxlabel , 1000 AS minstake, 50000 AS maxstake	
UNION ALL 
--JPY
SELECT 	412 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	413 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '20,000' AS maxlabel , 100 AS minstake, 20000 AS maxstake	
UNION ALL 
SELECT 	414 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '50,000' AS maxlabel , 500 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	415 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	416 AS stakelevelid, 2401 AS gametypeid, '5,000' AS minlabel, '250,000' AS maxlabel , 5000 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	417 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '20,000' AS maxlabel , 100 AS minstake, 20000 AS maxstake	
UNION ALL 
SELECT 	418 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '50,000' AS maxlabel , 500 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	419 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
--IDR
SELECT 	420 AS stakelevelid, 2401 AS gametypeid, '5,000' AS minlabel, '250,000' AS maxlabel , 5000 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	421 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	422 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	423 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	424 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	425 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	426 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	427 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
--USD
SELECT 	428 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	429 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	430 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	431 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	432 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	433 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	434 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	435 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
--JPY
SELECT 	436 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	437 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	438 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	439 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
--USD
SELECT 	440 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	441 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	442 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	443 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
--CHF
SELECT 	444 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	445 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	446 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	447 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
--THB
SELECT 	448 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	449 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '20,000' AS maxlabel , 100 AS minstake, 20000 AS maxstake	
UNION ALL 
SELECT 	450 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '50,000' AS maxlabel , 500 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	451 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
--KRW
SELECT 	452 AS stakelevelid, 2401 AS gametypeid, '5,000' AS minlabel, '250,000' AS maxlabel , 5000 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	453 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '10,000' AS maxlabel , 50 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	454 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '25,000' AS maxlabel , 250 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	455 AS stakelevelid, 2401 AS gametypeid, '1,000' AS minlabel, '50,000' AS maxlabel , 1000 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	456 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	457 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	458 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	459 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
--IDR
SELECT 	460 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	461 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '300,000' AS maxlabel , 2500 AS minstake, 300000 AS maxstake	
UNION ALL 
SELECT 	462 AS stakelevelid, 2401 AS gametypeid, '7,500' AS minlabel, '750,000' AS maxlabel , 7500 AS minstake, 750000 AS maxstake	
UNION ALL 
SELECT 	463 AS stakelevelid, 2401 AS gametypeid, '25,000' AS minlabel, '1,000,000' AS maxlabel , 25000 AS minstake, 1000000 AS maxstake	
UNION ALL 
--BND
SELECT 	464 AS stakelevelid, 2401 AS gametypeid, '75,000' AS minlabel, '3,000,000' AS maxlabel , 75000 AS minstake, 3000000 AS maxstake	
UNION ALL 
SELECT 	465 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	466 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	467 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
--IDR
SELECT 	468 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	469 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	470 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	471 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
--ZAR
SELECT 	472 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	473 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	474 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	475 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
--MXN
SELECT 	476 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	477 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	478 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	479 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
--CAD
SELECT 	480 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	481 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	482 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	483 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
--VND
SELECT 	484 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	485 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '3,000' AS maxlabel , 20 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	486 AS stakelevelid, 2401 AS gametypeid, '70' AS minlabel, '7,500' AS maxlabel , 70 AS minstake, 7500 AS maxstake	
UNION ALL 
SELECT 	487 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
--DKK
SELECT 	488 AS stakelevelid, 2401 AS gametypeid, '750' AS minlabel, '30,000' AS maxlabel , 750 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	489 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,500' AS maxlabel , 10 AS minstake, 1500 AS maxstake	
UNION ALL 
SELECT 	490 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '5,000' AS maxlabel , 50 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	491 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
--SEK
SELECT 	492 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '25,000' AS maxlabel , 500 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	493 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,500' AS maxlabel , 10 AS minstake, 1500 AS maxstake	
UNION ALL 
SELECT 	494 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '5,000' AS maxlabel , 50 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	495 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
--NOK
SELECT 	496 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '25,000' AS maxlabel , 500 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	497 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,500' AS maxlabel , 10 AS minstake, 1500 AS maxstake	
UNION ALL 
SELECT 	498 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '5,000' AS maxlabel , 50 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	499 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
--RUB
SELECT 	500 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '25,000' AS maxlabel , 500 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	501 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '10,000' AS maxlabel , 50 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	502 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '25,000' AS maxlabel , 250 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	503 AS stakelevelid, 2401 AS gametypeid, '1,000' AS minlabel, '50,000' AS maxlabel , 1000 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	504 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	505 AS stakelevelid, 2401 AS gametypeid, '5' AS minlabel, '1,000' AS maxlabel , 5 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	506 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '2,500' AS maxlabel , 20 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	507 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	508 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	509 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '10,000' AS maxlabel , 50 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	510 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '25,000' AS maxlabel , 250 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	511 AS stakelevelid, 2401 AS gametypeid, '1,000' AS minlabel, '50,000' AS maxlabel , 1000 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	512 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	513 AS stakelevelid, 2401 AS gametypeid, '5' AS minlabel, '1,000' AS maxlabel , 5 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	514 AS stakelevelid, 2401 AS gametypeid, '20' AS minlabel, '2,500' AS maxlabel , 20 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	515 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	516 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	516 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '20,000' AS maxlabel , 100 AS minstake, 20000 AS maxstake	
UNION ALL 
SELECT 	518 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '50,000' AS maxlabel , 500 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	519 AS stakelevelid, 2401 AS gametypeid, '2,500' AS minlabel, '100,000' AS maxlabel , 2500 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	520 AS stakelevelid, 2401 AS gametypeid, '5,000' AS minlabel, '250,000' AS maxlabel , 5000 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	521 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	522 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	523 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	524 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	525 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	526 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	527 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	528 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	529 AS stakelevelid, 2401 AS gametypeid, '2' AS minlabel, '500' AS maxlabel , 2 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	530 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,000' AS maxlabel , 10 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	531 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '2,500' AS maxlabel , 50 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	532 AS stakelevelid, 2401 AS gametypeid, '100' AS minlabel, '5,000' AS maxlabel , 100 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	533 AS stakelevelid, 2401 AS gametypeid, '10' AS minlabel, '1,500' AS maxlabel , 10 AS minstake, 1500 AS maxstake	
UNION ALL 
SELECT 	534 AS stakelevelid, 2401 AS gametypeid, '50' AS minlabel, '5,000' AS maxlabel , 50 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	535 AS stakelevelid, 2401 AS gametypeid, '250' AS minlabel, '10,000' AS maxlabel , 250 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	536 AS stakelevelid, 2401 AS gametypeid, '500' AS minlabel, '25,000' AS maxlabel , 500 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	537 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	538 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	539 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	540 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '1,000' AS maxlabel , 1 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	541 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	542 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	543 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	544 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	545 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	546 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	547 AS stakelevelid, 2402 AS gametypeid, '50' AS minlabel, '50,000' AS maxlabel , 50 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	548 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	549 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	550 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	551 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	552 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	553 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	554 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	555 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	556 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	557 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	558 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	559 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	560 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	561 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	562 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	563 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	564 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	565 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	566 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	567 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	568 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	569 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	570 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	571 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	572 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	573 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '20' AS maxlabel , 10 AS minstake, 20 AS maxstake	
UNION ALL 
SELECT 	574 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	575 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	576 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	577 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	578 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	579 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	580 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	581 AS stakelevelid, 2402 AS gametypeid, '50' AS minlabel, '50,000' AS maxlabel , 50 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	582 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	583 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	584 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	585 AS stakelevelid, 2402 AS gametypeid, '250' AS minlabel, '250,000' AS maxlabel , 250 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	586 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	587 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	588 AS stakelevelid, 2402 AS gametypeid, '250' AS minlabel, '250,000' AS maxlabel , 250 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	589 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	590 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	591 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	592 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	593 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	594 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	595 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	596 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	597 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	598 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	599 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	600 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	601 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	602 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	603 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	604 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	605 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	606 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	607 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	608 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	609 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	610 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	611 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	612 AS stakelevelid, 2402 AS gametypeid, '250' AS minlabel, '250,000' AS maxlabel , 250 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	613 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	614 AS stakelevelid, 2402 AS gametypeid, '50' AS minlabel, '50,000' AS maxlabel , 50 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	615 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	616 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	617 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	618 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	619 AS stakelevelid, 2402 AS gametypeid, '300' AS minlabel, '300,000' AS maxlabel , 300 AS minstake, 300000 AS maxstake	
UNION ALL 
SELECT 	620 AS stakelevelid, 2402 AS gametypeid, '1,500' AS minlabel, '1,500,000' AS maxlabel , 1500 AS minstake, 1500000 AS maxstake	
UNION ALL 
SELECT 	621 AS stakelevelid, 2402 AS gametypeid, '3,000' AS minlabel, '3,000,000' AS maxlabel , 3000 AS minstake, 3000000 AS maxstake	
UNION ALL 
SELECT 	622 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	623 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	624 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	625 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	626 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	627 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	628 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	629 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	630 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	631 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	632 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	633 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	634 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	635 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	636 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	637 AS stakelevelid, 2402 AS gametypeid, '3' AS minlabel, '3,000' AS maxlabel , 3 AS minstake, 3000 AS maxstake	
UNION ALL 
SELECT 	638 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '15,000' AS maxlabel , 10 AS minstake, 15000 AS maxstake	
UNION ALL 
SELECT 	639 AS stakelevelid, 2402 AS gametypeid, '30' AS minlabel, '30,000' AS maxlabel , 30 AS minstake, 30000 AS maxstake	
UNION ALL 
SELECT 	640 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	641 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	642 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	643 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	644 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	645 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	646 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	647 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	648 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	649 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	650 AS stakelevelid, 2402 AS gametypeid, '50' AS minlabel, '50,000' AS maxlabel , 50 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	651 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	652 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '1,000' AS maxlabel , 1 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	653 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	654 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	655 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	656 AS stakelevelid, 2402 AS gametypeid, '50' AS minlabel, '50,000' AS maxlabel , 50 AS minstake, 50000 AS maxstake	
UNION ALL 
SELECT 	657 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	658 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '1,000' AS maxlabel , 1 AS minstake, 1000 AS maxstake	
UNION ALL 
SELECT 	659 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	660 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	661 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL 
SELECT 	662 AS stakelevelid, 2402 AS gametypeid, '100' AS minlabel, '100,000' AS maxlabel , 100 AS minstake, 100000 AS maxstake	
UNION ALL 
SELECT 	663 AS stakelevelid, 2402 AS gametypeid, '250' AS minlabel, '250,000' AS maxlabel , 250 AS minstake, 250000 AS maxstake	
UNION ALL 
SELECT 	664 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	665 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	666 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	667 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	668 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	669 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	670 AS stakelevelid, 2402 AS gametypeid, '1' AS minlabel, '500' AS maxlabel , 1 AS minstake, 500 AS maxstake	
UNION ALL 
SELECT 	671 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	672 AS stakelevelid, 2402 AS gametypeid, '5' AS minlabel, '5,000' AS maxlabel , 5 AS minstake, 5000 AS maxstake	
UNION ALL 
SELECT 	673 AS stakelevelid, 2402 AS gametypeid, '2' AS minlabel, '2,500' AS maxlabel , 2 AS minstake, 2500 AS maxstake	
UNION ALL 
SELECT 	674 AS stakelevelid, 2402 AS gametypeid, '10' AS minlabel, '10,000' AS maxlabel , 10 AS minstake, 10000 AS maxstake	
UNION ALL 
SELECT 	675 AS stakelevelid, 2402 AS gametypeid, '20' AS minlabel, '25,000' AS maxlabel , 20 AS minstake, 25000 AS maxstake	
UNION ALL
Select 676 AS stakelevelid,2401 AS gametypeid, '10' AS minlabel,'1,000' AS maxlabel ,10  AS minstake, 1000 AS maxstake 
UNION ALL 
Select 677 AS stakelevelid,2401 AS gametypeid, '100' AS minlabel,'5,000' AS maxlabel ,100 AS minstake, 5000 AS maxstake 
UNION ALL 
Select 678 AS stakelevelid,2401 AS gametypeid, '2'  AS minlabel,'500' AS maxlabel ,2  AS minstake, 500 AS maxstake 
UNION ALL 
Select 679 AS stakelevelid,2401 AS gametypeid, '50' AS minlabel,'2,500' AS maxlabel ,50  AS minstake, 2500 AS maxstake 
UNION ALL 
Select 680 AS stakelevelid,2402 AS gametypeid, '1'  AS minlabel,'500' AS maxlabel ,1  AS minstake, 500 AS maxstake 
UNION ALL 
Select 681 AS stakelevelid,2402 AS gametypeid, '2'  AS minlabel,'2,500' AS maxlabel ,2  AS minstake, 2500 AS maxstake 
UNION ALL 
Select 682 AS stakelevelid,2402 AS gametypeid, '5'  AS minlabel,'5,000' AS maxlabel ,5  AS minstake, 5000 AS maxstake

UPDATE stakenew WITH(ROWLOCK,UPDLOCK)
SET stakenew.MinLabel=u.minlabel,
	stakenew.MaxLabel=u.maxlabel,
	stakenew.MinStake=u.minstake,
	stakenew.MaxStake=u.maxstake
FROM StakeLevel stakenew 
INNER JOIN #updatestake u ON stakenew.StakeLevelID=u.stakelevelid AND stakenew.GameTypeID=u.gametypeid

drop table #updatestake