NFL Field Goal Analysis
================
Tyler Pollard
2024-08-22



- [Data](#data)
- [Aggregated Field Goal Analysis](#aggregated-field-goal-analysis)
- [Posterior Distribution Plot and Prior Sensitivity
  Analysis](#posterior-distribution-plot-and-prior-sensitivity-analysis)
- [Likelihood Verification](#likelihood-verification)
- [Clutch Field Goal Analysis](#clutch-field-goal-analysis)
- [Distance Field Goal Analysis](#distance-field-goal-analysis)

# Data

The following study will outline a Bayesian analysis of NFL field goal
data since 1999. The data is from the `nflreadr` package as part of the
`nflverse`. Let $Y \in \{0, 1, 2, ..., n \}$ be the number of field
goals made in $n$ field goal attempts. Let $X \in \{Regular, Clutch\}$
be the situational type of kick. A clutch kick is defined as any field
goal attempt where the kicking team has the opportunity to either tie or
put their team in the lead with a successful field goal (ie. kicking
team is losing by 0, 1, 2, or 3 points before the kick), otherwise it is
regular. Let $Z \in \{ < 30, 30 - 39, 40 - 49, \geq 50 \}$ be the binned
distance of the field goal attempt, in yards.

<div id="uzvsahtlzn" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#uzvsahtlzn table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#uzvsahtlzn thead, #uzvsahtlzn tbody, #uzvsahtlzn tfoot, #uzvsahtlzn tr, #uzvsahtlzn td, #uzvsahtlzn th {
  border-style: none;
}
&#10;#uzvsahtlzn p {
  margin: 0;
  padding: 0;
}
&#10;#uzvsahtlzn .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#uzvsahtlzn .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#uzvsahtlzn .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#uzvsahtlzn .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#uzvsahtlzn .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#uzvsahtlzn .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#uzvsahtlzn .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#uzvsahtlzn .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#uzvsahtlzn .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#uzvsahtlzn .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#uzvsahtlzn .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#uzvsahtlzn .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#uzvsahtlzn .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#uzvsahtlzn .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#uzvsahtlzn .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#uzvsahtlzn .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#uzvsahtlzn .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#uzvsahtlzn .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#uzvsahtlzn .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#uzvsahtlzn .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#uzvsahtlzn .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#uzvsahtlzn .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#uzvsahtlzn .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#uzvsahtlzn .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#uzvsahtlzn .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#uzvsahtlzn .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#uzvsahtlzn .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#uzvsahtlzn .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#uzvsahtlzn .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#uzvsahtlzn .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#uzvsahtlzn .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#uzvsahtlzn .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#uzvsahtlzn .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#uzvsahtlzn .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#uzvsahtlzn .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#uzvsahtlzn .gt_left {
  text-align: left;
}
&#10;#uzvsahtlzn .gt_center {
  text-align: center;
}
&#10;#uzvsahtlzn .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#uzvsahtlzn .gt_font_normal {
  font-weight: normal;
}
&#10;#uzvsahtlzn .gt_font_bold {
  font-weight: bold;
}
&#10;#uzvsahtlzn .gt_font_italic {
  font-style: italic;
}
&#10;#uzvsahtlzn .gt_super {
  font-size: 65%;
}
&#10;#uzvsahtlzn .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#uzvsahtlzn .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#uzvsahtlzn .gt_indent_1 {
  text-indent: 5px;
}
&#10;#uzvsahtlzn .gt_indent_2 {
  text-indent: 10px;
}
&#10;#uzvsahtlzn .gt_indent_3 {
  text-indent: 15px;
}
&#10;#uzvsahtlzn .gt_indent_4 {
  text-indent: 20px;
}
&#10;#uzvsahtlzn .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_title gt_font_normal" style>Counts of NFL field goals made and attempted</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Since 1999</td>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="2" colspan="1" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;" scope="col" id="Distance (Yards)">Distance (Yards)</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="Regular">
        <span class="gt_column_spanner">Regular</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="Clutch">
        <span class="gt_column_spanner">Clutch</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" style="border-left-width: 0.5; border-left-style: solid; border-left-color: gray;" scope="colgroup" id="All Kicks">
        <span class="gt_column_spanner">All Kicks</span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="Makes">Makes</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="Attempts">Attempts</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="Makes">Makes</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="Attempts">Attempts</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="border-left-width: 0.5; border-left-style: solid; border-left-color: gray;" scope="col" id="Makes">Makes</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="Attempts">Attempts</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="binned_kick_distance" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;">&lt; 30</td>
<td headers="field_goal_makes_Regular" class="gt_row gt_center">4443</td>
<td headers="field_goal_attempts_Regular" class="gt_row gt_center">4601</td>
<td headers="field_goal_makes_Clutch" class="gt_row gt_center">2198</td>
<td headers="field_goal_attempts_Clutch" class="gt_row gt_center">2274</td>
<td headers="field_goal_makes_All" class="gt_row gt_center" style="border-left-width: 0.5; border-left-style: solid; border-left-color: gray;">6641</td>
<td headers="field_goal_attempts_All" class="gt_row gt_center">6875</td></tr>
    <tr><td headers="binned_kick_distance" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;">30 - 39</td>
<td headers="field_goal_makes_Regular" class="gt_row gt_center">4426</td>
<td headers="field_goal_attempts_Regular" class="gt_row gt_center">5004</td>
<td headers="field_goal_makes_Clutch" class="gt_row gt_center">2179</td>
<td headers="field_goal_attempts_Clutch" class="gt_row gt_center">2487</td>
<td headers="field_goal_makes_All" class="gt_row gt_center" style="border-left-width: 0.5; border-left-style: solid; border-left-color: gray;">6605</td>
<td headers="field_goal_attempts_All" class="gt_row gt_center">7491</td></tr>
    <tr><td headers="binned_kick_distance" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;">40 - 49</td>
<td headers="field_goal_makes_Regular" class="gt_row gt_center">3886</td>
<td headers="field_goal_attempts_Regular" class="gt_row gt_center">5187</td>
<td headers="field_goal_makes_Clutch" class="gt_row gt_center">1867</td>
<td headers="field_goal_attempts_Clutch" class="gt_row gt_center">2561</td>
<td headers="field_goal_makes_All" class="gt_row gt_center" style="border-left-width: 0.5; border-left-style: solid; border-left-color: gray;">5753</td>
<td headers="field_goal_attempts_All" class="gt_row gt_center">7748</td></tr>
    <tr><td headers="binned_kick_distance" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;">&gt;= 50</td>
<td headers="field_goal_makes_Regular" class="gt_row gt_center">1381</td>
<td headers="field_goal_attempts_Regular" class="gt_row gt_center">2246</td>
<td headers="field_goal_makes_Clutch" class="gt_row gt_center">656</td>
<td headers="field_goal_attempts_Clutch" class="gt_row gt_center">1110</td>
<td headers="field_goal_makes_All" class="gt_row gt_center" style="border-left-width: 0.5; border-left-style: solid; border-left-color: gray;">2037</td>
<td headers="field_goal_attempts_All" class="gt_row gt_center">3356</td></tr>
    <tr><td headers="binned_kick_distance" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000; border-top-width: 2; border-top-style: solid; border-top-color: #000000;">All Distances</td>
<td headers="field_goal_makes_Regular" class="gt_row gt_center" style="border-top-width: 2; border-top-style: solid; border-top-color: #000000;">14136</td>
<td headers="field_goal_attempts_Regular" class="gt_row gt_center" style="border-top-width: 2; border-top-style: solid; border-top-color: #000000;">17038</td>
<td headers="field_goal_makes_Clutch" class="gt_row gt_center" style="border-top-width: 2; border-top-style: solid; border-top-color: #000000;">6900</td>
<td headers="field_goal_attempts_Clutch" class="gt_row gt_center" style="border-top-width: 2; border-top-style: solid; border-top-color: #000000;">8432</td>
<td headers="field_goal_makes_All" class="gt_row gt_center" style="border-left-width: 0.5; border-left-style: solid; border-left-color: gray; border-top-width: 2; border-top-style: solid; border-top-color: #000000;">21036</td>
<td headers="field_goal_attempts_All" class="gt_row gt_center" style="border-top-width: 2; border-top-style: solid; border-top-color: #000000;">25470</td></tr>
  </tbody>
  &#10;  
</table>
</div>

# Aggregated Field Goal Analysis

We will begin with aggregating the data over the type of field goal and
distance. The data $Y$ is the discrete sum of $n$ independent Bernoulli
trials (0 = Miss, 1 = Make) each with success/make probability $\theta$.
Therefore, the likelihood $Y|\theta$ then follows a binomial
distribution with $Y|\theta \sim Binomial(n, \theta)$ and $n = 24571$
attempts. A conjugate prior for a binomial likelihood is the Beta
distribution, so we select the prior $\theta \sim Beta(a, b)$ with
$a=b=1$ for an uninformative prior. The posterior distribution of
$\theta|Y$ can be derived by

$$
\begin{aligned}
p(\theta|Y) = \frac{f(Y|\theta)\pi(\theta)}{m(Y)} &\propto f(Y|\theta)\pi(\theta) \\
p(\theta|Y)  &\propto \left[{n \choose y}\theta^{y}(1-\theta)^{n-y}\right] \left[\frac{\Gamma(a+b)}{\Gamma(a) \Gamma(b)} \theta^{a-1} (1 - \theta)^{b-1} \right] \\
p(\theta|Y) &\propto [\theta^{Y}(1-\theta)^{n-Y}][\theta^{a-1} (1 - \theta)^{b-1}] = \theta^{(Y + a) - 1}(1-\theta)^{(n - Y + b) - 1} \\
p(\theta|Y) &\propto \theta^{A-1}(1- \theta)^{B-1} \text{ , where } A = Y + a, B = n - Y + b \\
\end{aligned}
$$

Therefore, $\theta|Y \sim Beta(Y + a, n - Y + b)$.

# Posterior Distribution Plot and Prior Sensitivity Analysis

A plot of the posterior distribution for probability of making a field
goal with the prior $\theta \sim Beta(1,1)$ is plotted below.

<img src="Field_Goal_Analysis_files/figure-gfm/Posterior Plot-1.png" width="60%" height="50%" style="display: block; margin: auto;" />

Various values of the hyperparameters $a$ and $b$ for the prior
distribution were used to analyze the sensitivity of the posterior to
the prior. The posterior mean, standard deviation (SD), and 95% credible
interval (CI) are in the table below for the hyperparameter values
$a = b = \{0.5, 1, 2, 10, 100 \}$. The results show that there is very
little variation in the posterior for each prior, therefore, the
posterior is not sensitive to the prior due to the large sample size of
field goal attempts.

<div id="emaxiemytm" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#emaxiemytm table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#emaxiemytm thead, #emaxiemytm tbody, #emaxiemytm tfoot, #emaxiemytm tr, #emaxiemytm td, #emaxiemytm th {
  border-style: none;
}
&#10;#emaxiemytm p {
  margin: 0;
  padding: 0;
}
&#10;#emaxiemytm .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#emaxiemytm .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#emaxiemytm .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#emaxiemytm .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#emaxiemytm .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#emaxiemytm .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#emaxiemytm .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#emaxiemytm .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#emaxiemytm .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#emaxiemytm .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#emaxiemytm .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#emaxiemytm .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#emaxiemytm .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#emaxiemytm .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#emaxiemytm .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#emaxiemytm .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#emaxiemytm .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#emaxiemytm .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#emaxiemytm .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#emaxiemytm .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#emaxiemytm .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#emaxiemytm .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#emaxiemytm .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#emaxiemytm .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#emaxiemytm .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#emaxiemytm .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#emaxiemytm .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#emaxiemytm .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#emaxiemytm .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#emaxiemytm .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#emaxiemytm .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#emaxiemytm .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#emaxiemytm .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#emaxiemytm .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#emaxiemytm .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#emaxiemytm .gt_left {
  text-align: left;
}
&#10;#emaxiemytm .gt_center {
  text-align: center;
}
&#10;#emaxiemytm .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#emaxiemytm .gt_font_normal {
  font-weight: normal;
}
&#10;#emaxiemytm .gt_font_bold {
  font-weight: bold;
}
&#10;#emaxiemytm .gt_font_italic {
  font-style: italic;
}
&#10;#emaxiemytm .gt_super {
  font-size: 65%;
}
&#10;#emaxiemytm .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#emaxiemytm .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#emaxiemytm .gt_indent_1 {
  text-indent: 5px;
}
&#10;#emaxiemytm .gt_indent_2 {
  text-indent: 10px;
}
&#10;#emaxiemytm .gt_indent_3 {
  text-indent: 15px;
}
&#10;#emaxiemytm .gt_indent_4 {
  text-indent: 20px;
}
&#10;#emaxiemytm .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="4" class="gt_heading gt_title gt_font_normal gt_bottom_border" style>Posterior summary table for varying priors</td>
    </tr>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="&lt;em&gt;Beta&lt;/em&gt;(a, b)&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><em>Beta</em>(a, b)<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="Mean">Mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="SD&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;2&lt;/sup&gt;&lt;/span&gt;">SD<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>2</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="95% CI&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;3&lt;/sup&gt;&lt;/span&gt;">95% CI<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>3</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="hyperParams" class="gt_row gt_right" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;">0.5</td>
<td headers="Mean" class="gt_row gt_center">0.8259</td>
<td headers="SD" class="gt_row gt_center">0.0024</td>
<td headers="CI_95" class="gt_row gt_center">(0.8212, 0.8305)</td></tr>
    <tr><td headers="hyperParams" class="gt_row gt_right" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;">1</td>
<td headers="Mean" class="gt_row gt_center">0.8259</td>
<td headers="SD" class="gt_row gt_center">0.0024</td>
<td headers="CI_95" class="gt_row gt_center">(0.8212, 0.8305)</td></tr>
    <tr><td headers="hyperParams" class="gt_row gt_right" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;">2</td>
<td headers="Mean" class="gt_row gt_center">0.8259</td>
<td headers="SD" class="gt_row gt_center">0.0024</td>
<td headers="CI_95" class="gt_row gt_center">(0.8212, 0.8305)</td></tr>
    <tr><td headers="hyperParams" class="gt_row gt_right" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;">10</td>
<td headers="Mean" class="gt_row gt_center">0.8257</td>
<td headers="SD" class="gt_row gt_center">0.0024</td>
<td headers="CI_95" class="gt_row gt_center">(0.821, 0.8303)</td></tr>
    <tr><td headers="hyperParams" class="gt_row gt_right" style="border-right-width: 1px; border-right-style: solid; border-right-color: #000000;">100</td>
<td headers="Mean" class="gt_row gt_center">0.8234</td>
<td headers="SD" class="gt_row gt_center">0.0024</td>
<td headers="CI_95" class="gt_row gt_center">(0.8187, 0.828)</td></tr>
  </tbody>
  &#10;  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="4"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span> a = b</td>
    </tr>
    <tr>
      <td class="gt_footnote" colspan="4"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>2</sup></span> SD = Standard Deviation</td>
    </tr>
    <tr>
      <td class="gt_footnote" colspan="4"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>3</sup></span> CI = Credible Interval</td>
    </tr>
  </tfoot>
</table>
</div>

# Likelihood Verification

To verify the selected likelihood $Y|\theta \sim Binomial(n, \theta)$ is
appropriate for the data, we will compare the PMF of the likelihood with
the observed data $Y_{obs} = 21036$. The parameters of the likelihood
were set to $n = 25470$ and $\theta = \hat{\theta} = Y/n$ to represent
the sample proportion. The fit likelihood PMF has highest probability at
$Y = Y_{obs}$ with very small variance when considering all possible
values of $Y$ which is closely representative of the observed data. The
likelihood is appropriate.

<img src="Field_Goal_Analysis_files/figure-gfm/Likelihood Plot-1.png" width="60%" height="50%" style="display: block; margin: auto;" />

# Clutch Field Goal Analysis

A hypothesis test was conducted to determine if the distribution of made
fields goals given field goal attempts differ for regular vs clutch
field goals. In other words, if the probability of making a regular
field goal is greater than the probability of making a clutch field goal
almost all of the time or never then we can say they distributions are
different. Therefore, $H_0: \theta_R > \theta_C|Y_R, Y_C$ and
$H_A: \theta_R \ngtr \theta_C|Y_R, Y_C$. Monte Carlo sampling was used
with 10,000 samples from the posterior distribution of both
$\theta_R|Y_R,Y_C$ and $\theta_C|Y_R,Y_C$ to determine
$P(\theta_R > \theta_C|Y_R, Y_C)$. From the simulation, the probability
of making a regular kick is greater than a clutch kick with probability
$P(\theta_R > \theta_C|Y_R, Y_C) = 0.9881$ and conclude there is a
difference.

# Distance Field Goal Analysis

The data was further parsed into subgroups by binned field goal
distance. We repeated the analysis from above, but for each subgroup to
determine if the probability of making a regular field goal is higher
than a clutch field goal. The hypotheses are now
$H_0: \theta_{R,Z_{i}} > \theta_{C,Z_{i}}|Y_{R,Z_{i}}, Y_{C,Z_{i}}$ and
$H_A: \theta_{R,Z_{i}} \ngtr \theta_{C,Z_{i}}|Y_{R,Z_{i}}, Y_{C,Z_{i}}$.
Monte Carlo simulations were run again in the same fashion and the
results are in Table 3 below. We can see that the distributions do not
differ for each distance except for the 40 - 49 yard subgroup. The
probability that the distributions are different is much higher for
kicks is greater than 30 yards.

<div id="psqzuawyzb" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#psqzuawyzb table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#psqzuawyzb thead, #psqzuawyzb tbody, #psqzuawyzb tfoot, #psqzuawyzb tr, #psqzuawyzb td, #psqzuawyzb th {
  border-style: none;
}
&#10;#psqzuawyzb p {
  margin: 0;
  padding: 0;
}
&#10;#psqzuawyzb .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#psqzuawyzb .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#psqzuawyzb .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#psqzuawyzb .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#psqzuawyzb .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#psqzuawyzb .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#psqzuawyzb .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#psqzuawyzb .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#psqzuawyzb .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#psqzuawyzb .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#psqzuawyzb .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#psqzuawyzb .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#psqzuawyzb .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#psqzuawyzb .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#psqzuawyzb .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#psqzuawyzb .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#psqzuawyzb .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#psqzuawyzb .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#psqzuawyzb .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#psqzuawyzb .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#psqzuawyzb .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#psqzuawyzb .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#psqzuawyzb .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#psqzuawyzb .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#psqzuawyzb .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#psqzuawyzb .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#psqzuawyzb .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#psqzuawyzb .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#psqzuawyzb .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#psqzuawyzb .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#psqzuawyzb .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#psqzuawyzb .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#psqzuawyzb .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#psqzuawyzb .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#psqzuawyzb .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#psqzuawyzb .gt_left {
  text-align: left;
}
&#10;#psqzuawyzb .gt_center {
  text-align: center;
}
&#10;#psqzuawyzb .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#psqzuawyzb .gt_font_normal {
  font-weight: normal;
}
&#10;#psqzuawyzb .gt_font_bold {
  font-weight: bold;
}
&#10;#psqzuawyzb .gt_font_italic {
  font-style: italic;
}
&#10;#psqzuawyzb .gt_super {
  font-size: 65%;
}
&#10;#psqzuawyzb .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#psqzuawyzb .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#psqzuawyzb .gt_indent_1 {
  text-indent: 5px;
}
&#10;#psqzuawyzb .gt_indent_2 {
  text-indent: 10px;
}
&#10;#psqzuawyzb .gt_indent_3 {
  text-indent: 15px;
}
&#10;#psqzuawyzb .gt_indent_4 {
  text-indent: 20px;
}
&#10;#psqzuawyzb .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="2" class="gt_heading gt_title gt_font_normal gt_bottom_border" style>Probability of <i>θ<sub>R, Z<sub>i</sub></sub> > θ<sub>C, Z<sub>i</sub></sub></i> | <i>Y<sub>R, Z<sub>i</sub></sub> , Y<sub>C, Z<sub>i</sub></sub></i> for each binned distance</td>
    </tr>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="Distance (Yards)">Distance (Yards)</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;i&gt;P(θ&lt;sub&gt;R, Z&lt;sub&gt;i&lt;/sub&gt;&lt;/sub&gt; &gt; θ&lt;sub&gt;C, Z&lt;sub&gt;i&lt;/sub&gt;&lt;/sub&gt;&lt;/i&gt; | &lt;i&gt;Y&lt;sub&gt;R, Z&lt;sub&gt;i&lt;/sub&gt;&lt;/sub&gt; , Y&lt;sub&gt;C, Z&lt;sub&gt;i&lt;/sub&gt;&lt;/sub&gt; )&lt;/i&gt;"><i>P(θ<sub>R, Z<sub>i</sub></sub> > θ<sub>C, Z<sub>i</sub></sub></i> | <i>Y<sub>R, Z<sub>i</sub></sub> , Y<sub>C, Z<sub>i</sub></sub> )</i></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="Distance" class="gt_row gt_center">&lt; 30</td>
<td headers="Prob" class="gt_row gt_center">0.4336</td></tr>
    <tr><td headers="Distance" class="gt_row gt_center">30 - 39</td>
<td headers="Prob" class="gt_row gt_center">0.8610</td></tr>
    <tr><td headers="Distance" class="gt_row gt_center">40 - 49</td>
<td headers="Prob" class="gt_row gt_center">0.9724</td></tr>
    <tr><td headers="Distance" class="gt_row gt_center">&gt;= 50</td>
<td headers="Prob" class="gt_row gt_center">0.9073</td></tr>
  </tbody>
  &#10;  
</table>
</div>
