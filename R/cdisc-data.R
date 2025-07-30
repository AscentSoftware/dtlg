#' Subject-Level Analysis Dataset (ADSL) example dataset
#'
#' [adsl] is a re-export of the [random.cdisc.data::cadsl] dataset, included in
#' `{dtlg}` for function usage illustration and testing.
#'
#' @inherit random.cdisc.data::cadsl format
#'
"adsl"

#' ADaM Basic Data Structure (BDS) example dataset
#'
#' [adlb] is a re-export of the [random.cdisc.data::cadlb] dataset, included in
#' `{dtlg}` for function usage illustration and testing.
#'
#' @inherit random.cdisc.data::cadlb format
#'
"adlb"

#' Adverse Event Analysis Dataset example dataset
#'
#' [adae] is a re-export of the [random.cdisc.data::cadae] dataset, included in
#' `{dtlg}` for function usage illustration and testing.
#'
#' @inherit random.cdisc.data::adae format
#'
"adae"

#' Adverse Events of Special Interest (AESI) example dataset
#'
#' [aesi] is a modified version of the [random.cdisc.data::cadae] dataset,
#' filtered to include only analysis-flagged records (`ANL01FL == "Y"`) and
#' extended with binary indicator variables corresponding to adverse events of
#' special interest (AESIs).
#'
#' These derived flags include seriousness, severity, fatality, relatedness, and
#' treatment consequence (e.g., dose modification or withdrawal), and are used to
#' illustrate key safety summaries in clinical reporting.
#'
#' Each derived variable is labeled using [dtlg::with_label()] for compatibility
#' with tabulation functions.
#'
#' This dataset is included in `{dtlg}` to support function testing, usage
#' examples, and reproducible safety analyses.
#'
#' @format A `data.frame` with a subset of rows from `cadae` and additional
#' derived columns including:
#' \describe{
#'   \item{FATAL}{Logical flag for fatal AEs (`AESDTH == "Y"`).}
#'   \item{SEV}{Logical flag for severe AEs (`AESEV == "SEVERE"`).}
#'   \item{SER}{Logical flag for serious AEs (`AESER == "Y"`).}
#'   \item{SERWD}{Serious AE leading to withdrawal (`AESER == "Y" & AEACN == "DRUG WITHDRAWN"`).}
#'   \item{SERDSM}{Serious AE leading to dose modification/interruption.}
#'   \item{RELSER}{Serious and related AE.}
#'   \item{WD}{AE leading to withdrawal.}
#'   \item{DSM}{AE leading to dose modification/interruption.}
#'   \item{REL}{Related AE.}
#'   \item{RELWD}{Related AE leading to withdrawal.}
#'   \item{RELDSM}{Related AE leading to dose modification/interruption.}
#' }
#'
#' @seealso [random.cdisc.data::cadae], [dtlg::multi_event_true()]
#'
"aesi"
