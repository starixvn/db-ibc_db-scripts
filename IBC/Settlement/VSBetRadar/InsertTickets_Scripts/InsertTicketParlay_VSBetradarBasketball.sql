EXEC DBA_ComboParlayIns_2 
@Matchid = 80001037 ,
@numberofmatch = 3,
@BettypeBetteam= '<root>
						<r bettype= "2801" betteam="h,a" hdp1="" betcheck=""/>
						<r bettype= "2802" betteam="1,x,2" hdp1="" betcheck=""/>
						<r bettype= "2803" betteam="o,u" hdp1="1" betcheck=""/>
						<r bettype= "2804" betteam="o,u" hdp1="2" betcheck=""/>
						<r bettype= "2805" betteam="h,a" hdp1="1" hdp2="2" betcheck=""/>
						<r bettype= "2806" betteam="h,a" hdp1="0" hdp2="1" betcheck=""/>
						<r bettype= "2807" betteam="H1-5,H6-10,H11+,A1-5,A6-10,A11+" hdp1="" betcheck=""/>
						<r bettype= "2808" betteam="H1-5,H6-10,H11+,D,A1-5,A6-10,A11+" hdp1="" betcheck=""/>
						<r bettype= "2809" betteam="h,a" hdp1="" betcheck="820"/>
						<r bettype= "2809" betteam="h,a" hdp1="" betcheck="840"/>
						<r bettype= "2809" betteam="h,a" hdp1="" betcheck="860"/>
						<r bettype= "2811" betteam="o,u" hdp1="2" betcheck=""/>
						<r bettype= "2812" betteam="o,u" hdp1="1" betcheck=""/>
					</root>'  
,@oddsValue= 1.89
,@apt = 0.4
,@mpt = 0.3
,@spt = 0.2
,@playerdc = 0.005
,@dc = 0.001
,@adc = 0.002
,@sdc = 0.003
,@Double = 22 , @Trebles = 0 , @4fold=0, @5fold =0 , @6fold =0 , @7fold=0,@8fold=0,@9fold=0,@10fold=0,@11fold=0,@12fold=0,@13fold=0,@14fold=0,@15fold=0,@16fold=0,@17fold=0,@18fold=0,@19fold=0,@20fold=0, 
@fullsystemparlay = 0, @Lucky = 0, 
@mixparlay  = 0 -- For mixparlay (>20 matches)

declare @matchid INT = 80001037 
select * from bettransm (nolock) where matchid = @Matchid

select b.refno,b.matchid,b.bettype, bm.bettype,bm.betcheck,bm.betteam 
from bettrans b (nolock)
	inner join bettransm bm (nolock) on b.refno = bm.refno
where bm.matchid = @Matchid

update b
	set matchid = 2799, bettype = 2799
from bettransm bm (nolock)
	inner join match m (nolock) on bm.matchid = m.matchid and sporttype = 193
	inner join bettrans b (nolock) on b.refno = bm.refno
where m.matchid = @matchid and b.matchid = 29 and b.bettype = 29