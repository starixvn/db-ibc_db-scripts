/*<info serverAlias="DBTXN-bodb02" step="1"></info>*/
Use bodb02

/*
Create: 2020916@Sophia
DB : DBTXN-bodb02
Task: Add Column OriginalOdds for BettransInfo [Redmine: #140906]

*/


ALTER TABLE [BettransInfo]
ADD OriginalOdds smallmoney NULL


ALTER TABLE [BettransInfo14]
ADD OriginalOdds smallmoney NULL