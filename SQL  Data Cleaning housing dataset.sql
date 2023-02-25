select *
from [Portfolio Project].dbo.[Nashville Housing]

--Date format
select SaleDateConverted,CONVERT(Date,SaleDate)
from [Portfolio Project].dbo.[Nashville Housing]

update [Nashville Housing]
SET SaleDate=CONVERT(Date,SaleDate)

ALTER TABLE [Portfolio Project].dbo.[Nashville Housing]
ADD SaleDateConverted Date;

update [Portfolio Project].dbo.[Nashville Housing]
SET SaleDateConverted=CONVERT(Date,SaleDate)

--Property Address data
select *
from [Portfolio Project].dbo.[Nashville Housing]
--where PropertyAddress is null
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project].dbo.[Nashville Housing] a
join [Portfolio Project].dbo.[Nashville Housing] b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project].dbo.[Nashville Housing] a
join [Portfolio Project].dbo.[Nashville Housing] b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking address into Address,City,State
select PropertyAddress
from [Portfolio Project].dbo.[Nashville Housing]
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS Address
from [Portfolio Project].dbo.[Nashville Housing]



ALTER TABLE [Portfolio Project].dbo.[Nashville Housing]
ADD PropertySplitAddress nvarchar(255);

update [Portfolio Project].dbo.[Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE [Portfolio Project].dbo.[Nashville Housing]
ADD PropertySplitCity nvarchar(255);

update [Portfolio Project].dbo.[Nashville Housing]
SET PropertySplitCity= SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 


select *
from [Portfolio Project].dbo.[Nashville Housing]




select OwnerAddress
from [Portfolio Project].dbo.[Nashville Housing]


select
PARSENAME(REPLACE(OwnerAddress,',' , '.'),3)
,PARSENAME(REPLACE(OwnerAddress,',' , '.'),2)
,PARSENAME(REPLACE(OwnerAddress,',' , '.'),1)
from [Portfolio Project].dbo.[Nashville Housing]


ALTER TABLE [Portfolio Project].dbo.[Nashville Housing]
ADD OwnerSplitAddress nvarchar(255);

update [Portfolio Project].dbo.[Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',' , '.'),3)


ALTER TABLE [Portfolio Project].dbo.[Nashville Housing]
ADD OwnerSplitCity nvarchar(255);

update [Portfolio Project].dbo.[Nashville Housing]
SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress,',' , '.'),2)

ALTER TABLE [Portfolio Project].dbo.[Nashville Housing]
ADD OwnerSplitState nvarchar(255);

update [Portfolio Project].dbo.[Nashville Housing]
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',' , '.'),1)


select *
from [Portfolio Project].dbo.[Nashville Housing]



--Change Y TO yes and N to no in 'sold as vacant'field
select distinct(SoldAsVacant)
from [Portfolio Project].dbo.[Nashville Housing]


select SoldAsVacant
,CASE when SoldAsVacant='y' THEN 'yes'
      when SoldAsVacant='n' THEN 'no'
	  ELSE SoldAsVacant
	  END
from [Portfolio Project].dbo.[Nashville Housing]

UPDATE [Nashville Housing]
SET SoldAsVacant = CASE when SoldAsVacant='y' THEN 'yes'
      when SoldAsVacant='n' THEN 'no'
	  ELSE SoldAsVacant
	  END



--Remove Duplicates
WITH RowNumCTE AS(
select *,
    ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				  UniqueID
				  ) row_num
from [Portfolio Project].dbo.[Nashville Housing]
--ORDER BY ParcelID
)
select *
from RowNumCTE
where row_num >1
--order by PropertyAddress


select *
from [Portfolio Project].dbo.[Nashville Housing]

--Delete unsused columns
ALTER TABLE  [Portfolio Project].dbo.[Nashville Housing]
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE  [Portfolio Project].dbo.[Nashville Housing]
DROP COLUMN saledate