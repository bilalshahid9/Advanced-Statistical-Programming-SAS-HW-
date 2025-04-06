ods pdf file="/home/u62995936/7350HW3/hw3 solution output.pdf";

*** Problem 1;
data bp1;
	input id fname $ lname $ sbp dbp salary : comma10.;
datalines;
12345 John Smith  120 80 $12,000
23456 Jim Jones  136 74 $100,000
34567 Warren Buffet  123 62 $52,444
45678 Bo Jackson  110 70 $10,000
56789 Dennis Rodman  112 . $72,500
;
run;

data bp2;
	set bp1;
	PP=sbp-dbp; /*part a*/
	PPPCT =(PP/sbp)*100; /*part b*/
	format PPPCT 5.2; /*part c*/
run;

proc print data=bp2;
	title 'Problem 1 Output: BP2 Dataset';
run;

*** Problem 2;

* part a;
data games;
	infile "/home/u62995936/7350HW3/Games.dat";
	input Month 1. +1 Day 2. +1 Team $19. +2 Hits 2. +1 Runs 2.; /* using format input statement here since our data has different seprators!*/
run;


* part b;

data games2;
	set games;
	retain maxruns; 
	maxruns=max(maxruns,Runs); /* create maxruns varaible */
	totalruns + runs; /* create total runs variable */
run;
	
proc print data=games2;
	title 'Problem 2 Output: Games Dataset';
run;

*** Problem 3;

* import the data;
proc import
	out=exp
	datafile="/home/u62995936/7350HW3/monthly exp.xlsx"
	dbms=xlsx
	replace;
	getnames=yes;
run;

* solution 1-using retain statement and sum function;
data exp2;
	set exp;
	retain minchg maxchg minpay maxpay;
	retain sumchg sumpay 0;
	minchg=min(charges,minchg);/*part a*/
	maxchg=max(charges,maxchg);/*part a*/
	sumchg=sum(charges,sumchg);/*part a*/
	minpay=min(payments,minpay);/*part b*/
	maxpay=max(payments,maxpay);/*part b*/
	sumpay=sum(payments,sumpay);/*part b*/

	monthupper=upcase(month); /*part c*/
run;

proc print data=exp2;
	title 'Problem 3 Output: Running Totals of Clinic Payments and Charges';
run;

* solution 2-using retain and sum statement;
data exp2;
	set exp;
	retain minchg maxchg minpay maxpay;

	minchg=min(charges,minchg); /*part a*/
	maxchg=max(charges,maxchg); /*part a*/
	sumchg + charges; /*part a*/
	minpay=min(payments,minpay); /*part b*/
	maxpay=max(payments,maxpay); /*part b*/
	sumpay + payments; /*part b*/

	monthupper=upcase(month); /*part c*/
run;


*** Problem 4;

* code from homework 2;
proc import
	out=form
	datafile="/home/u62995936/7350HW2/form.xls"
	dbms=xls
	replace;
	getnames=yes;
run;

data formnew;
	set form;
	formdate=mdy(mon,day,yr); /*part a*/
	datestamp=datepart(time_stamp); /*part b*/
run;

proc print data=formnew (obs=5);
	title 'Problem 4 Output: First 5 rows of FORM dataset';
run;

data formatednew;
	set form;
	formdate=mdy(mon,day,yr); /*part a*/
	datestamp=datepart(time_stamp); /*part b*/
	format formdate datestamp date9.; /*part c*/
run;

proc print data=formatednew (obs=10);
	title 'Problem 4 Output: First 10 rows of Formatted FORM dataset';
run;


*** Problem 5;

libname hw "/home/u62995936/7350HW2/";

data age20;
	set hw.patdata (where=(20<=age<30)); /* part a */

	if drinks=1 then do; /* part b */
			if smokes in (2,3) then smokedrink=4;
			else smokedrink=3;
	end;
	else do;
		if smokes in (2,3) then smokedrink=2;
		else smokedrink=1;
	end;

	roundaer=round(aer); /* part d */
	roundhbael=round(hbael); /* part d */
run;

* part c;
proc format;
   value smokedrinkformat
      1='no smoke no drink'
      2='smoke no drink'
      3='drink no smoke'
      4='smoke and drink';
run;

proc print data=age20 (obs=10);
	var patient age smokes drinks smokedrink aer roundaer hbael roundhbael;
	title 'Problem 5 Output: First 10 rows of new version of PATDATA dataset';
	format smokedrink smokedrinkformat.; /* part c */
run;

* Alternative (More straightforward coding, but less efficient) form;
data age20;
	set hw.patdata (where=(20<=age<30));

	if drinks=0 and smokes=1 then smokedrink=1;
		else if drinks=0 and smokes in (2,3) then smokedrink=2;
		else if drinks=1 and smokes=1 then smokedrink=3;
		else smokedrink=4;

	roundaer=round(aer);
	roundhbael=round(hbael);
run;

*** Problem 9;
data dat;
  array new(20) x1-x20;
  do i = 1 to dim(new);
    do k=1 to i;
      new[k]=sum(new[k],1);
    end;
    output;
  end;
  drop i k;
run;

ods pdf close;






