ods pdf file="/home/u62995936/7350HW4/hw4 solution output.pdf";

*** Problem 1;

* part a;
data baseball;
	infile "/home/u62995936/7350HW4/baseballroster.txt";
	input Name $15. +3 Height_Ft 1. +1 Height_In 2. +1 Weight 3. +2 Position $10. +1 TeamYrs 1. +1 DOB mmddyy8. +1 DateJoin mmddyy8.; /* using format input statement */
run;

* part b;
data baseball2;
	set baseball;
	Weight_kg=Weight*0.45359237; /* b.1 */
	Height_total_in=(Height_Ft*12) + Height_In; /* first create a height variable that is a player's height in inches */
	Height_m=Height_total_in*0.0254; /* b.2 */
	drop Height_total_in;
	
	/* b.3 */
	if position="Catcher" then weight_plusequip=Weight + 10;
		else if position="Pitcher" or position="Infielder" then weight_plusequip=Weight + 2;
		else weight_plusequip=Weight + 2.5;
	
	age=int(yrdif(DOB, today(), 'AGE')); /* b.4 */
run;

proc print data=baseball2;
	title "Problem 1b Output";
run;

* part c;
proc sort data=baseball2 out=baseballsorted;
	by position descending TeamYrs;
	format DOB WEEKDATE. DateJoin WEEKDATE.;
run;

proc print data=baseballsorted;
	title "Problem 1c Output";
run;

* part d;
proc means data=baseball mean std;
	var Weight;
	title "Problem 1d Output";
run;
	
* part 3;
proc means data=baseball mean std;
	class Position;
	var Weight;
	title "Problem 1e Output";
run;
	
*** Problem 2;

* part a;
data duncan;
	infile "/home/u62995936/7350HW4/cake_data_duncan.txt";
	input Flavor $12. +1 Height 4.1;
run;

data betty;
	infile "/home/u62995936/7350HW4/cake_data_betty.txt";
	input Flavor $12. +1 Height 4.1;
run;

* part b;
data duncan;
	set duncan;
	Brand="Duncan";
run;

data betty;
	set betty;
	Brand="Betty";
run;

* part c;
data cakeset;
	set duncan betty;
run;

proc print data=cakeset;
	title "Problem 2c Output";
run;


* part d;
proc means data=cakeset mean std;
	class flavor;
	var height;
	title "Problem 2e Output";
	output out=cakemeandat mean= std= / autoname;
run;

* part e;
proc sort data=cakeset;
	by flavor;
run;

proc sort data=cakemeandat(firstobs=2 obs=4 drop=_type_ _freq_);
	by flavor;
run;

data cakemerge;
	merge cakeset cakemeandat;
	by flavor;
run;


proc sort data=cakemerge out=cakemergesort;
	by flavor;
run;

proc print data=cakemergesort;
	title "Problem 2e Output";
run;


*** 
Quesiton 3;

** part a;
libname hw4 "/home/u62995936/7350HW4";

* Sort each of the datasets by ID;
proc sort data=hw4.weight out=weight;
	by id;
run;

proc sort data=hw4.w1 out=w1;
	by id;
run;

proc sort data=hw4.w2 out=w2;
	by id;
run;

* 3a.1: Transpose data to get one row per ID (long to wide);
proc transpose data=weight prefix=WeightMes out=wgtmn (drop=_NAME_);
	by ID;
	var weight;
run;

proc print data=wgtmn(obs=5);
	title "Problem 3a.1 Output";
run;

* 3a.2 calculate mean weight value per ID; 
data wgtmn; 
	set wgtmn;
	wgt2=mean(of weightmes1-weightmes3); /* average of wave2 weight */
	keep id wgt2;
run;

proc print data=wgtmn(obs=5);
	title "Problem 3a.2 Output";
run;

** part b;

* Merge weight mean in with the Wave 2 data;
data w2;
	merge w2 (in=left) wgtmn;
	by id;
	if left;
run;

proc print data=w2(obs=5);
	title "Problem 3c Output";
	var id wgt2 Frequency;
run;

** part c and d;



* Merge the Wave 1 and Wave 2 datasets, keep only the subjects in both datasets, and 
  calculate some difference variables;
data w1w2;
	merge w1 (in=left) w2 (in=right rename=(auascore=auascore2 assessdate=assessdate2 dob=dob2)); /* need to rename variables that have the same name across datasets */
	by id;
	if left and right;	
	age=int(yrdif(dob, assessdate, 'AGE'));
	age2=int(yrdif(dob2, assessdate2, 'AGE'));
	auascorediff=auascore2-auascore;
	if wt_lb ne 0 and wgt2 ne 0 then wgtdiff=wgt2-wt_lb;
	if dob=dob2 then agediff=age2-age;
run;

* Calculate the number of non-missing and missing values, mean, and median for the AUA Score, BMI, and Age differences;
proc means data=w1w2 n nmiss mean median;
	var agediff wgtdiff auascorediff;
	title 'Problem 3d Output: Differences in Age, BMI, and AUA Score between Waves 1 and 2';
run;

*** Problem 4;

* part a;
proc means data=hw4.patdata mean median;
	var age;
	title 'Mean and median Age';
run;

* part b;
proc means data=hw4.patdata median;
	class sex;
	var aer;
	title 'Median AER by Gender';
run;

* part c;
proc freq data=hw4.patdata;
	tables sex;
	title 'Number of Subjects of each Gender';
run;

*** Problem 5;

* What is the age range in the dataset - needed to know how to make a decade format;
proc univariate data=hw4.patdata;
	var age;
	title 'Checking for age range'; /* Age range is 13-39 */
run;

* Create an age format for decades covering 13-39 - super fast to just use a format!;
proc format;
	value agegp
		Low-<20='<20'
		20-<30='20-30'
		30-High='30+';
run;

data patdataage;
	set hw4.patdata;
	format age agegp.;
run;
	
* create boxplot;
proc sgplot data=patdataage;
    vbox ldl / category=age fillattrs=(color=pink)
   	outlierattrs=(color=black);
	title "Distribution of LDL by Age Decade";
	xaxis label = "Age Decade (Yrs)";
run;
quit;

*** Problem 6;
proc import
	out=carprice
	datafile="/home/u62995936/7350HW4/carprice.csv"
	dbms=csv
	replace; 
	getnames=yes;
	guessingrows=max;
run;

*part a;
ods graphics / reset;
proc sgplot data=carprice;
	vbar manufacturer / fillattrs=(color=pink) outlineattrs=(color=green)
		datalabel;
	title "Distribution of Car Manufacturers";
	xaxis label="Manufacturer";
run;
quit;

*part b;
ods graphics / reset;
proc sgplot data=carprice;
	vbar fuel_type /  group=gear_box_type groupdisplay=cluster;
	title "Distribution of Gear Box Type by Fuel Type";
	keylegend / title="Gear Box Type";
	xaxis label="Fuel Type";
run;
quit;

*part c;
ods graphics / reset;
proc sgplot data=carprice noautolegend;
	styleattrs datacolors=(beige black blue brown str gold green gray orange pink purple red silver skyblue white yellow);
	hbar color / group=color outlineattrs=(color=black);
	title "Distribution of Car Colors";
run;
quit;


*** Problem 7;

* part a;
data tomhs2;
	set hw4.tomhs;
	keep ptid age sex marital wtbl wt6 sbpbl sbp6 ;
run;

* part b;
data tohms2;
	set tomhs2;
	wtdif = wt6 - wtbl;
	sbpdif = sbp6  - sbpbl;
run;

* part c;
proc means data=tohms2 mean nmiss N;
	Label sbpdif = 'Change in systolic blood pressure'
		  wtdif = 'Change in weight';
	var sbpdif wtdif;
run;

* part d;
title 'Distribution of change in systolic blood pressure';
proc sgplot data=tohms2;
  histogram sbpdif;
  density sbpdif / lineattrs=(color=red); /*overlays normal curve */
  xaxis label="Change in Systolic Blood Pressure";
  keylegend / location=inside position=topright across=1 noborder;
run;
quit;

* part e;
proc means data=tohms2 mean;
	class sex;
	var sbpdif wtdif;
run;

* part f;
proc sgplot data=tohms2;
   	vbox sbpdif / category=sex fillattrs=(color=pink)
   		outlierattrs=(color=black);
	title "Distribution of Change in SBP by Sex";
	yaxis label="Change in SBP";
run;
quit;

proc sgplot data=tohms2;
   	vbox wtdif / category=sex fillattrs=(color=blue)
   		outlierattrs=(color=black);
	title "Distribution of Change in Weight by Sex";
	yaxis label="Change in Weight";
run;
quit;

* part g;
proc corr data=tohms2 pearson plots=matrix(histogram);
	var sbpdif wtdif;
run;
	
* part h;
proc reg data=tohms2;
	model sbpdif = wtdif;
run;

* part i;
proc univariate data=tohms2;
	var wtdif;
run;

* part j;
proc freq data=tohms2;
	table marital*sex;
run;

* part k;
ods graphics / reset;
proc sgplot data=tohms2;
	vbar marital;
	title "Distribution of Marital Status";
	xaxis values=(1 2 3 4 5) valuesdisplay=("Never Married" "Separated" "Divorced" "Widowed" "Married") valueattrs=(color=blue)
		label="Marital Status" labelattrs=(family="Arial Black");
run;
quit;	

ods pdf close;