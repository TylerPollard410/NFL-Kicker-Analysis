#### Load and Clean NFL field goal data since 1999
## Tyler Pollard
## 11 Feb 2024

# Load Libraries ----
library(progressr)
library(nflreadr)
library(plyr)
library(tidyverse)
library(tictoc)
library(tidyr)

# Part 1 ==========================================================================================================
## Load Data ----
### Play-by-Play Data since 1999 ----
# (Takes about 2 minutes to load)
tic()
pbpData <- with_progress(load_pbp(season = TRUE))
toc()

# Data Dictionary
pbpDataDictionary <- dictionary_pbp

## Create Field Goal Data ----
# Clean play-by-play data to: 
#   Include relevant columns
#   Include only field goal plays
#   Group missed and blocked field goals as misses
#   Identify clutch field goal attempts
#     Any field goal that could tie game or change lead
#   Identify clutch field goal makes

FGpbpData <- pbpData |>
  select(
    game_id,
    season,
    field_goal_attempt,
    field_goal_result,
    kick_distance,
    posteam_score,
    defteam_score,
    posteam_score_post,
    defteam_score_post,
    kicker_player_name
  ) |>
  filter(field_goal_attempt == 1) |>
  mutate(
    field_goal_make = ifelse(field_goal_result == "made", 1, 0),
    clutch_attempt = ifelse(between(posteam_score - defteam_score, -3, 0), 1, 0),
    clutch_make = ifelse(clutch_attempt == 1 & field_goal_make == 1, 1, 0),
  )

## Create summarized field goal datasets ----
# Y:= Number of field goals made
# X:= Clutch field goal (yes/no)
# Z:= Binned field goal distance
#       Bins: < 30, 30-39, 40-49, >= 50
# n:= Number of field goals attempted
# theta:= probability of making a field goal

### Overall Field Goal Data ----
FGdataOverall <- FGpbpData |>
  summarise(
    field_goal_attempts = n(),
    field_goal_makes = sum(field_goal_make)
  )
FGdataOverall <- FGdataOverall |> select(field_goal_makes, field_goal_attempts)
save(FGdataOverall, file = "Data/FGdataOverall.RData")

### Clutch Field Goal Data ----
FGdataClutch <- FGpbpData |>
  mutate(
    clutch_attempt = ifelse(clutch_attempt == 0, "Regular", "Clutch")
  ) |>
  group_by(clutch_attempt) |>
  summarise(
    field_goal_attempts = n(),
    field_goal_makes = sum(field_goal_make)
  )
FGdataClutch$clutch_attempt <- factor(FGdataClutch$clutch_attempt,
                                      levels = c("Regular", "Clutch"))
FGdataClutch <- FGdataClutch |> 
  arrange(clutch_attempt) |>
  select(clutch_attempt, field_goal_makes, field_goal_attempts)

save(FGdataClutch, file = "Data/FGdataClutch.RData")

### Clutch and Distance Field Goal Data ----
quantile(FGpbpData$kick_distance, c(0,0.25, 0.5, 0.75, 1))

FGdataDistance <- FGpbpData |> 
  mutate(
    clutch_attempt = ifelse(clutch_attempt == 0, "Regular", "Clutch"),
    binned_kick_distance = ifelse(kick_distance < 30, "< 30",
                                  ifelse(between(kick_distance, 30, 39), "30 - 39",
                                         ifelse(between(kick_distance, 40, 49), "40 - 49", ">= 50")))
  ) |>
  group_by(clutch_attempt, binned_kick_distance) |>
  summarise(
    field_goal_attempts = n(),
    field_goal_makes = sum(field_goal_make)
  )
FGdataDistance$clutch_attempt <- factor(FGdataDistance$clutch_attempt,
                                        levels = c("Regular", "Clutch"))
FGdataDistance$binned_kick_distance <- factor(FGdataDistance$binned_kick_distance,
                                              levels = c("< 30", "30 - 39", "40 - 49", ">= 50"))
FGdataDistance <- FGdataDistance |>
  arrange(clutch_attempt, binned_kick_distance) |>
  select(clutch_attempt, binned_kick_distance, field_goal_makes, field_goal_attempts)

save(FGdataDistance, file = "Data/FGdataDistance.RData")

## Load Data from cleaned datasets ----
load(file = "Data/FGdataOverall.RData")
load(file = "Data/FGdataClutch.RData")
load(file = "Data/FGdataDistance.RData")

### Sample Size Table for output ----
# Make data frame for table
FGdataTable <- FGdataDistance |>
  mutate(
    clutch_attempt = factor(clutch_attempt, levels = c("Regular", "Clutch")),
    binned_kick_distance = factor(binned_kick_distance, levels = c("< 30", "30 - 39", "40 - 49", ">= 50"))
  ) |>
  arrange(
    clutch_attempt, 
    binned_kick_distance
  ) |>
  pivot_wider(
    names_from = clutch_attempt, 
    values_from = c(field_goal_makes, field_goal_attempts),
    names_vary = "slowest"
  ) |>
  rowwise() |>
  mutate(
    field_goal_makes_All = sum(field_goal_makes_Regular, field_goal_makes_Clutch),
    field_goal_attempts_All = sum(field_goal_attempts_Regular, field_goal_attempts_Clutch)
  )

allDist <- cbind(binned_kick_distance = "All Distances", data.frame(t(colSums(FGdataTable[, -1]))))
FGdataTable <- rbind(FGdataTable, allDist)


# Part 2 ==========================================================================================================


# Part 3 ==========================================================================================================
## Set parameters ----
# Create grid of theta values from 0 to 1
theta <- seq(0, 1, by = 0.0001)

# Set shape parameters of prior Beta distribution
a <- c(0.5, 1, 2, 10, 100)
b <- c(0.5, 1, 2, 10, 100)

## Create prior distributions ----
prior <- data.frame(theta)
for(i in 1:length(a)){
  prior <- cbind(prior, dbeta(theta, a[i], b[i]))
}
names(prior)[-1] <- a

## Plot prior ----
# plot(theta, dbeta(theta, 0.5, 0.5), type = "l", col = "blue", ylim = c(0, 20))
# lines(theta, dbeta(theta, 1, 1), col = "black")
# lines(theta, dbeta(theta, 2, 2), col = "red")
# lines(theta, dbeta(theta, 10, 10), col = "green")
# lines(theta, dbeta(theta, 100, 100), col = "purple")

plot(prior[["theta"]], prior[[2]], type = "l", col = "blue", ylim = c(0, 15), lwd = 2,
     xlab = expression("Probability of Making a Field Goal, "*theta),
     ylab = expression("Prior Density, "*pi*"("*theta*")"),
     mgp = c(2, 0.5, 0))
lines(prior[["theta"]], prior[[3]], col = "black", lwd = 2)
lines(prior[["theta"]], prior[[4]], col = "red", lwd = 2)
lines(prior[["theta"]], prior[[5]], col = "green", lwd = 2)
lines(prior[["theta"]], prior[[6]], col = "purple", lwd = 2)
legend("topleft", legend = paste0("Beta(", a, ", ", b, ")"), col = c("blue", "black", "red", "green", "purple"), lwd = 2,
       title = expression("Prior Distribution"), cex = 0.75, title.cex = 0.9)

priorPlot_df <- prior |> pivot_longer(cols = 2:6, names_to = "BetaParams", values_to = "density")
ggplot(data = priorPlot_df) +
  geom_line(aes(x = theta, y = density, color = BetaParams)) +
  # geom_line(aes(x = theta, y = `1`)) +
  # geom_line(aes(x = theta, y = `2`)) +
  # geom_line(aes(x = theta, y = `10`)) +
  # geom_line(aes(x = theta, y = `100`)) +
  scale_y_continuous(limits = c(0,15)) +
  theme_bw() +
  theme(legend.position = c(.1,.8),
        legend.justification = c("left"))

## Set data values ----
n <- FGdataOverall$field_goal_attempts
y <- FGdataOverall$field_goal_makes

## Create posterior distribution ----
posterior <- data.frame(theta)
posteriorSum <- data.frame(check.names = FALSE,
                           "a,b" = as.character(a),
                           "Mean" = NA,
                           "SD" = NA,
                           "90% Credible Interval" = NA
)
for(i in 1:length(a)){
  A <- y + a[i]
  B <- n - y + b[i]
  posterior <- cbind(posterior, dbeta(theta, A, B))
  posteriorSum[["Mean"]][i] <- round(A/(A+B), 4)
  posteriorSum[["SD"]][i] <- round(sqrt(A*B/((A+B)^2*(A+B+1))), 4)
  posteriorSum[["90% Credible Interval"]][i] <- paste0("(", round(qbeta(0.025, A, B), 4), ", ", round(qbeta(0.975, A, B), 4), ")")
}
names(posterior)[-1] <- as.character(a)

## Plot posterior distribution ----
plot(posterior[["theta"]], posterior[[2]], type = "l", col = "blue")
lines(posterior[["theta"]], posterior[[3]], col = "black")
lines(posterior[["theta"]], posterior[[4]], col = "red")
lines(posterior[["theta"]], posterior[[5]], col = "green")
lines(posterior[["theta"]], posterior[[6]], col = "purple")
legend("topleft", legend = paste0(a, ", ", b), col = c("blue", "black", "red", "green", "purple"), lwd = 2)

## Plot posterior distribution with priors ----
plot(posterior[["theta"]], posterior[[3]], type = "l", col = "black")
lines(prior[["theta"]], prior[[2]], col = "blue")
lines(prior[["theta"]], prior[[3]], col = "black")
lines(prior[["theta"]], prior[[4]], col = "red")
lines(prior[["theta"]], prior[[5]], col = "green")
lines(prior[["theta"]], prior[[6]], col = "purple")
legend("topleft", legend = paste0(a, ", ", b), col = c("blue", "black", "red", "green", "purple"), lwd = 2)


# Part 4 ==========================================================================================================
# The selected likelihood $Y|\theta \sim Binomial(n, \theta)$ is a function of the number of field goals made given the number of field goals attempted and the probability of successfully making a field goal. Since we only have a single data point of 21,036 field goals made in 25,471 field goals attempted, we will simulate more data using Monte Carlo sampling to verify the Binomial distribution is an appropriate likelihood. We will sample $n = 25471$ independent Bernoulli trials ($M_{ij} \in \{0, 1\}$), each with probability of success $\hat{\theta}$. The maximum likelihood estimator for $\hat{\theta} = y/n = 21036/25471 = `r round(21036/25471, 4)`$ will be used as the probability of success ()

# Verify Likelihood
n <- FGdataOverall$field_goal_attempts
y <- FGdataOverall$field_goal_makes
a <- 1
b <- 1
A <- y + a
B <- n - y + b
thetaHat0 <- y/n
thetaHat1 <- A/(A+B)
yobs <- 0:n
ylike_obs <- dbinom(y, n, thetaHat0)
ylike <- dbinom(yobs, n, thetaHat0)
ypost <- dbinom(yobs, n, thetaHat1)
ylikeLow <- dbinom(yobs, n, thetaHat0-0.01)
ylikeHigh <- dbinom(yobs, n, thetaHat0+0.01)

yobs <- 0:n
ylike <- dbinom(yobs, n, thetaHat0)
par(oma = c(1,0,0,0))
plot(yobs, ylike, type = "l", lwd = 2,
     xlab = expression("Number of Field Goals Made, "*italic("Y")),
     ylab = expression("Likelihood, "*italic("f")*"(Y|"*hat(theta)*")"),
     mgp = c(2, 0.5, 0))
abline(v = 21036, col = "blue", lwd = 1.5)
text(x = 17750, y = 0.0005, label = expression(italic("Y"[obs])*" = 21036"), col = "blue")

bounds <- which(ylike > 0.000001)
lower <- min(bounds)
upper <- max(bounds)

# hist(y, breaks = seq(lower, upper, by = 1))
plot(yobs, ylike, cex = 0.3,  #pch = 16,
     xlim = c(lower, upper),
     xlab = expression("Number of Field Goals Made, "*italic("Y")),
     ylab = expression("Likelihood, "*italic("f")*"(Y|"*hat(theta)*")"),
     mgp = c(2, 0.5, 0))
abline(v = 21036, col = "blue", lwd = 2)
text(x = y + 60, y = 0.0005, label = expression(italic("Y"[obs])*" = 21036"), col = "blue")


lines(yobs, ypost, col = "red", lwd = 4, lty = "dashed")
lines(yobs, ylikeLow, col = "red", lwd = 2, lty = "dashed")
lines(yobs, ylikeHigh, col = "green", lwd = 2, lty = "dashed")
lines(c(y, y), c(0, dbinom(y, n, thetaHat0)), col = "blue", lwd = 2, lty = "dashed")
legend("topleft", legend = expression(italic(Y)[obs]*" = 21036"), col = "blue", lwd = 2, lty = "dashed")

S <- n
theta_star <- rbeta(S,A,B)
Y_star <- rbinom(S,n,theta_star)
PPD <- table(Y_star)/S
hist(Y_star, freq = FALSE)#, breaks = seq(20700, 21400, by = 10))
lines(yobs, ylike)


# Part 5 ==========================================================================================================
# Hypothesis test of regular vs clutch
yR <- FGdataClutch |> filter(clutch_attempt == "Regular") |> pull(field_goal_makes)
nR <- FGdataClutch |> filter(clutch_attempt == "Regular") |> pull(field_goal_attempts)
yC <- FGdataClutch |> filter(clutch_attempt == "Clutch") |> pull(field_goal_makes)
nC <- FGdataClutch |> filter(clutch_attempt == "Clutch") |> pull(field_goal_attempts)

AR <- yR + a
BR <- nR - yR + b
AC <- yC + a
BC <- nC - yC + b

S <- 10000
set.seed(52)
thetaR <- rbeta(S, AR, BR)
thetaC <- rbeta(S, AC, BC)
postR <- dbeta(theta, AR, BR)
postC <- dbeta(theta, AC, BC)
#thetaC2 <- rbeta(S, AC2, BC2)

ylikeR <- dbinom(yobs, n, mean(thetaR))
ylikeC <- dbinom(yobs, n, mean(thetaC))
#ylikeC2 <- dbinom(yobs, n, mean(thetaC2))

yobsR <- rbinom(S, n, mean(thetaR))
yobsC <- rbinom(S, n, mean(thetaC))
#yobsC2 <- rbinom(S, n, mean(thetaC2))

yobsR2 <- rbinom(S, n, thetaR)
yobsC2 <- rbinom(S, n, thetaC)
#yobsC2 <- rbinom(S, n, thetaC2)

plot(yobs, ylikeR, type = "l", lwd = 2,
     xlim = c(20000, 22000),
     xlab = expression("Number of Field Goals Made, "*italic("Y")),
     ylab = expression("Likelihood, "*italic("f")*"(Y|"*hat(theta)*")"),
     mgp = c(2, 0.5, 0))
lines(yobs, ylikeC, col = "blue")

hist(yobsR, xlim = c(20000,22000), freq = FALSE)
lines(yobs, ylikeR)

postR <- dbeta(theta, AR, BR)
postC <- dbeta(theta, AC, BC)

qbeta(0.025, AR, BR)
qbeta(0.975, AR, BR)
quantile(thetaR, c(0.025, 0.975))

qbeta(0.025, AC, BC)
qbeta(0.975, AC, BC)
quantile(thetaC, c(0.025, 0.975))

plot(theta, postR, type = "l", xlim = c(0.8, 0.85))
lines(theta, postC, col = "red")
abline(v = qbeta(0.025, AR, BR))
abline(v = qbeta(0.975, AC, BC), col = "red")
abline(v = qbeta(0.01256, AR, BR))

pbeta(qbeta(0.975,AC,BC), AR, BR) - pbeta(qbeta(0.025,AR,BR), AR, BR)
mean(thetaR > thetaC)
mean(thetaR < thetaC)

thetaDiff <- thetaR - thetaC
hist(thetaDiff)

thetaDiffCI <- quantile(thetaDiff, c(0.025, 0.975))
d <- mean(thetaDiff > 0)
mean(thetaDiff > thetaDiffCI[1])
mean(thetaR > quantile(thetaC, 0.95)) + mean(thetaC < quantile(thetaR, 0.05))


mean(thetaDiff > 0)
probRgrC <- mean(thetaR > thetaC)
probRgrC



plot(thetaR, thetaC, xlim = c(0.8,0.85), ylim = c(0.8,0.85), pch = 16)
abline(0, 1, col = "blue")

# Part 6 ==========================================================================================================
# FGdataDistance$clutch_attempt <- factor(FGdataDistance$clutch_attempt,
#                                         levels = c("Regular", "Clutch"))
# FGdataDistance$binned_kick_distance <- factor(FGdataDistance$binned_kick_distance,
#                                               levels = c("< 30", "30 - 39", "40 - 49", ">= 50"))
# FGdataDistance <- FGdataDistance |> 
#   arrange(clutch_attempt, binned_kick_distance) |>
#   select(clutch_attempt, binned_kick_distance, field_goal_makes, field_goal_attempts)
# 
# FGdataDistanceOnly <- ddply(FGdataDistance, .(binned_kick_distance), summarise,
#                             field_goals_makes = sum(field_goal_makes),
#                             field_goal_attempts = sum(field_goal_attempts))

FGdataDistanceOnly <- FGdataTable |>
  slice(1:4) |>
  select(binned_kick_distance ,field_goal_makes_All, field_goal_attempts_All)
FGdataDistanceOnly$binned_kick_distance <- factor(FGdataDistanceOnly$binned_kick_distance)

yZ <- FGdataDistanceOnly$field_goal_makes_All
nZ <- FGdataDistanceOnly$field_goal_attempts_All

AZ <- yZ + a
BZ <- nZ - yZ + b

set.seed(52)
thetaL30 <- rbeta(S, AZ[1], BZ[1])
thetaL39 <- rbeta(S, AZ[2], BZ[2])
thetaL49 <- rbeta(S, AZ[3], BZ[3])
thetaG50 <- rbeta(S, AZ[4], BZ[4])

postL30 <- dbeta(theta, AZ[1], BZ[1])
postL39 <- dbeta(theta, AZ[2], BZ[2])
postL49 <- dbeta(theta, AZ[3], BZ[3])
postG50 <- dbeta(theta, AZ[4], BZ[4])

plot(theta, postL30, col = "blue", type = "l")
lines(theta, postL39, col = "red")
lines(theta, postL49, col = "green")
lines(theta, postG50, col = "purple")
abline(v = AZ/(AZ + BZ))

quantile(thetaL30, c(0.025, 0.975))
quantile(thetaL39, c(0.025, 0.975))
quantile(thetaL49, c(0.025, 0.975))
quantile(thetaG50, c(0.025, 0.975))

yRDist <- FGdataTable$field_goal_makes_Regular[-5]
nRDist <- FGdataTable$field_goal_attempts_Regular[-5]
yCDist <- FGdataTable$field_goal_makes_Clutch[-5]
nCDist <- FGdataTable$field_goal_attempts_Clutch[-5]

ARDist <- yRDist + a
BRDist <- nRDist - yRDist + b
ACDist <- yCDist + a
BCDist <- nCDist - yCDist + b

set.seed(52)
theta_R_L30 <- rbeta(S, ARDist[1], BRDist[1])
theta_R_L39 <- rbeta(S, ARDist[2], BRDist[2])
theta_R_L49 <- rbeta(S, ARDist[3], BRDist[3])
theta_R_G50 <- rbeta(S, ARDist[4], BRDist[4])

post_R_L30 <- dbeta(theta, ARDist[1], BRDist[1])
post_R_L39 <- dbeta(theta, ARDist[2], BRDist[2])
post_R_L49 <- dbeta(theta, ARDist[3], BRDist[3])
post_R_G50 <- dbeta(theta, ARDist[4], BRDist[4])

theta_C_L30 <- rbeta(S, ACDist[1], BCDist[1])
theta_C_L39 <- rbeta(S, ACDist[2], BCDist[2])
theta_C_L49 <- rbeta(S, ACDist[3], BCDist[3])
theta_C_G50 <- rbeta(S, ACDist[4], BCDist[4])

post_C_L30 <- dbeta(theta, ACDist[1], BCDist[1])
post_C_L39 <- dbeta(theta, ACDist[2], BCDist[2])
post_C_L49 <- dbeta(theta, ACDist[3], BCDist[3])
post_C_G50 <- dbeta(theta, ACDist[4], BCDist[4])

plot(theta, post_R_L30, type = "l", col = "blue")
lines(theta, post_C_L30, col = "blue4", lty = "dashed")
lines(theta, post_R_L39, col = "red", lty = "solid")
lines(theta, post_C_L39, col = "red4", lty = "dashed")
lines(theta, post_R_L49, col = "green", lty = "solid")
lines(theta, post_C_L49, col = "green4", lty = "dashed")
lines(theta, post_R_G50, col = "purple", lty = "solid")
lines(theta, post_C_G50, col = "purple4", lty = "dashed")
lines(theta, postR, col = "gold", lty = "solid")
lines(theta, postC, col = "gold4", lty = "dashed")

mean(theta_R_L30 > theta_C_L30)
mean(theta_R_L39 > theta_C_L39)
mean(theta_R_L49 > theta_C_L49)
mean(theta_R_G50 > theta_C_G50)

mean(theta_R_L30 < theta_C_L30)
mean(theta_R_L39 < theta_C_L39)
mean(theta_R_L49 < theta_C_L49)
mean(theta_R_G50 < theta_C_G50)

thetaDiff_L30 <- theta_R_L30 - theta_C_L30
thetaDiff_L39 <- theta_R_L39 - theta_C_L39
thetaDiff_L49 <- theta_R_L49 - theta_C_L49
thetaDiff_G50 <- theta_R_G50 - theta_C_G50

par(mfrow = c(3,2))
dev.off()

plot(theta, postR, type = "l", xlim = c(0.8, 0.85))
lines(theta, postC, col = "red")
abline(v = qbeta(0.025, AR, BR))
abline(v = qbeta(0.975, AC, BC), col = "red")
abline(v = quantile(thetaR, 0.025))

plot(theta, post_R_L30, type = "l", col = "blue", xlim = c(0.94,1))
lines(theta, post_C_L30, col = "blue4", lty = "dashed")

abline(v = qbeta(0.025, AR, BR))
abline(v = qbeta(0.975, AC, BC), col = "red")

mean(theta_R_L30 > theta_C_L30)
mean(thetaDiff_L30 > 0)
quantile(theta_R_L30, c(0.025, 0.975))
quantile(theta_C_L30, c(0.025, 0.975))
quantile(thetaDiff_L30, c(0.025, 0.975))
mean(thetaDiff_L30) - quantile(thetaDiff_L30, c(0.025))
quantile(thetaDiff_L30, c(0.975)) - mean(thetaDiff_L30)
quantile(theta_R_L30, 0.025) > quantile(theta_C_L30, 0.975)

plot(theta, post_R_L39, type = "l", col = "red", xlim = c(0.84,0.91))
lines(theta, post_C_L39, col = "red4", lty = "dashed")

mean(theta_R_L39 > theta_C_L39)
mean(thetaDiff_L39 > 0)
quantile(theta_R_L39, c(0.025, 0.975))
quantile(theta_C_L39, c(0.025, 0.975))
quantile(thetaDiff_L39, c(0.025, 0.975))
quantile(theta_R_L39, 0.025) > quantile(theta_C_L39, 0.975)

plot(theta, post_R_L49, type = "l", col = "green", xlim = c(0.68,0.78))
lines(theta, post_C_L49, col = "green4", lty = "dashed")

mean(theta_R_L49 > theta_C_L49)
mean(thetaDiff_L49 > 0)
quantile(theta_R_L49, c(0.025, 0.975))
quantile(theta_C_L49, c(0.025, 0.975))
quantile(thetaDiff_L49, c(0.025, 0.975))
qbeta(c(0.025,0.975), ARDist[3], BRDist[3])
qbeta(c(0.025,0.975), ACDist[3], BCDist[3])
qbeta(c(0.975), ACDist[3], BCDist[3]) - qbeta(c(0.025), ARDist[3], BRDist[3])
tau <- seq(0, 0.05, 0.001)
widthR <- qbeta(0.95 + tau, ARDist[3], BRDist[3]) - qbeta(tau, ARDist[3], BRDist[3])
widthC <- qbeta(0.95 + tau, ACDist[3], BCDist[3]) - qbeta(tau, ACDist[3], BCDist[3])
tauR <- tau[which.min(widthR)]
tauC <- tau[which.min(widthC)]

pbeta(qbeta(0.95, ACDist[3], BCDist[3]), ARDist[3], BRDist[3]) - pbeta(qbeta(0.025, ARDist[3], BRDist[3]), ARDist[3], BRDist[3])

qbeta(c(tauR,0.95 + tauR), ARDist[3], BRDist[3])
qbeta(c(tauC,0.95 + tauC), ACDist[3], BCDist[3])
qbeta(c(0.95 + tauC), ACDist[3], BCDist[3]) - qbeta(c(tauR), ARDist[3], BRDist[3])

quantile(theta_R_L49, 0.025) > quantile(theta_C_L49, 0.975)

plot(theta, post_R_G50, type = "l", col = "purple", xlim = c(0.53,0.66))
lines(theta, post_C_G50, col = "purple4", lty = "dashed")

mean(theta_R_G50 > theta_C_G50)
mean(thetaDiff_G50 > 0)
mean(abs(thetaDiff_G50))
quantile(abs(thetaDiff_G50), c(0.025, 0.975))
quantile(theta_R_G50, c(0.025, 0.975))
quantile(theta_C_G50, c(0.025, 0.975))
quantile(thetaDiff_G50, c(0.025, 0.975))
quantile(theta_R_G50, 0.025) > quantile(theta_C_G50, 0.975)

mean(theta_R_G50 > quantile(theta_C_G50, 0.95))

dev.off()

