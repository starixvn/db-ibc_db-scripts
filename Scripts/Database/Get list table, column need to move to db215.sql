/*
	Created:
	Task: Get list table, column need to move to db215 (from DB215\SQL)
*/

DECLARE @dbname VARCHAR(500) = '', @sql NVARCHAR(MAX) = ''
declare @TableNotExistInDB215 table(tableName varchar(500), utype_desc varchar(100), utype varchar(100), isTableReplicated bit)
declare @TableAndColumnNotExistInDB215 table(tableName varchar(500), colName varchar(500), utype_desc varchar(100), utype varchar(100), isTableReplicated bit
                , isColReplicated bit, system_type_id int, system_type_name varchar(100), max_len int, uprecision int, uscale int, is_nullable bit, is_identity bit)

DECLARE vendor_cursor CURSOR  
        FOR 
                select name 
                from dbsum.master.sys.databases
                where is_read_only = 0
                                and name not in ('master','msdb','tempdb','distribution','model')
                                AND state_desc = 'online'
                INTERSECT 
                select name
                from sys.databases
                where is_read_only = 0
                                and name not in ('master','msdb','tempdb','distribution','model')
                                AND state_desc = 'online'
                order by name
                        
OPEN vendor_cursor  
FETCH NEXT FROM vendor_cursor INTO @dbname

WHILE @@FETCH_STATUS = 0  
BEGIN  
        ---clear data
        delete from @TableNotExistInDB215
        delete from @TableAndColumnNotExistInDB215

        -- compare
        SET @sql =  'USE ' + @dbname + ';'
                                        + CHAR(13)
                                        +
                                'select t.name as tableName, t.type_desc, t.type, t.is_replicated isTableReplicated
                                from dbage.' + @dbname + '.sys.tables t

                                except 

                                select t.name as tableName, t.type_desc, t.type, t.is_replicated isTableReplicated
                                from ' + @dbname + '.sys.tables t
                                order by t.name'

        insert into @TableNotExistInDB215
        EXEC sp_executesql @sql

        if @@rowcount <> 0
                select @dbname + ' - Table need to copy to DB215', * from @TableNotExistInDB215

        SET @sql = 
                                'select t.name as tableName, c.name as colName, t.type_desc, t.type, t.is_replicated isTableReplicated, c.is_replicated isColReplicated, c.system_type_id, st.name,  c.max_length, c.precision, c.scale, c.is_nullable, c.is_identity
                                from dbage.' + @dbname + '.sys.tables t
                                        inner join dbage.' + @dbname + '.sys.columns c
                                                on t.object_id = c.object_id
                                        inner join dbage.' + @dbname + '.sys.types st
                                                on c.system_type_id = st.system_type_id

                                except 

                                select t.name as tableName, c.name as colName, t.type_desc, t.type, t.is_replicated isTableReplicated, c.is_replicated isColReplicated, c.system_type_id, st.name,  c.max_length, c.precision, c.scale, c.is_nullable, c.is_identity
                                from ' + @dbname + '.sys.tables t
                                        inner join ' + @dbname + '.sys.columns c
                                                on t.object_id = c.object_id
                                        inner join ' + @dbname + '.sys.types st
                                                on c.system_type_id = st.system_type_id
                                order by t.name'

        insert into @TableAndColumnNotExistInDB215
        EXEC sp_executesql @sql

        if @@rowcount <> 0
        begin
                select @dbname + ' - Columns need to copy to DB215', * from @TableAndColumnNotExistInDB215 t
                where t.tableName not in (select t.tableName from @TableNotExistInDB215)
        end

        FETCH NEXT FROM vendor_cursor INTO @dbname
END 

CLOSE vendor_cursor;  
DEALLOCATE vendor_cursor;