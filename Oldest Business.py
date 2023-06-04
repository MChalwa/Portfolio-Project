#!/usr/bin/env python
# coding: utf-8

# # 1.Oldest Business in the World.

# In[5]:


import pandas as pd
businesses = pd.read_csv("desktop/datasets/businesses.csv")
#Sorting business from oldest to youngest
sorted_businesses = businesses.sort_values('year_founded',ascending=True)
sorted_businesses.head()


# Kongō Gumi is the world's oldest continuously operating business founded in 578 in Japan, beating out the second oldest business by well over 100 years.

# # 2.Oldest Business in North America.

# In[12]:


#Loading countries dataset
countries = pd.read_csv("desktop/datasets/countries.csv")
#Merge sorted_businesses with country
businesses_countries = sorted_businesses.merge(countries,on="country_code")
businesses_countries.head()


# In[6]:


#Filtering for countries in North America only
north_america = businesses_countries[businesses_countries["continent"]=="North America"]
north_america.head()


# Now we can see that the oldest company in North America is La Casa de Moneda de México, founded in 1534.

# # 3.Oldest Business in each Continent.

# In[7]:


# Create continent, which lists only the continent and oldest year_founded
continent = businesses_countries.groupby('continent').agg({'year_founded':'min'})

# Merge continent with businesses_countries
merged_continent = continent.merge(businesses_countries,on=['continent','year_founded'])

# Subset continent so that only the four columns of interest are included
subset_merged_continent = merged_continent[['continent','country','business','year_founded']]
subset_merged_continent


# # 4.Unknown Old Businesses.

# Lets find out which country does not have a known oldest business.

# In[10]:


# Use .merge() to create a DataFrame, all_countries
all_countries = businesses.merge(countries, on="country_code", how="right",  indicator=True)
all_countries.head()


# In[8]:


# Filter to include only countries without oldest businesses
missing_countries = all_countries[all_countries["_merge"] != "both"]

# Create a series of the country names with missing oldest business data
missing_countries_series = missing_countries["country"]

# Display the series
missing_countries_series


# # 5.Adding New Oldest Business Data

# In[13]:


# Import new_businesses.csv
new_businesses = pd.read_csv("desktop/datasets/new_businesses.csv")

# Add the data in new_businesses to the existing businesses
all_businesses = pd.concat([new_businesses,businesses])

# Merge and filter to find countries with missing business data
new_all_countries = all_businesses.merge(countries,on="country_code",how="outer",indicator =True)
new_missing_countries = new_all_countries[new_all_countries["_merge"] !="both"]

# Group by continent and create a "count_missing" column
count_missing = new_missing_countries.groupby("continent").agg({"country":"count"})
count_missing.columns = ["count_missing"]
count_missing


# # 6.Oldest Industries.

# In[14]:


# Import categories.csv and merge to businesses
categories = pd.read_csv("desktop/datasets/categories.csv")
businesses_categories = businesses.merge(categories,on='category_code')
businesses_categories.head()


# In[18]:


# Create a DataFrame which lists the number of oldest businesses in each category
count_business_cats = businesses_categories.groupby('category').agg({'business':'count'})

# Create a DataFrame which lists the cumulative years businesses from each category have been operating
years_business_cats = businesses_categories.groupby("category").agg({'year_founded':'sum'})

# Rename columns and display the first five rows of both DataFrames
count_business_cats.columns = ['count']
years_business_cats.columns = ['total_years_in_business']
display(count_business_cats.head())


# In[17]:


years_business_cats.columns = ['total_years_in_business']
display( years_business_cats.head())


# Agriculture is the oldest industry in the business world having a total of 10669 years in business.

# # 7.Restaurant Representation.

# Which restaurants in our dataset have been around since before the year 1800?

# In[19]:


# Filter using .query() for CAT4 businesses founded before 1800; sort results
old_restaurants = businesses_categories.query('year_founded < 1800 and category_code == "CAT4"')

# Sort the DataFrame
old_restaurants = old_restaurants.sort_values("year_founded")
old_restaurants


# St. Peter Stifts Kulinarium is the oldest restaurant having been established in 803.

# # 8.Categories and Continents.

# Let's finish by looking at the oldest business in each category for each continent.

# In[20]:


# Merge all businesses, countries, and categories together
businesses_categories_countries = businesses_categories.merge(countries, on="country_code")

# Sort businesses_categories_countries from oldest to most recent
businesses_categories_countries = businesses_categories_countries.sort_values("year_founded")

# Create the oldest by continent and category DataFrame
oldest_by_continent_category = businesses_categories_countries.groupby(["continent", "category"]).agg({"year_founded":"min"})
oldest_by_continent_category.head()


# In[ ]:




