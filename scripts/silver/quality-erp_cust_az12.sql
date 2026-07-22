select * from bronze.erp_cust_az12

--validation for CID
select 
	substring(cid, 4, len(cid)) as cid
	from bronze.erp_cust_az12

--validation for bdate
	--check future bdate
	select * from bronze.erp_cust_az12
	where bdate > GETDATE()
	--replace future bdate with null
	select *,
		case when bdate > GETDATE() then null
			else bdate
		End as bdate
	from bronze.erp_cust_az12
	where bdate > GETDATE()


--validation for gen
select distinct gen from bronze.erp_cust_az12
--replace f & female with Female and m& male with Male
select  distinct gen,
		case when upper(trim(gen)) in ('F', 'Female') then 'Female'
			 when upper(trim(gen)) in ('M', 'Male') then 'Male'
		else 'n/a'
	End as gen
From bronze.erp_cust_az12
