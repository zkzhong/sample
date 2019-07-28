*---------------------------------------*
|      Alameda Health Consortium					|
| Community Health Center Network requested examples|
|     7/27/2019                                     |
*---------------------------------------*;


*---------------------*;



/*Data manipulation (data step and/or proc sql) */
*filter and import;

data myclass;
	set sashelp.class;
	where age >=15;
	keep name age height weight;
run;

*add new columns   simple arithmetic operations     unnessasary macro var;

data myclass;
	set work.myclass;
	format height 4.1 weight 3.;
	%let h=height;
	whratio=weight/'&h';
	indicator='1';
	format whratio 3.1;
run;

*inner join;

data myclassforjoining;
	set sashelp.classfit;
run;

proc sql;
	create table joinedtable as select * from myclass, myclassforjoining where 
		myclass.name=myclassforjoining.name order by name DESC;
	run;

proc contents data=work.joinedtable;
run;

*---------------------*;

/*Data exploration and regression*/

%let interval=Age Weight Height Neck Chest Abdomen Hip 
              Thigh Knee Ankle Biceps Forearm Wrist;
ods graphics / reset=all imagemap;

proc corr data=work.BodyFat2 plots(only)=scatter(nvar=all ellipse=none);
	var &interval;
	with PctBodyFat2;
	id Case;
	title "Correlations and Scatter Plots";
run;

%let interval=Biceps Forearm Wrist;
ods graphics / reset=all imagemap;
ods select scatterplot;

proc corr data=work.BodyFat2 plots(only)=scatter(nvar=all ellipse=none);
	var &interval;
	with PctBodyFat2;
	id Case;
	title "Correlations and Scatter Plots";
run;

proc reg data=work.bodyfat2;
	model PctBodyFat2=weight;
	run;
	*2-WAY ANOVA with cross-effect;
	ods graphics on;

proc glm data=work.drug plots(only)=intplot;
	class DrugDose Disease;
	model BloodP=DrugDose|Disease;
	lsmeans DrugDose*Disease;
	run;
quit;

ods graphics on;

proc glm data=work.drug plots(only)=intplot;
	class DrugDose Disease;
	model BloodP=DrugDose|Disease;
	lsmeans DrugDose*Disease / diff slice=Disease;

	/* Does this disease has a cross effect at all? */
	run;
quit;