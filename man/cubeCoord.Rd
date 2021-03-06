% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CubeCoord.R
\name{cubeCoord}
\alias{cubeCoord}
\alias{cubeCoordWrapper}
\title{Coordinate representation of a compositional cube and of a sample of compositional cubes}
\usage{
cubeCoord(
  x,
  row.factor = NULL,
  col.factor = NULL,
  slice.factor = NULL,
  value = NULL,
  SBPr = NULL,
  SBPc = NULL,
  SBPs = NULL,
  pivot = FALSE,
  print.res = FALSE
)

cubeCoordWrapper(
  X,
  obs.ID = NULL,
  row.factor = NULL,
  col.factor = NULL,
  slice.factor = NULL,
  value = NULL,
  SBPr = NULL,
  SBPc = NULL,
  SBPs = NULL,
  pivot = FALSE,
  test = FALSE,
  n.boot = 1000
)
}
\arguments{
\item{x}{a data frame containing variables representing row, column and slice factors of the respective compositional cube and variable with the values of the composition.}

\item{row.factor}{name of the variable representing the row factor. Needs to be stated with the quotation marks.}

\item{col.factor}{name of the variable representing the column factor. Needs to be stated with the quotation marks.}

\item{slice.factor}{name of the variable representing the slice factor. Needs to be stated with the quotation marks.}

\item{value}{name of the variable representing the values of the composition. Needs to be stated with the quotation marks.}

\item{SBPr}{an \eqn{I-1\times I} array defining the sequential binary partition of the values of the row factor, where I is the number of the row factor levels. The values assigned in the given step to the + group are marked by 1, values from  the - group by -1 and the rest by 0. If it is not provided, the pivot version of coordinates is constructed automatically.}

\item{SBPc}{an \eqn{J-1\times J} array defining the sequential binary partition of the values of the column factor, where J is the number of the column factor levels. The values assigned in the given step to the + group are marked by 1, values from  the - group by -1 and the rest by 0. If it is not provided, the pivot version of coordinates is constructed automatically.}

\item{SBPs}{an \eqn{K-1\times K} array defining the sequential binary partition of the values of the slice factor, where K is the number of the slice factor levels. The values assigned in the given step to the + group are marked by 1, values from  the - group by -1 and the rest by 0. If it is not provided, the pivot version of coordinates is constructed automatically.}

\item{pivot}{logical, default is FALSE. If TRUE, or one of the SBPs is not defined, its pivot version is used.}

\item{print.res}{logical, default is FALSE. If TRUE, the output is displayed in the Console.}

\item{X}{a data frame containing variables representing row, column and slice factors 
of the respective compositional cubes, variable with the values 
of the composition and variable distinguishing the observations.}

\item{obs.ID}{name of the variable distinguishing the observations. Needs to be stated with the quotation marks.}

\item{test}{logical, default is FALSE. If TRUE, the bootstrap analysis of coordinates is provided.}

\item{n.boot}{number of bootstrap samples.}
}
\value{
\item{Coordinates}{an array of orthonormal coordinates.} 
\item{Grap.rep}{graphical representation of the coordinates. 
Parts denoted by + form the groups in the numerator of the respective computational formula, 
parts - form the denominator and parts . are not involved in the given coordinate.} 
\item{Row.balances}{an array of row balances.}
\item{Column.balances}{an array of column balances.}
\item{Slice.balances}{an array of slice balances.}
\item{Row.column.OR}{an array of row-column OR coordinates.}
\item{Row.slice.OR}{an array of row-slice OR coordinates.}
\item{Column.slice.OR}{an array of column-slice OR coordinates.}
\item{Row.col.slice.OR}{an array of coordinates describing the mutual interaction between all three factors.}
\item{Contrast.matrix}{contrast matrix.}
\item{Log.ratios}{an array of pure log-ratios between groups of parts without the normalizing constant.}
\item{Coda.cube}{cube form of the given composition.}
\item{Bootstrap}{array of sample means, standard deviations and bootstrap confidence intervals.}
\item{Cubes}{Cube form of the given compositions.}
}
\description{
cubeCoord computes a system of orthonormal coordinates of a compositional cube. 
Computation of either pivot coordinates or a coordinate system based on the given SBP is possible.

Wrapper (cubeCoordWrapper): For each compositional cube in the sample cubeCoordWrapper computes 
a system of orthonormal coordinates and provide a simple descriptive analysis. 
Computation of either pivot coordinates or a coordinate system based on the 
given SBP is possible.
}
\details{
cubeCoord

This transformation moves the IJK-part compositional cubes from the simplex into a (IJK-1)-dimensional real space isometrically with respect to its three-factorial nature.

Wrapper (cubeCoordWrapper): Each of n IJK-part compositional cubes from the sample is 
with respect to its three-factorial nature isometrically transformed 
from the simplex into a (IJK-1)-dimensional real space. 
Sample mean values and standard deviations are computed and using 
bootstrap an estimate of 95 \% confidence interval is given.
}
\examples{
###################
### Coordinate representation of a CoDa Cube
\dontrun{
### example from Fa\v cevicov\'a (2019)
data(employment2)
CZE <- employment2[which(employment2$Country == 'CZE'), ]

# pivot coordinates
cubeCoord(CZE, "Sex", 'Contract', "Age", 'Value')

# coordinates with given SBP

r <- t(c(1,-1))
c <- t(c(1,-1))
s <- rbind(c(1,-1,-1), c(0,1,-1))

cubeCoord(CZE, "Sex", 'Contract', "Age", 'Value', r,c,s)
}

###################
### Analysis of a sample of CoDa Cubes
\dontrun{
### example from Fa\v cevicov\'a (2019)
data(employment2)
### Compositional tables approach,
### analysis of the relative structure.
### An example from Facevi\v cov\'a (2019)

# pivot coordinates
cubeCoordWrapper(employment2, 'Country', 'Sex', 'Contract', 'Age', 'Value',  
test=TRUE)

# coordinates with given SBP (defined in the paper)

r <- t(c(1,-1))
c <- t(c(1,-1))
s <- rbind(c(1,-1,-1), c(0,1,-1))

res <- cubeCoordWrapper(employment2, 'Country', 'Sex', 'Contract', 
"Age", 'Value', r,c,s, test=TRUE)

### Classical approach,
### generalized linear mixed effect model.

library(lme4)
employment2$y <- round(employment2$Value*1000)
glmer(y~Sex*Age*Contract+(1|Country),data=employment2,family=poisson)

### other relations within cube (in the log-ratio form)
### e.g. ratio between women and man in the group FT, 15to24
### and ratio between age groups 15to24 and 55plus

# transformation matrix
T <- rbind(c(1,rep(0,5), -1, rep(0,5)), c(rep(c(1/4,0,-1/4), 4)))
T \%*\% t(res$Contrast.matrix) \%*\%res$Bootstrap[,1]
}
}
\references{
Facevicova, K., Filzmoser, P. and K. Hron (2019) Compositional Cubes: Three-factorial Compositional Data. Under review.
}
\seealso{
\code{\link{tabCoord}} 
\code{\link{tabCoordWrapper}}
}
\author{
Kamila Facevicova
}
\keyword{multivariate}
