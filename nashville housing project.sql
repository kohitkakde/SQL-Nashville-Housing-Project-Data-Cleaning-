Select *
From [portfolio project ]..nashvillehousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select saledate from [portfolio project ]..nashvillehousing

alter table nashvillehousing
alter column saledate date


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From [portfolio project ]..nashvillehousing
--Where PropertyAddress is null
order by ParcelID



Select f.UniqueID ,f.UniqueID,f.ParcelID, f.PropertyAddress, s.ParcelID, s.PropertyAddress, ISNULL(f.PropertyAddress,s.PropertyAddress)
From [portfolio project ]..nashvillehousing f
JOIN [portfolio project ]..nashvillehousing s
	on f.ParcelID = s.ParcelID
	AND f.[UniqueID ] <> s.[UniqueID ]
Where f.PropertyAddress is null


Update f
SET PropertyAddress = ISNULL(f.PropertyAddress,s.PropertyAddress)
From [portfolio project ]..nashvillehousing f
JOIN [portfolio project ]..nashvillehousing s
	on f.ParcelID = s.ParcelID
	AND f.[UniqueID ] <> s.[UniqueID ]
Where f.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select *
From [portfolio project ]..nashvillehousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [portfolio project ]..nashvillehousing


ALTER TABLE [portfolio project ]..nashvillehousing
Add property_address Nvarchar(255);

Update [portfolio project ]..nashvillehousing
SET property_address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [portfolio project ]..nashvillehousing
Add property_city Nvarchar(255);

Update [portfolio project ]..nashvillehousing
SET property_city = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [portfolio project ]..nashvillehousing





Select OwnerAddress
From [portfolio project ]..nashvillehousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [portfolio project ]..nashvillehousing


ALTER TABLE [portfolio project ]..nashvillehousing
Add owner_Address Nvarchar(255);

Update [portfolio project ]..nashvillehousing
SET owner_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [portfolio project ]..nashvillehousing
Add Owner_City Nvarchar(255);

Update [portfolio project ]..nashvillehousing
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [portfolio project ]..nashvillehousing
Add Owner_State Nvarchar(255);

Update [portfolio project ]..nashvillehousing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [portfolio project ]..nashvillehousing


----------------------------------------------------------------------------------------------------------------


---------------------lets change Y and N to Yes and No  IN SoldAsVacant column


Select distinct(SoldAsVacant) , count(soldasvacant)
From [portfolio project ]..nashvillehousing
group by SoldAsVacant



select SoldAsVacant,
case when SoldAsVacant ='Y' then 'Yes'
     when SoldAsVacant ='N' then 'No'
     ELSE SoldAsVacant
end
From [portfolio project ]..nashvillehousing



update [portfolio project ]..nashvillehousing
set  SoldAsVacant = case when SoldAsVacant ='Y' then 'Yes'
                         when SoldAsVacant ='N' then 'No'
                         ELSE SoldAsVacant
	                end



------------------------------------------------------------------------------------------------------------------------------------------------------------

------remove duplicate 


with  duplicaterow  as(

Select *,
ROW_NUMBER() over(partition by parcelID , propertyaddress , saleprice ,saledate , legalreference order by uniqueID)  row_numbers 
From [portfolio project ]..nashvillehousing )

delete from duplicaterow where row_numbers > 1



-------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------delete unused column


Select *
From [portfolio project ]..nashvillehousing



alter table [portfolio project ]..nashvillehousing
drop column owneraddress , propertyaddress ,taxdistrict

alter table [portfolio project ]..nashvillehousing
drop column taxdistrict