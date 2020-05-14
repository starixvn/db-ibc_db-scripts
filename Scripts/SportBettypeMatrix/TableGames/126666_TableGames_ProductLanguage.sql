
USE bodb02
GO 

/*
Create : 20200331@Sophia 
Task:Update Language for RefResource of Table Game [redmineID: #132260]
DB: DBPRO.bodb02
*/

 
 
 
  UPDATE  RefResource
 SET  Resource_en = N'Table Game',
 Resource_ch = N'桌面遊戲', 
 Resource_cs = N'桌面游戏', 
 Resource_jp = N'テーブルゲーム',
 Resource_it= N'Table Game', 
 Resource_th= N'เกมกระดาน', 
 Resource_ko= N'테이블 게임', 
 Resource_es= 'Table Game', 
 Resource_el= 'Table Game', 
 Resource_vn= N'Trò chơi trên bàn', 
 Resource_pl= 'Table Game',
 Resource_id= 'Table Game', 
 Resource_hi= 'Table Game', 
 Resource_mm= 'Table Game', 
 Resource_fr= 'Table Game', 
 Resource_ru= 'Table Game',
 Resource_pt= 'Table Game', 
 Resource_de= 'Table Game'
 WHERE ResourceId = 40 and refID = 'Product'
 
 