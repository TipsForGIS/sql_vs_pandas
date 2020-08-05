/*
Pandas equivalent:
wcities_df.shape[0]
*/
SELECT COUNT(*)
FROM world_cities;

/*
Pandas equivalent:
wcities_df[['city','country','population']].head(7)
*/
SELECT city, country, population
FROM world_cities
LIMIT 7;

/*
Pandas equivalent:
rows = wcities_df['population'] >= 3000000
columns = ['city', 'country', 'population']

wcities_df.loc[rows, columns]

#wcities_df.loc[wcities_df['population'] >= 3000000,['city','country','population']]
*/
SELECT city, country, population
FROM world_cities
WHERE population >= 3000000;

/*
Pandas equivalent:
sorted_df = wcities_df.sort_values(by='country')
pd.Series(sorted_df['country'].unique())

OR 

pd.Series(wcities_df.sort_values(by='country')['country'].unique())
*/
SELECT DISTINCT country
FROM world_cities
ORDER BY country;

/*
Pandas equivalent:
wcities_df.groupby('country')['population'].sum()
*/
SELECT country, SUM(population)
FROM world_cities
GROUP BY 1;

/*
Pandas equivalent:
join = pd.merge(left=wcities_df, right=cont_df, how='inner',
                 left_on='country', right_on='country')

ordered_join = join.sort_values(by='city')
ordered_join[['city','country','continent']]

OR

#pd.merge(left=wcities_df, right=cont_df, how='inner', left_on='country', right_on='country').sort_values(by='city')[['city','country','continent']]
*/
SELECT ci.city, ci.country, co.continent
FROM world_cities AS ci
JOIN continents AS co
ON (ci.country = co.country)
ORDER BY ci.city;

/*
GeoPandas equivalent:
istanbul_rownum = wcities_gdf[wcities_gdf['city'] == 'Istanbul'].index[0]
istanbul_pnt = wcities_gdf.loc[istanbul_rownum,'geometry']

filter_rows = wcities_gdf['geometry'].distance(istanbul_pnt) <= 7
filter_columns = ['city','country']

wcities_gdf.loc[filter_rows,filter_columns]
*/
WITH istanbul_geom AS(
	SELECT geom
	FROM world_cities
	WHERE city = 'Istanbul'
)
SELECT ci.city, ci.country
FROM world_cities as ci, istanbul_geom as ig
WHERE ST_DWithin(ci.geom, ig.geom, 7)
ORDER BY ci.city;

