
INSERT INTO [silver].[erp_cust_az12]
           ([cid]
           ,[bdate]
           ,[gen]
)
select 
	substring(cid, 4, len(cid)) as cid, --cid
	case when bdate > GETDATE() then null
			else bdate
		End as bdate,  --bdate
	case when upper(trim(gen)) in ('F', 'Female') then 'Female'
			 when upper(trim(gen)) in ('M', 'Male') then 'Male'
		else 'n/a'
	End as gen --gen
From bronze.erp_cust_az12


