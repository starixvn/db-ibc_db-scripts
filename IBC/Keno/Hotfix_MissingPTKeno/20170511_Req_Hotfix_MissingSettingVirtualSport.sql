/*
	Created: 20170511@Elodie
	Task: Virtual Sport - Missing data of sport 182, 184 - [Redmine: 76020]

*/
USE CustDB
GO

INSERT INTO dbo.CustSetting3rd
        ( custid ,
          bettype ,
          sporttype ,
          apositiontaking ,
          mpositiontaking ,
          spositiontaking ,
          playerdiscount ,
          discount ,
          adiscount ,
          sdiscount ,
          minbet ,
          maxbet ,
          autopositiontaking ,
          isautopositiontaking ,
          autompositiontaking ,
          isautompositiontaking ,
          alivepositiontaking ,
          mlivepositiontaking ,
          slivepositiontaking ,
          autolivepositiontaking ,
          isautolivepositiontaking ,
          autolivempositiontaking ,
          isautolivempositiontaking
        )
SELECT	custid ,
        1231 AS bettype,
        s.sporttype,
        apositiontaking ,
        mpositiontaking ,
        spositiontaking ,
        playerdiscount ,
        discount ,
        adiscount ,
        sdiscount ,
        minbet ,
        maxbet ,
        autopositiontaking ,
        isautopositiontaking ,
        autompositiontaking ,
        isautompositiontaking ,
        alivepositiontaking ,
        mlivepositiontaking ,
        slivepositiontaking ,
        autolivepositiontaking ,
        isautolivepositiontaking ,
        autolivempositiontaking ,
        isautolivempositiontaking
FROM dbo.custSetting3rd cs WITH (NOLOCK)
	CROSS JOIN (SELECT 182 AS Sporttype UNION ALL SELECT 184) s
WHERE custid IN (13090490,13090791,13094705,13091063)
	AND cs.sporttype = 180 AND bettype = 1201
