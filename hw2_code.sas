ods pdf file="/home/u62995936/7350HW2/hw2_solution_output.pdf"; /*create pdf output of homework solutions*/

*** Problem 5****;
* part a;

*option1-using length call;
data chemo1;
	length Pt_Fac $20;
	infile "~/7350HW2/chemo.csv" dlm=',' dsd;
	input CASE CITY CIS_YN Resect_YN ChemoAgent Pt_Fac $;
run;

*option2-using informat call directly;
data chemo1;
	informat Pt_Fac $20.; /* you can also use informats like this instead of in mofidied list input */
	infile "~/7350HW2/chemo.csv" dlm=',' dsd;
	input CASE CITY CIS_YN Resect_YN ChemoAgent Pt_Fac $;
run;

*option3-using modified list input for pt_fac;
data chemo1;
	infile "~/7350HW2/chemo.csv" dlm=',' dsd;
	input CASE CITY CIS_YN Resect_YN ChemoAgent Pt_Fac : $20.;
run;

*option4-using attriburte and length statement;
data chemo1;
	attrib CASE CITY CIS_YN Resect_YN ChemoAgent Pt_Fac length=$20;
	infile "~/7350HW2/chemo.csv" dlm=',' dsd;
	input CASE CITY CIS_YN Resect_YN ChemoAgent Pt_Fac $;
run;

proc contents data=chemo1;
	title "Problem 5a Output";
run;

* part b;
proc import
	out=chemo2 (rename=VAR1=CASE rename=VAR2=CITY rename=VAR3=CIS_YN rename=VAR4=Resect_YN rename=VAR5=ChemoAgent rename=VAR6=Pt_Fac)
	datafile="/home/u62995936/7350HW2/chemo.csv"
	dbms=csv
	replace;
	getnames=no;
	guessingrows=max; /* note that case and pt_fac vars have long lengths so certain observations are not getting read fully. this guessingrows is similar to a length argument in proc import to ensure we are reading the full observation */
run;


proc contents data=chemo2;
	title "Problem 5b Output";
run;

*** Problem 6****;
proc import
	out=form
	datafile="/home/u62995936/7350HW2/form.xls"
	dbms=xls
	replace;
	getnames=yes;
run;

proc print data=form (obs=5);
	title "Problem 6 Output: The First Five Observations From the Form.xls Data";
run;


*** Problem 7****;

* solution 1;
libname hw2 "/home/u62995936/7350HW2";

proc contents data=hw2.sacral position;
	Title "Problem 7 Output";
run;

* different solution-then run proc contents with sacraldata data;
data sacraldat;
	set "/home/u62995936/7350HW2/sacral.sas7bdat";
run;


*** Problem 8****;

* part a;
data bp1;
	input id fname $ lname $ sbp dbp salary : comma10.;
datalines;
12345 John Smith 120 80 $12,000
23456 Jim Jones 136 74 $100,000
34567 Warren Buffet 123 62 $52,444
45678 Bo Jackson 110 70 $10,000
56789 Dennis Rodman 112 . $72,500
;
run;

proc print data=bp1;
	title "Problem 8a Output: The bp1 Dataset";
run;


* part b ;
data bp2;
	input id name & : $20. sbp dbp salary : comma10.;
datalines;
12345 John Smith  120 80 $12,000
23456 Jim Jones  136 74 $100,000
34567 Warren Buffet  123 62 $52,444
45678 Bo Jackson  110 70 $10,000
56789 Dennis Rodman  112 . $72,500
;
run;

proc print data=bp2;
	title "Problem 8b Output: The bp2 Dataset";
run;


*** Problem 9****;

data vital;
    input Height Weight Sex $ @@;		 
datalines;
67  123  F       67  143  M       69  174  M       64  127  F
61  116  F       70  159  M       71  142  M       66  146  F
61  128  F       59  139  F       65  127  F       69  172  M
64  166  M       63  120  F       69  166  M       67  152  F
62  153  F       60  152  F       66  168  M       66  155  M
71  145  M       64  164  M       72  168  M       64  123  F
64  135  F       68  158  M       63  159  M       71  177  M
65  158  M       63  169  M       60  139  F       71  177  M
65  150  F       63  145  M       62  141  F       64  118  F
64  168  M       66  151  F       68  171  M       63  158  M
63  146  M       68  149  M       66  162  M       68  144  F
61  131  F       72  179  M       62  142  F
;
run;

proc print data=vital (obs=5);
	title "Problem 9 Output: The First Five Observations of the Vital Dataset";
run;

ods pdf close;





