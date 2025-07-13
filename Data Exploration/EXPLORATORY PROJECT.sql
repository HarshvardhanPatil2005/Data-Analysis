#Harshvardhan Patil
#The Dataset of Company Layoffs was taken from kaggle.com

--------------#Exploratory Data analysis--------------------

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select * 
from layoffs_staging2
where percentage_laid_off = 1;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select substring(`date`,1,7) as `month`,sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;

with rolling_total as
(
select substring(`date`,1,7) as `month`,sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`,total_off,sum(total_off)over(order by `month`) as Rolling_T
from rolling_total;

with company_year (company,years,total_laid_off) as
(
select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
)
select *,dense_rank() over (partition by years order by total_laid_off desc) as ranking 
from company_year
where years is not null
order by ranking asc;

with company_year (company,years,total_laid_off) as
(
select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
), company_year_rank as
(
select *,dense_rank() over (partition by years order by total_laid_off desc) as ranking 
from company_year
where years is not null
)
select *
from company_year_rank
where ranking <= 5;