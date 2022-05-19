/* Outlier for population */

data total_population;
    set co2_data.sheet1;
    where series_code = 'SP.POP.TOTL';
    population_total = total_value;
run;

proc sgplot data=total_population;
    vbox population_total;
    title "Outlier for population series data";
run;


/* Outlier for CO2 emission */

data co2_emission;
    set co2_data.sheet1;
    where series_code = 'EN.ATM.CO2E.KT';
    co2_emission_total = total_value;
run;

proc sgplot data=co2_emission;
    vbox co2_emission_total;
    title "Outlier for co2 emission series data";
run;



/* Outlier for CO2 emission from transport */

data co2_emission_transport;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.TRAN.ZS';
    co2_transpot_total = total_value;
run;

proc sgplot data=co2_emission_transport;
    vbox co2_transpot_total;
    title "Outlier for co2 emission transport series data";
run;


/* making a sas library of our work excel file*/
libname co2_data xlsx 'C:\Users\julhas\Desktop\university-of-salford\trimester 1\PODS\CourseWork\sas_work\cleaned_data_co2.xlsx';



/* ------ comprehensive descriptive statistical analysis (e.g., 
Mean, Median, Mode, Standard
deviation, Skewness and Kurtosis) -------------------------->*/
data all_data;
    set co2_data.sheet1;
run;

proc univariate data=all_data;
    var total_value;
    title "comprehensive analysis using total value of our dataset";
run;



data total_population;
    set co2_data.sheet1;
    where series_code = 'SP.POP.TOTL';
population = total_value;
run;

data co2_emission_data;
    set co2_data.sheet1;
    where series_code = 'EN.ATM.CO2E.KT';
    co2_emission = total_value;
run;

data co2_emission_transport;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.TRAN.ZS';
    co2_transpot = total_value;
run;

data co2_emission_electricity;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.ETOT.ZS';
    co2_electric = total_value;
run;

data co2_emission_manufacture;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.MANF.ZS';
    co2_manufacture = total_value;
run;

data co2_emission_gaseous_fuel;
    set co2_data.sheet1;
    where series_code = 'EN.ATM.CO2E.GF.ZS';
    co2_gaseous = total_value;
run;

data co2_emission_liquid_fuel;
    set co2_data.sheet1;
    where series_code = 'EN.ATM.CO2E.LF.ZS';
    co2_liquid = total_value;
run;

data co2_emission_solid_fuel;
    set co2_data.sheet1;
    where series_code = 'EN.ATM.CO2E.LF.ZS';
    co2_solid = total_value;
run;

data co2_emission_building;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.BLDG.ZS';
    co2_building = total_value;
run;

data co2_other_sector;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.OTHX.ZS';
    co2_other = total_value;
run;

data compre_data;
    merge total_population co2_emission_data 
    co2_emission_transport 
    co2_emission_electricity co2_emission_manufacture 
    gdp_growth_data
    co2_emission_gaseous_fuel co2_emission_liquid_fuel 
    co2_emission_solid_fuel
    co2_emission_building co2_other_sector;
run;

%let interval=co2_emission co2_transpot co2_electric
              co2_manufacture co2_gaseous co2_liquid co2_solid
              co2_building co2_other;
options nolabel;

proc sgscatter data=compre_data;
    plot population*(&interval) / reg;
    title "Associations of Interval Variables with Population";
run;




/*-----------------correlation analysis ------------------>*/
data total_population;
    set co2_data.sheet1;
    where series_code = 'SP.POP.TOTL';
    population = total_value;
run;

data co2_emission_data;
    set co2_data.sheet1;
    where series_code = 'EN.ATM.CO2E.KT';
    co2_emission = total_value;
run;

data co2_emission_transport;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.TRAN.ZS';
    co2_transpot = total_value;
run;

data co2_emission_electricity;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.ETOT.ZS';
    co2_electric = total_value;
run;

data co2_emission_manufacture;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.MANF.ZS';
    co2_manufacture = total_value;
run;

data co2_emission_gaseous_fuel;
    set co2_data.sheet1;
    where series_code = 'EN.ATM.CO2E.GF.ZS';
    co2_gaseous = total_value;
run;

data co2_emission_liquid_fuel;
    set co2_data.sheet1;
    where series_code = 'EN.ATM.CO2E.LF.ZS';
    co2_liquid = total_value;
run;

data co2_emission_solid_fuel;
    set co2_data.sheet1;
    where series_code = 'EN.ATM.CO2E.SF.ZS';
    co2_solid = total_value;
run;

data co2_emission_building;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.BLDG.ZS';
    co2_building = total_value;
run;

data co2_other_sector;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.OTHX.ZS';
    co2_other = total_value;
run;

data corr_table;
    merge total_population co2_emission_data 
    co2_emission_transport 
    co2_emission_electricity co2_emission_manufacture 
    gdp_growth_data
    co2_emission_gaseous_fuel co2_emission_liquid_fuel 
    co2_emission_solid_fuel
    co2_emission_building co2_other_sector;
run;

%let interval=co2_emission co2_transpot co2_electric
co2_manufacture co2_gaseous co2_liquid co2_solid
co2_building co2_other;
ods graphics / reset=all imagemap;

proc corr data=corr_table rank
    plots(only)=scatter(nvar=all ellipse=none);
    var &interval;
    with population;
    title "Correlations and Scatter Plots With Population,
    CO2 Emission,CO2 transport, CO2 electricity, 
    CO2 manufacture, CO2 gaseous, CO2 liquid, CO2 solid, 
    CO2 building, CO2 other";
run;

title;

/*---------------------regression analysis ------------------>*/
data total_population;
    set co2_data.sheet1;
    where series_code = 'SP.POP.TOTL';
    population = total_value;
run;

data co2_emission_data;
    set co2_data.sheet1;
    where series_code = 'EN.ATM.CO2E.KT';
    co2_emission = total_value;
run;

data co2_emission_transport;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.TRAN.ZS';
    co2_transpot = total_value;
run;

data co2_emission_electricity;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.ETOT.ZS';
    co2_electric = total_value;
run;

data co2_emission_manufacture;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.MANF.ZS';
    co2_manufacture = total_value;
run;

data co2_emission_gaseous_fuel;
    set co2_data.sheet1;
    where series_code = 'EN.ATM.CO2E.GF.ZS';
    co2_gaseous = total_value;
run;

data co2_emission_liquid_fuel;
    set co2_data.sheet1;
    where series_code = 'EN.ATM.CO2E.LF.ZS';
    co2_liquid = total_value;
run;

data co2_emission_solid_fuel;
    set co2_data.sheet1;
    where series_code = 'EN.ATM.CO2E.SF.ZS';
    co2_solid = total_value;
run;

data co2_emission_building;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.BLDG.ZS';
    co2_building = total_value;
run;

data co2_other_sector;
    set co2_data.sheet1;
    where series_code = 'EN.CO2.OTHX.ZS';
    co2_other = total_value;
run;

data regre_table;
    merge total_population co2_emission_data 
    co2_emission_transport 
    co2_emission_electricity co2_emission_manufacture 
    gdp_growth_data
    co2_emission_gaseous_fuel co2_emission_liquid_fuel 
    co2_emission_solid_fuel
    co2_emission_building co2_other_sector;
run;

ods graphics;
proc reg data=regre_table;
    model co2_emission=population;
    model co2_transpot=population;
    model co2_electric=population;
    model co2_manufacture=population;
    model co2_gaseous=population;
    model co2_liquid=population;
    model co2_solid=population;
    model co2_building=population;
    model co2_other=population;
    title "Simple Regression with population as Regressor";
run;
quit;


