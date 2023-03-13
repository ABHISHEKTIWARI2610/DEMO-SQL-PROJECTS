/*

--CLEANING DATA IN SQL QUERIES
*/
SELECT * 
FROM CLEANING..NASHVILLE

-- STANDARDIZE DATA FORMAT

SELECT SaleDate,CONVERT(DATE,SALEDATE)
FROM CLEANING..NASHVILLE

UPDATE NASHVILLE
SET SaleDate =CONVERT(DATE,SALEDATE)
-- IF IT DOESN'T UPDATE PROPERLY

ALTER TABLE NASHVILLE
ADD SALEDATECONVERTED DATE;

UPDATE NASHVILLE
SET SALEDATECONVERTED = CONVERT(DATE,SALEDATE)
 
 


--POPULATE PROPERTY ADDRESS DATA

SELECT *
FROM CLEANING..NASHVILLE
--WHERE PROPERTY IS NULL
ORDER BY ParcelID 

SELECT A.PropertyAddress,A.ParcelID,B.PropertyAddress,B.ParcelID, ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM CLEANING..NASHVILLE A
JOIN CLEANING..NASHVILLE B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM CLEANING..NASHVILLE A
JOIN CLEANING..NASHVILLE B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

-- BREAKING OUT ADDRESS  INTO INDIVIDUAL COLUMNS(ADDRESS,CITY,STATES)

SELECT PropertyAddress
FROM CLEANING..NASHVILLE
--WHERE PROPERTY IS NULL
--ORDER BY ParcelID 

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From CLEANING..NASHVILLE

ALTER TABLE NASHVILLE
ADD propertySplitAddress Nvarchar(255)

UPDATE NASHVILLE
SET  propertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NASHVILLE
ADD propertySplitcity Nvarchar(255)

UPDATE NASHVILLE
SET  propertySplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select* from CLEANING..NASHVILLE


select OwnerAddress from CLEANING..NASHVILLE



Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

From CLEANING..NASHVILLE

alter table nashville
add ownersplitaddresss nvarchar (255)

update NASHVILLE
set ownersplitaddresss = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

alter table nashville
add ownersplitcites nvarchar (255)

update NASHVILLE
set ownersplitcites = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

alter table nashville
add ownersplitstates nvarchar (255)

update NASHVILLE
set ownersplitstates = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select * from CLEANING..NASHVILLE


-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(soldasvacant), count(soldasvacant)
from CLEANING..NASHVILLE
group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From CLEANING..NASHVILLE

update NASHVILLE
set SoldAsVacant= CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

 -- Remove Duplicates

 with Rownumcte as(
 select*,
 ROW_NUMBER()over( 
 partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
				 uniqueid)  row_num

 from CLEANING..NASHVILLE
 --order by ParcelID
 )
 select *
 from Rownumcte
 where row_num >1
 --order by PropertyAddress



 -- Delete Unused Columns

 select*
 from CLEANING..NASHVILLE


 ALTER TABLE nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate,ownersplitadd,ownersplitstate,ownersplitcity,ownersplitaddress,SALEDATECONVERTED,SALEDATECONVERTEDS



