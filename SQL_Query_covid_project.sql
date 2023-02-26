
-- changing datatype in total_deaths column

alter table covid_deaths
alter column total_deaths float;

-- looking at countries with the highest death rate (death cases compared to all cases) 

select location, 
max(total_cases) as 'total_cases_per_country', 
max(total_deaths) as 'total_deaths_per_country',
round(max(total_deaths) / max(total_cases), 4) * 100 as 'death_rate_per_country(%)'
from covid_deaths
group by location
order by 'death_rate_per_country(%)' desc;


-- looking at countries with the highest rate of cases compared to population 

select location, 
population,
max(total_cases) as 'total_cases_per_country',
round((max(total_cases) / population), 4) * 100 as 'cases_rate_per_country(%)'
from covid_deaths
group by location, population 
order by 'cases_rate_per_country(%)' desc;

-- vaccinated people compared to whole population of the country

select dth.location,
dth.population,
max(vac.people_vaccinated) as 'vaccinated_people',
round(max(vac.people_vaccinated) / dth.population, 4) * 100 as 'vaccination_rate_per_country'
from covid_deaths as dth
join covid_vaccinations as vac
on dth.location=vac.location and dth.date = vac.date 
group by dth.location, dth.population
order by 'vaccination_rate_per_country' desc

-- calculating number of new vaccinations per each day based on total vaccinations (excluding days without new vaccinations)

select location,
date,
convert(int, total_vaccinations) - lag(convert(int, total_vaccinations)) over (partition by location order by location) 
as 'new_vaccinations',
total_vaccinations
from covid_vaccinations
where total_vaccinations is not null AND total_vaccinations <>0

-- 