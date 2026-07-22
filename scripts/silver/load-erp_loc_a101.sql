USE [Datawarehouse]
GO

INSERT INTO [silver].[erp_loc_a101]
           ([cid]
           ,[cntry]
		   )
select 
	replace(cid,'-','') as cid, --cid
	case when Upper(trim(cntry)) = 'DE' then 'Germany'
		when Upper(trim(cntry)) in ('US','United States','USA') then 'United States'
		when trim(cntry) = '' or cntry is null then 'n/a'
		Else trim(cntry)
	End as cntry  --cntry


From bronze.[erp_loc_a101]
	

