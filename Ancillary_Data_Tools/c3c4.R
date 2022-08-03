# following grassmapr example script https://github.com/rebeccalpowell/grassmapr/blob/master/grassmapr_exampleScript.R#L59
# also info at https://griffithdan.github.io/pages/code_and_data/grassmapr-North-America-vignette.html
# data from https://github.com/rebeccalpowell/grassmapr-data

#install.packages("devtools", repos = "http://cran.us.r-project.org")
#install_github(repo = "rebeccalpowell/grassmapr")

# Load required R libraries
library(raster)
library(rgdal)
library(devtools)
library(grassmapr)

# load data
datapath <- "grassmapr_data/"
temp <- stack(paste0(datapath,"climate/cru_tmp_10min.tif"))
prec <- stack(paste0(datapath,"climate/cru_pre_10min.tif"))
ndvi <- stack(paste0(datapath,"vegetation-asis/ndvi_2001_10min.tif"))

# STEP 1: Generate monthly climate masks

# Set a C4 temperature threshold based on the COT model (>= 22 deg. C)
C4_temp <- 22
# Set a growing season temperature threshold (>= 5 deg. C)
GS_temp <- 5
# Set a minimum precipitation threshold (>= 25 mm)
GS_prec <- 25

# Generate monthly C4 climate masks
C4_masks <- mask_climate(temp.stack = temp,
                         temp.threshold = C4_temp,
                         precip.stack = prec,
                         precip.threshold = GS_prec)

# Generate monthly Growing Season (GS) climate masks
GS_masks <- mask_climate(temp.stack = temp,
                         temp.threshold = GS_temp,
                         precip.stack = prec,
                         precip.threshold = GS_prec)

# [Optionally] - Count number of months that satisfy each climate criteria
GS_month_total <- count_months(GS_masks)
C4_month_total <- count_months(C4_masks)

# Plot C4 month total, GS month total
par(mfrow = c(1,2))
plot(C4_month_total)
plot(GS_month_total)

# STEP 2: Predict C4 grass proportion

# Calculate C4 herbaceous proportion based on C4 climate only
C4_ratio <- calc_C4_ratio(C4_masks, GS_masks)

# Plot C4 herbaceous proportion [i.e., predicted C4 ratio of grasses, based on climate]
par(mfrow = c(1,1))
plot(C4_ratio)

# [Optionally] - Load monthly NDVI layers
#data(ndvi)

# Calculate C4 ratio based on C4 climate AND vegetation productivity
C4_ratio_vi <- calc_C4_ratio(C4_masks, GS_masks, veg.index = ndvi)

# Compare two predictions of C4 ratio
par(mfrow = c(1,2))
plot(C4_ratio)
plot(C4_ratio_vi)

# save c4 ratios
writeRaster(C4_ratio, paste0(datapath,"C4_ratio.tif"))
writeRaster(C4_ratio_vi, paste0(datapath,"C4_ratio_ndvi.tif"))




