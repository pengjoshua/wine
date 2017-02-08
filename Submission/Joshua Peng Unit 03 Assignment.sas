* Loading in data;
data train; set wine;
data test; set wine_test;
proc contents data=train; run;
* Adding new variables;
data train; set train;
	BoundSulfurDioxide = TotalSulfurDioxide - FreeSulfurDioxide;
	TotalAcidity = FixedAcidity + VolatileAcidity;
run;
* Boxplots of continuous variables;
proc sgplot data=train;
  vbox alcohol / group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
  proc sgplot data=train;
  vbox chlorides / group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
  proc sgplot data=train;
  vbox freesulfurdioxide / group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
  proc sgplot data=train;
  vbox residualsugar / group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
  proc sgplot data=train;
  vbox sulphates / group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
  proc sgplot data=train;
  vbox totalsulfurdioxide / group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
  proc sgplot data=train;
  vbox ph / group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;
* Examining descriptive statistics;
proc means data=train n nmiss mean var range min max;
    var acidindex alcohol chlorides citricacid density fixedacidity freesulfurdioxide labelappeal 
		residualsugar stars sulphates totalsulfurdioxide volatileacidity ph target;
run;
* Examining descriptive statistics;
proc means data=train0 n nmiss mean var range min max;
    var acidindex alcohol chlorides citricacid density fixedacidity freesulfurdioxide labelappeal 
		residualsugar stars sulphates totalsulfurdioxide volatileacidity ph target 
		boundsulfurdioxide boundsulfurdioxide2 totalacidity;
run;
* Checking new variables;
proc means data=train n nmiss mean var range min max;
    var boundsulfurdioxide freesulfurdioxide totalsulfurdioxide totalacidity fixedacidity volatileacidity;
run;
* Imputing missing observations with mean value;
data train0; set train;
	* Initializing new variables;
	Sulfites = Sulphates;
	BoundSulfurDioxide = TotalSulfurDioxide - FreeSulfurDioxide;
	TotalAcidity = FixedAcidity + VolatileAcidity;
    i_alcohol = 0;
    if missing(alcohol) then do;
        alcohol = 10.4892363;
        i_alcohol = 1;
    end;
	i_boundsulfurdioxide = 0;
	if missing(boundsulfurdioxide) then do;
        boundsulfurdioxide = 89.6924079;
        i_boundsulfurdioxide = 1;
    end;
    i_chlorides = 0;
    if missing(chlorides) then do;
        chlorides = 0.0548225;
        i_chlorides = 1;
    end;
    i_freesulfurdioxide = 0;
    if missing(freesulfurdioxide) then do;
        freesulfurdioxide = 30.8455713;
        i_freesulfurdioxide = 1;
    end;
    i_residualsugar = 0;
    if missing(residualsugar) then do;
        residualsugar = 5.4187331;
        i_residualsugar = 1;
    end;
    STARS0 = stars;
    i_stars = 0;
    if missing(stars) then do;
        stars = 2.0;
		stars0 = 0;
        i_stars = 1;
    end;
    i_sulfites = 0;
    if missing(sulfites) then do;
        sulfites = 0.5271118;
        i_sulfites = 1;
    end;
    i_totalsulfurdioxide = 0;
    if missing(totalsulfurdioxide) then do;
        totalsulfurdioxide = 120.7142326;
        i_totalsulfurdioxide = 1;
    end;
    i_ph = 0;
    if missing(ph) then do;
        ph = 3.2076282;
        i_ph = 1;
    end;
	BoundSulfurDioxide2 = TotalSulfurDioxide - FreeSulfurDioxide;
run;
* Adding data transformations;
data train0; set train0;
	rs_Alcohol = Alcohol + 4.7;
	rs_Chlorides = Chlorides + 1.171;
	rs_CitricAcid = CitricAcid + 3.24;
	rs_FixedAcidity = FixedAcidity + 18.1;
	rs_FreeSulfurDioxide = FreeSulfurDioxide + 555;
	rs_ResidualSugar = ResidualSugar + 127.8;
	rs_Sulfites = Sulfites + 3.13;
	rs_TotalSulfurDioxide = TotalSulfurDioxide + 823;
	rs_VolatileAcidity = VolatileAcidity + 2.79;
	rs_BoundSulfurDioxide = abs(rs_TotalSulfurDioxide - rs_FreeSulfurDioxide);
	rs_BoundSulfurDioxide2 = BoundSulfurDioxide + 1093;
	rs_TotalAcidity = abs(rs_FixedAcidity + rs_VolatileAcidity);
	rs_TotalAcidity2 = TotalAcidity + 18.61;
	av_Alcohol = abs(Alcohol);
	av_Chlorides = abs(Chlorides);
	av_CitricAcid = abs(CitricAcid);
	av_FixedAcidity = abs(FixedAcidity);
	av_FreeSulfurDioxide = abs(FreeSulfurDioxide);
	av_ResidualSugar = abs(ResidualSugar);
	av_Sulfites = abs(Sulfites);
	av_TotalSulfurDioxide = abs(TotalSulfurDioxide);
	av_VolatileAcidity = abs(VolatileAcidity);
	av_BoundSulfurDioxide = abs(abs(TotalSulfurDioxide) - abs(FreeSulfurDioxide));
	av_BoundSulfurDioxide2 = abs(BoundSulfurDioxide);
	av_TotalAcidity = abs(abs(FixedAcidity) + abs(VolatileAcidity));
	av_TotalAcidity2 = abs(TotalAcidity);
	if av_Alcohol = 0 then ln_av_Alcohol = 0;
		else ln_av_Alcohol = log(av_Alcohol);
	if av_Chlorides = 0 then ln_av_Chlorides = 0;
		else ln_av_Chlorides = log(av_Chlorides);
	if av_CitricAcid = 0 then ln_av_CitricAcid = 0;
		else ln_av_CitricAcid = log(av_CitricAcid);
	if av_FixedAcidity = 0 then ln_av_FixedAcidity = 0;
		else ln_av_FixedAcidity = log(av_FixedAcidity);
	if av_FreeSulfurDioxide = 0 then ln_av_FreeSulfurDioxide = 0;
		else ln_av_FreeSulfurDioxide = log(av_FreeSulfurDioxide);
	if av_ResidualSugar = 0 then ln_av_ResidualSugar = 0;
		else ln_av_ResidualSugar = log(av_ResidualSugar);
	if av_Sulfites = 0 then ln_av_Sulfites = 0;
		else ln_av_Sulfites = log(av_Sulfites);
	if av_TotalSulfurDioxide = 0 then ln_av_TotalSulfurDioxide = 0;
		else ln_av_TotalSulfurDioxide = log(av_TotalSulfurDioxide);
	if av_VolatileAcidity = 0 then ln_av_VolatileAcidity = 0;
		else ln_av_VolatileAcidity = log(av_VolatileAcidity);
	if av_BoundSulfurDioxide = 0 then ln_av_BoundSulfurDioxide = 0;
		else ln_av_BoundSulfurDioxide = log(av_BoundSulfurDioxide);
	if av_BoundSulfurDioxide2 = 0 then ln_av_BoundSulfurDioxide2 = 0;
		else ln_av_BoundSulfurDioxide2 = log(av_BoundSulfurDioxide2);
	if av_TotalAcidity = 0 then ln_av_TotalAcidity = 0;
		else ln_av_TotalAcidity = log(av_TotalAcidity);
	if av_TotalAcidity2 = 0 then ln_av_TotalAcidity2 = 0;
		else ln_av_TotalAcidity2 = log(av_TotalAcidity2);
	if AcidIndex = 0 then ln_AcidIndex = 0;
		else ln_AcidIndex = log(AcidIndex);
	sr_av_Alcohol = sqrt(av_Alcohol);
	sr_av_Chlorides = sqrt(av_Chlorides);
	sr_av_CitricAcid = sqrt(av_CitricAcid);
	sr_av_FixedAcidity = sqrt(av_FixedAcidity);
	sr_av_FreeSulfurDioxide = sqrt(av_FreeSulfurDioxide);
	sr_av_ResidualSugar = sqrt(av_ResidualSugar);
	sr_av_Sulfites = sqrt(av_Sulfites);
	sr_av_TotalSulfurDioxide = sqrt(av_TotalSulfurDioxide);
	sr_av_VolatileAcidity = sqrt(av_VolatileAcidity);
	sr_av_BoundSulfurDioxide = sqrt(av_BoundSulfurDioxide);
	sr_av_BoundSulfurDioxide2 = sqrt(av_BoundSulfurDioxide2);
	sr_av_TotalAcidity = sqrt(av_TotalAcidity);
	sr_av_TotalAcidity2 = sqrt(av_TotalAcidity2);
	sr_AcidIndex = sqrt(AcidIndex);
	* Variable of reference: 0;
	if STARS0 in (0 1 2 3 4) then do;
		STARS0_1 = (STARS0 eq 1);	
		STARS0_2 = (STARS0 eq 2);	
		STARS0_3 = (STARS0 eq 3);	
		STARS0_4 = (STARS0 eq 4);	
	end;
	* Variable of reference: -2;
	if LabelAppeal in (-2 -1 0 1 2) then do;
		LabelAppeal_n1 = (LabelAppeal eq -1);	
		LabelAppeal_0 = (LabelAppeal eq 0);	
		LabelAppeal_p1 = (LabelAppeal eq 1);	
		LabelAppeal_p2 = (LabelAppeal eq 2);	
	end;
run;

* Making sure all missing values have been imputed with mean;
proc means data=train0 n nmiss mean var range min max;
    var acidindex alcohol boundsulfurdioxide boundsulfurdioxide2 chlorides citricacid density 
		fixedacidity freesulfurdioxide labelappeal residualsugar stars sulfites totalacidity 
		totalsulfurdioxide volatileacidity ph target
		rs_alcohol rs_chlorides rs_citricacid rs_fixedacidity rs_freesulfurdioxide rs_residualsugar 
		rs_sulfites rs_totalsulfurdioxide rs_volatileacidity rs_boundsulfurdioxide rs_boundsulfurdioxide2 
		rs_totalacidity rs_totalacidity2 
		av_alcohol av_chlorides av_citricacid av_fixedacidity av_freesulfurdioxide av_residualsugar 
		av_sulfites av_totalsulfurdioxide av_volatileacidity av_boundsulfurdioxide av_boundsulfurdioxide2 
		av_totalacidity av_totalacidity2
		ln_av_alcohol ln_av_chlorides ln_av_citricacid ln_av_fixedacidity ln_av_freesulfurdioxide 
		ln_av_residualsugar ln_av_sulfites ln_av_totalsulfurdioxide ln_av_volatileacidity 
		ln_av_boundsulfurdioxide ln_av_boundsulfurdioxide2 ln_av_totalacidity ln_av_totalacidity2 ln_acidindex
		sr_av_alcohol sr_av_chlorides sr_av_citricacid sr_av_fixedacidity sr_av_freesulfurdioxide 
		sr_av_residualsugar sr_av_sulfites sr_av_totalsulfurdioxide sr_av_volatileacidity 
		sr_av_boundsulfurdioxide sr_av_boundsulfurdioxide2 sr_av_totalacidity sr_av_totalacidity2 sr_acidindex;
run;
* Examining histograms;
proc univariate data=train0 normal;
	var acidindex alcohol boundsulfurdioxide boundsulfurdioxide2 chlorides citricacid density fixedacidity 
		freesulfurdioxide labelappeal residualsugar stars sulfites totalacidity totalsulfurdioxide 
		volatileacidity ph target stars0;
	histogram;
run;
* Examining absolute value transform histograms;
proc univariate data=train0 normal;
	var av_alcohol av_chlorides av_citricacid av_fixedacidity av_freesulfurdioxide av_residualsugar av_sulfites 
		av_totalsulfurdioxide av_volatileacidity av_boundsulfurdioxide boundsulfurdioxide2 av_boundsulfurdioxide2 
		totalacidity av_totalacidity av_totalacidity2;
	histogram;
run;
* Correlation Matrix of continuous variables with TARGET;
proc corr data=train0 rank outp=ctable;
	var acidindex alcohol boundsulfurdioxide boundsulfurdioxide2 chlorides citricacid density 
		fixedacidity freesulfurdioxide labelappeal residualsugar stars sulfites totalacidity 
		totalsulfurdioxide volatileacidity ph stars0
		i_alcohol i_boundsulfurdioxide i_chlorides i_freesulfurdioxide i_residualsugar i_stars
		i_sulfites i_totalsulfurdioxide i_ph
		rs_alcohol rs_chlorides rs_citricacid rs_fixedacidity rs_freesulfurdioxide rs_residualsugar 
		rs_sulfites rs_totalsulfurdioxide rs_volatileacidity rs_boundsulfurdioxide rs_boundsulfurdioxide2 
		rs_totalacidity rs_totalacidity2 
		av_alcohol av_chlorides av_citricacid av_fixedacidity av_freesulfurdioxide av_residualsugar 
		av_sulfites av_totalsulfurdioxide av_volatileacidity av_boundsulfurdioxide av_boundsulfurdioxide2 
		av_totalacidity av_totalacidity2
		ln_av_alcohol ln_av_chlorides ln_av_citricacid ln_av_fixedacidity ln_av_freesulfurdioxide 
		ln_av_residualsugar ln_av_sulfites ln_av_totalsulfurdioxide ln_av_volatileacidity 
		ln_av_boundsulfurdioxide ln_av_boundsulfurdioxide2 ln_av_totalacidity ln_av_totalacidity2 ln_acidindex
		sr_av_alcohol sr_av_chlorides sr_av_citricacid sr_av_fixedacidity sr_av_freesulfurdioxide 
		sr_av_residualsugar sr_av_sulfites sr_av_totalsulfurdioxide sr_av_volatileacidity 
		sr_av_boundsulfurdioxide sr_av_boundsulfurdioxide2 sr_av_totalacidity sr_av_totalacidity2 sr_acidindex;
	with TARGET;
	run;
proc transpose data=ctable out=ctable_transposed; run;
proc print data=ctable_transposed noobs; var _name_ target; run;   

* Correlation Matrix of continuous variables with TARGET;
ods graphics on;
proc corr data=train0 rank plots(maxpoints=none)=matrix(histogram);
	var stars0 labelappeal acidindex rs_volatileacidity ln_av_totalsulfurdioxide rs_totalacidity2 av_alcohol target;
	run;
ods graphics off;

* No Categorical Variables, Poisson;
proc hpgenselect data=train0;
model target = acidindex alcohol boundsulfurdioxide boundsulfurdioxide2 chlorides citricacid density 
		fixedacidity freesulfurdioxide labelappeal residualsugar stars sulfites totalacidity 
		totalsulfurdioxide volatileacidity ph stars0
		i_alcohol i_boundsulfurdioxide i_chlorides i_freesulfurdioxide i_residualsugar i_stars
		i_sulfites i_totalsulfurdioxide i_ph
		rs_alcohol rs_chlorides rs_citricacid rs_fixedacidity rs_freesulfurdioxide rs_residualsugar 
		rs_sulfites rs_totalsulfurdioxide rs_volatileacidity rs_boundsulfurdioxide rs_boundsulfurdioxide2 
		rs_totalacidity rs_totalacidity2 
		av_alcohol av_chlorides av_citricacid av_fixedacidity av_freesulfurdioxide av_residualsugar 
		av_sulfites av_totalsulfurdioxide av_volatileacidity av_boundsulfurdioxide av_boundsulfurdioxide2 
		av_totalacidity av_totalacidity2
		ln_av_alcohol ln_av_chlorides ln_av_citricacid ln_av_fixedacidity ln_av_freesulfurdioxide 
		ln_av_residualsugar ln_av_sulfites ln_av_totalsulfurdioxide ln_av_volatileacidity 
		ln_av_boundsulfurdioxide ln_av_boundsulfurdioxide2 ln_av_totalacidity ln_av_totalacidity2 ln_acidindex
		sr_av_alcohol sr_av_chlorides sr_av_citricacid sr_av_fixedacidity sr_av_freesulfurdioxide 
		sr_av_residualsugar sr_av_sulfites sr_av_totalsulfurdioxide sr_av_volatileacidity 
		sr_av_boundsulfurdioxide sr_av_boundsulfurdioxide2 sr_av_totalacidity sr_av_totalacidity2 sr_acidindex
		/dist=poisson link=log;
		selection method=stepwise (slentry=0.05 slstay=0.05);
   output out=pred p=phat;
run;
* No Categorical Variables, Negative Binomial;
proc hpgenselect data=train0;
model target = acidindex alcohol boundsulfurdioxide boundsulfurdioxide2 chlorides citricacid density 
		fixedacidity freesulfurdioxide labelappeal residualsugar stars sulfites totalacidity 
		totalsulfurdioxide volatileacidity ph stars0
		i_alcohol i_boundsulfurdioxide i_chlorides i_freesulfurdioxide i_residualsugar i_stars
		i_sulfites i_totalsulfurdioxide i_ph
		rs_alcohol rs_chlorides rs_citricacid rs_fixedacidity rs_freesulfurdioxide rs_residualsugar 
		rs_sulfites rs_totalsulfurdioxide rs_volatileacidity rs_boundsulfurdioxide rs_boundsulfurdioxide2 
		rs_totalacidity rs_totalacidity2 
		av_alcohol av_chlorides av_citricacid av_fixedacidity av_freesulfurdioxide av_residualsugar 
		av_sulfites av_totalsulfurdioxide av_volatileacidity av_boundsulfurdioxide av_boundsulfurdioxide2 
		av_totalacidity av_totalacidity2
		ln_av_alcohol ln_av_chlorides ln_av_citricacid ln_av_fixedacidity ln_av_freesulfurdioxide 
		ln_av_residualsugar ln_av_sulfites ln_av_totalsulfurdioxide ln_av_volatileacidity 
		ln_av_boundsulfurdioxide ln_av_boundsulfurdioxide2 ln_av_totalacidity ln_av_totalacidity2 ln_acidindex
		sr_av_alcohol sr_av_chlorides sr_av_citricacid sr_av_fixedacidity sr_av_freesulfurdioxide 
		sr_av_residualsugar sr_av_sulfites sr_av_totalsulfurdioxide sr_av_volatileacidity 
		sr_av_boundsulfurdioxide sr_av_boundsulfurdioxide2 sr_av_totalacidity sr_av_totalacidity2 sr_acidindex
		/dist=nb link=log;
		selection method=stepwise (slentry=0.05 slstay=0.05);
   output out=pred p=phat;
run;
* No Categorical Variables, Linear Regression;
proc hpgenselect data=train0;
model target = acidindex alcohol boundsulfurdioxide boundsulfurdioxide2 chlorides citricacid density 
		fixedacidity freesulfurdioxide labelappeal residualsugar stars sulfites totalacidity 
		totalsulfurdioxide volatileacidity ph stars0
		i_alcohol i_boundsulfurdioxide i_chlorides i_freesulfurdioxide i_residualsugar i_stars
		i_sulfites i_totalsulfurdioxide i_ph
		rs_alcohol rs_chlorides rs_citricacid rs_fixedacidity rs_freesulfurdioxide rs_residualsugar 
		rs_sulfites rs_totalsulfurdioxide rs_volatileacidity rs_boundsulfurdioxide rs_boundsulfurdioxide2 
		rs_totalacidity rs_totalacidity2 
		av_alcohol av_chlorides av_citricacid av_fixedacidity av_freesulfurdioxide av_residualsugar 
		av_sulfites av_totalsulfurdioxide av_volatileacidity av_boundsulfurdioxide av_boundsulfurdioxide2 
		av_totalacidity av_totalacidity2
		ln_av_alcohol ln_av_chlorides ln_av_citricacid ln_av_fixedacidity ln_av_freesulfurdioxide 
		ln_av_residualsugar ln_av_sulfites ln_av_totalsulfurdioxide ln_av_volatileacidity 
		ln_av_boundsulfurdioxide ln_av_boundsulfurdioxide2 ln_av_totalacidity ln_av_totalacidity2 ln_acidindex
		sr_av_alcohol sr_av_chlorides sr_av_citricacid sr_av_fixedacidity sr_av_freesulfurdioxide 
		sr_av_residualsugar sr_av_sulfites sr_av_totalsulfurdioxide sr_av_volatileacidity 
		sr_av_boundsulfurdioxide sr_av_boundsulfurdioxide2 sr_av_totalacidity sr_av_totalacidity2 sr_acidindex
		/dist=normal link=identity;
		selection method=stepwise (slentry=0.05 slstay=0.05);
   output out=pred p=phat;
run;
* Added 4 Categorical Variables, Poisson;
proc hpgenselect data=train0;
class stars (ref="1") stars0 (ref="0") labelappeal (ref="-2") i_stars (ref="0"); 
model target = acidindex alcohol boundsulfurdioxide boundsulfurdioxide2 chlorides citricacid density 
		fixedacidity freesulfurdioxide labelappeal residualsugar stars sulfites totalacidity 
		totalsulfurdioxide volatileacidity ph stars0
		i_alcohol i_boundsulfurdioxide i_chlorides i_freesulfurdioxide i_residualsugar i_stars
		i_sulfites i_totalsulfurdioxide i_ph
		rs_alcohol rs_chlorides rs_citricacid rs_fixedacidity rs_freesulfurdioxide rs_residualsugar 
		rs_sulfites rs_totalsulfurdioxide rs_volatileacidity rs_boundsulfurdioxide rs_boundsulfurdioxide2 
		rs_totalacidity rs_totalacidity2 
		av_alcohol av_chlorides av_citricacid av_fixedacidity av_freesulfurdioxide av_residualsugar 
		av_sulfites av_totalsulfurdioxide av_volatileacidity av_boundsulfurdioxide av_boundsulfurdioxide2 
		av_totalacidity av_totalacidity2
		ln_av_alcohol ln_av_chlorides ln_av_citricacid ln_av_fixedacidity ln_av_freesulfurdioxide 
		ln_av_residualsugar ln_av_sulfites ln_av_totalsulfurdioxide ln_av_volatileacidity 
		ln_av_boundsulfurdioxide ln_av_boundsulfurdioxide2 ln_av_totalacidity ln_av_totalacidity2 ln_acidindex
		sr_av_alcohol sr_av_chlorides sr_av_citricacid sr_av_fixedacidity sr_av_freesulfurdioxide 
		sr_av_residualsugar sr_av_sulfites sr_av_totalsulfurdioxide sr_av_volatileacidity 
		sr_av_boundsulfurdioxide sr_av_boundsulfurdioxide2 sr_av_totalacidity sr_av_totalacidity2 sr_acidindex
		/dist=poisson link=log;
		selection method=stepwise (slentry=0.05 slstay=0.05);
   output out=pred p=phat;
run;
* Added 4 Categorical Variables, Negative Binomial;
proc hpgenselect data=train0;
class stars (ref="1") stars0 (ref="0") labelappeal (ref="-2") i_stars (ref="0"); 
model target = acidindex alcohol boundsulfurdioxide boundsulfurdioxide2 chlorides citricacid density 
		fixedacidity freesulfurdioxide labelappeal residualsugar stars sulfites totalacidity 
		totalsulfurdioxide volatileacidity ph stars0
		i_alcohol i_boundsulfurdioxide i_chlorides i_freesulfurdioxide i_residualsugar i_stars
		i_sulfites i_totalsulfurdioxide i_ph
		rs_alcohol rs_chlorides rs_citricacid rs_fixedacidity rs_freesulfurdioxide rs_residualsugar 
		rs_sulfites rs_totalsulfurdioxide rs_volatileacidity rs_boundsulfurdioxide rs_boundsulfurdioxide2 
		rs_totalacidity rs_totalacidity2 
		av_alcohol av_chlorides av_citricacid av_fixedacidity av_freesulfurdioxide av_residualsugar 
		av_sulfites av_totalsulfurdioxide av_volatileacidity av_boundsulfurdioxide av_boundsulfurdioxide2 
		av_totalacidity av_totalacidity2
		ln_av_alcohol ln_av_chlorides ln_av_citricacid ln_av_fixedacidity ln_av_freesulfurdioxide 
		ln_av_residualsugar ln_av_sulfites ln_av_totalsulfurdioxide ln_av_volatileacidity 
		ln_av_boundsulfurdioxide ln_av_boundsulfurdioxide2 ln_av_totalacidity ln_av_totalacidity2 ln_acidindex
		sr_av_alcohol sr_av_chlorides sr_av_citricacid sr_av_fixedacidity sr_av_freesulfurdioxide 
		sr_av_residualsugar sr_av_sulfites sr_av_totalsulfurdioxide sr_av_volatileacidity 
		sr_av_boundsulfurdioxide sr_av_boundsulfurdioxide2 sr_av_totalacidity sr_av_totalacidity2 sr_acidindex
		/dist=nb link=log;
		selection method=stepwise (slentry=0.05 slstay=0.05);
   output out=pred p=phat;
run;
* Added 4 Categorical Variables, Linear Regression;
proc hpgenselect data=train0;
class stars (ref="1") stars0 (ref="0") labelappeal (ref="-2") i_stars (ref="0"); 
model target = acidindex alcohol boundsulfurdioxide boundsulfurdioxide2 chlorides citricacid density 
		fixedacidity freesulfurdioxide labelappeal residualsugar stars sulfites totalacidity 
		totalsulfurdioxide volatileacidity ph stars0
		i_alcohol i_boundsulfurdioxide i_chlorides i_freesulfurdioxide i_residualsugar i_stars
		i_sulfites i_totalsulfurdioxide i_ph
		rs_alcohol rs_chlorides rs_citricacid rs_fixedacidity rs_freesulfurdioxide rs_residualsugar 
		rs_sulfites rs_totalsulfurdioxide rs_volatileacidity rs_boundsulfurdioxide rs_boundsulfurdioxide2 
		rs_totalacidity rs_totalacidity2 
		av_alcohol av_chlorides av_citricacid av_fixedacidity av_freesulfurdioxide av_residualsugar 
		av_sulfites av_totalsulfurdioxide av_volatileacidity av_boundsulfurdioxide av_boundsulfurdioxide2 
		av_totalacidity av_totalacidity2
		ln_av_alcohol ln_av_chlorides ln_av_citricacid ln_av_fixedacidity ln_av_freesulfurdioxide 
		ln_av_residualsugar ln_av_sulfites ln_av_totalsulfurdioxide ln_av_volatileacidity 
		ln_av_boundsulfurdioxide ln_av_boundsulfurdioxide2 ln_av_totalacidity ln_av_totalacidity2 ln_acidindex
		sr_av_alcohol sr_av_chlorides sr_av_citricacid sr_av_fixedacidity sr_av_freesulfurdioxide 
		sr_av_residualsugar sr_av_sulfites sr_av_totalsulfurdioxide sr_av_volatileacidity 
		sr_av_boundsulfurdioxide sr_av_boundsulfurdioxide2 sr_av_totalacidity sr_av_totalacidity2 sr_acidindex
		/dist=normal link=identity;
		selection method=stepwise (slentry=0.05 slstay=0.05);
   output out=pred p=phat;
run;

* Examining histograms for zero inflation;
proc univariate data=train0;
	var stars0 labelappeal acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide 
			   ln_av_freesulfurdioxide av_alcohol;
	histogram;
run;
* Examining frequency tables for zero inflation;
proc freq data=train0;
    tables target*stars0;
proc freq data=train0;
    tables target*labelappeal;
proc freq data=train0;
    tables target*labelappeal;
run;

* Model 1: Poisson, all quantitative variables;
proc genmod data=train0;
model target = stars0 labelappeal acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide 
			   ln_av_freesulfurdioxide av_alcohol / link=log dist=poi;
   output out=train0 p=m1;
run;
* Model 2: Poisson, 2 categorical variables;
proc genmod data=train0;
class stars0 (ref="0") labelappeal (ref="-2"); 
model target = stars0 labelappeal acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide 
			   ln_av_freesulfurdioxide av_alcohol / link=log dist=poi;
   output out=train0 p=m2;
run;
* Model 3: Negative Binomial, all quantitative variables;
proc genmod data=train0;
model target = stars0 labelappeal acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide 
			   ln_av_freesulfurdioxide av_alcohol / link=log dist=nb;
   output out=train0 p=m3;
run;
* Model 4: Negative Binomial, 2 categorical variables;
proc genmod data=train0;
class stars0 (ref="0") labelappeal (ref="-2"); 
model target = stars0 labelappeal acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide 
			   ln_av_freesulfurdioxide av_alcohol / link=log dist=nb;
   output out=train0 p=m4;
run;
* Model 5: Zero Inflated Poisson, all quantitative variables;
proc genmod data=train0;
model target = stars0 labelappeal acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide 
			   ln_av_freesulfurdioxide av_alcohol / link=log dist=zip;
	 zeromodel stars0 labelappeal acidindex / link=logit;
   	output out=train0 p=m5;
run;
* Model 6: Zero Inflated Poisson, 2 categorical variables;
proc genmod data=train0;
class stars0 (ref="0") labelappeal (ref="-2"); 
model target = stars0 labelappeal acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide 
			   ln_av_freesulfurdioxide av_alcohol / link=log dist=zip;
	zeromodel stars0 labelappeal acidindex / link=logit;
   output out=train0 p=m6;
run;
* Model 7: Zero Inflated Negative Binomial, all quantitative variables;
proc genmod data=train0;
model target = stars0 labelappeal acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide 
			   ln_av_freesulfurdioxide av_alcohol / link=log dist=zinb;
	 zeromodel stars0 labelappeal acidindex / link=logit;
   	output out=train0 p=m7;
run;
* Model 8: Zero Inflated Negative Binomial, 2 categorical variables;
proc genmod data=train0;
class stars0 (ref="0") labelappeal (ref="-2"); 
model target = stars0 labelappeal acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide 
			   ln_av_freesulfurdioxide av_alcohol / link=log dist=zinb;
	zeromodel stars0 labelappeal acidindex / link=logit;
   output out=train0 p=m8;
run;
* Model 9: Regression, all quantitative variables;
proc reg data=train0;
model target = stars0 labelappeal acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide 
			   ln_av_freesulfurdioxide av_alcohol;
   output out=train0 p=m9;
run;
proc genmod data=train0;
model target = stars0 labelappeal acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide  
			   ln_av_freesulfurdioxide av_alcohol / link=identity dist=normal;
   output out=train0 p=m9;
run;
* Model 10: Regression, 2 categorical variables;
proc reg data=train0;
model target = acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide 
			   ln_av_freesulfurdioxide av_alcohol
			   stars0_1 stars0_2 stars0_3 stars0_4 labelappeal_n1 labelappeal_0
			   labelappeal_p1 labelappeal_p2;
   output out=train0 p=m10;
run;
proc genmod data=train0;
class stars0 (ref="0") labelappeal (ref="-2"); 
model target = stars0 labelappeal acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide 
			   ln_av_freesulfurdioxide av_alcohol / link=identity dist=normal;
   output out=train0 p=m10;
run;
proc print data=train0 (obs=30);
    var target m1 m2 m3 m4 m5 m6 m7 m8 m9 m10;
run;
* Model 11: Zero Inflated Poisson, 2 categorical variables, zeromodel complementary log-log link;
proc genmod data=train0;
class stars0 (ref="0") labelappeal (ref="-2"); 
model target = stars0 labelappeal acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide 
			   ln_av_freesulfurdioxide av_alcohol / link=log dist=zip;
	zeromodel stars0 labelappeal acidindex / link=cloglog;
   output out=train0 p=m11;
run;
* Model 12: Zero Inflated Poisson, 2 categorical variables, zeromodel probit link;
proc genmod data=train0;
class stars0 (ref="0") labelappeal (ref="-2"); 
model target = stars0 labelappeal acidindex ln_av_volatileacidity ln_av_totalsulfurdioxide 
			   ln_av_freesulfurdioxide av_alcohol / link=log dist=zip;
	zeromodel stars0 labelappeal acidindex / link=probit;
   output out=train0 p=m12;
run;
proc print data=train0 (obs=30);
    var target m6 m11 m12;
run;
