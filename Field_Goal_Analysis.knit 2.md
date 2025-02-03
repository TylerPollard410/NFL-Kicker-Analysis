---
title: "NFL Field Goal Analysis"
author: "Tyler Pollard"
date: "2024-08-22"
header-includes:
  - \usepackage{asmath}
output:
  github_document:
    toc: true
    toc_depth: 3
---





# Data

The following study will outline a Bayesian analysis of NFL field goal data since 1999. The data is from the `nflreadr` package as part of the `nflverse`. Let $Y \in \{0, 1, 2, ..., n \}$ be the number of field goals made in $n$ field goal attempts. Let $X \in \{Regular, Clutch\}$ be the situational type of kick. A clutch kick is defined as any field goal attempt where the kicking team has the opportunity to either tie or put their team in the lead with a successful field goal (ie. kicking team is losing by 0, 1, 2, or 3 points before the kick), otherwise it is regular. Let $Z \in \{ < 30, 30 - 39, 40 - 49, \geq 50 \}$ be the binned distance of the field goal attempt, in yards.




```{=html}
<div id="bujstutujb" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#bujstutujb table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#bujstutujb thead, #bujstutujb tbody, #bujstutujb tfoot, #bujstutujb tr, #bujstutujb td, #bujstutujb th {
  border-style: none;
}

#bujstutujb p {
  margin: 0;
  padding: 0;
}

#bujstutujb .gt_table {
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

#bujstutujb .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#bujstutujb .gt_title {
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

#bujstutujb .gt_subtitle {
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

#bujstutujb .gt_heading {
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

#bujstutujb .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bujstutujb .gt_col_headings {
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

#bujstutujb .gt_col_heading {
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

#bujstutujb .gt_column_spanner_outer {
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

#bujstutujb .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#bujstutujb .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#bujstutujb .gt_column_spanner {
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

#bujstutujb .gt_spanner_row {
  border-bottom-style: hidden;
}

#bujstutujb .gt_group_heading {
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

#bujstutujb .gt_empty_group_heading {
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

#bujstutujb .gt_from_md > :first-child {
  margin-top: 0;
}

#bujstutujb .gt_from_md > :last-child {
  margin-bottom: 0;
}

#bujstutujb .gt_row {
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

#bujstutujb .gt_stub {
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

#bujstutujb .gt_stub_row_group {
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

#bujstutujb .gt_row_group_first td {
  border-top-width: 2px;
}

#bujstutujb .gt_row_group_first th {
  border-top-width: 2px;
}

#bujstutujb .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bujstutujb .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#bujstutujb .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#bujstutujb .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bujstutujb .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bujstutujb .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#bujstutujb .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#bujstutujb .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#bujstutujb .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bujstutujb .gt_footnotes {
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

#bujstutujb .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#bujstutujb .gt_sourcenotes {
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

#bujstutujb .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#bujstutujb .gt_left {
  text-align: left;
}

#bujstutujb .gt_center {
  text-align: center;
}

#bujstutujb .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#bujstutujb .gt_font_normal {
  font-weight: normal;
}

#bujstutujb .gt_font_bold {
  font-weight: bold;
}

#bujstutujb .gt_font_italic {
  font-style: italic;
}

#bujstutujb .gt_super {
  font-size: 65%;
}

#bujstutujb .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#bujstutujb .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#bujstutujb .gt_indent_1 {
  text-indent: 5px;
}

#bujstutujb .gt_indent_2 {
  text-indent: 10px;
}

#bujstutujb .gt_indent_3 {
  text-indent: 15px;
}

#bujstutujb .gt_indent_4 {
  text-indent: 20px;
}

#bujstutujb .gt_indent_5 {
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
  
  
</table>
</div>
```

# Aggregated Field Goal Analysis

We will begin with aggregating the data over the type of field goal and distance. The data $Y$ is the discrete sum of $n$ independent Bernoulli trials (0 = Miss, 1 = Make) each with success/make probability $\theta$. Therefore, the likelihood $Y|\theta$ then follows a binomial distribution with $Y|\theta \sim Binomial(n, \theta)$ and $n = 24571$ attempts. A conjugate prior for a binomial likelihood is the Beta distribution, so we select the prior $\theta \sim Beta(a, b)$ with $a=b=1$ for an uninformative prior. The posterior distribution of $\theta|Y$ can be derived by

```math
\begin{aligned}
\mathit{
p(\theta|Y) = \frac{f(Y|\theta)\pi(\theta)}{m(Y)} &\propto f(Y|\theta)\pi(\theta) \\
p(\theta|Y)  &\propto \left[{n \choose y}\theta^{y}(1-\theta)^{n-y}\right] \left[\frac{\Gamma(a+b)}{\Gamma(a) \Gamma(b)} \theta^{a-1} (1 - \theta)^{b-1} \right] \\
p(\theta|Y) &\propto [\theta^{Y}(1-\theta)^{n-Y}][\theta^{a-1} (1 - \theta)^{b-1}] = \theta^{(Y + a) - 1}(1-\theta)^{(n - Y + b) - 1} \\
p(\theta|Y) &\propto \theta^{A-1}(1- \theta)^{B-1} \text{ , where } A = Y + a, B = n - Y + b \\
}
\end{aligned}
```

# Posterior Distribution Plot and Prior Sensitivity Analysis

# Likelihood Verification

# Clutch Field Goal Analysis

# Distance Field Goal Analysis



