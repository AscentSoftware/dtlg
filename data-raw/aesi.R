library(dplyr)
library(random.cdisc.data)
library(dtlg)

set.seed(99)
cadae_nrow <- nrow(random.cdisc.data::cadae)

aesi <-
  random.cdisc.data::cadae |>
  dplyr::mutate(
    AEDECOD = dtlg::with_label(as.character(.data$AEDECOD), "Dictionary-Derived Term"),
    AESDTH = dtlg::with_label(
      sample(
        c("N", "Y"),
        size = cadae_nrow,
        replace = TRUE,
        prob = c(0.99, 0.01)
      ),
      "Results in Death"
    ),
    AEACN = dtlg::with_label(
      sample(
        c(
          "DOSE NOT CHANGED",
          "DOSE INCREASED",
          "DRUG INTERRUPTED",
          "DRUG WITHDRAWN"
        ),
        size = cadae_nrow,
        replace = TRUE,
        prob = c(0.68, 0.02, 0.25, 0.05)
      ),
      "Action Taken with Study Treatment"
    ),
    FATAL = dtlg::with_label(AESDTH == "Y", "AE with fatal outcome"),
    SEV = dtlg::with_label(AESEV == "SEVERE", "Severe AE (at greatest intensity)"),
    SER = dtlg::with_label(AESER == "Y", "Serious AE"),
    SERWD = dtlg::with_label(
      AESER == "Y" &
        AEACN == "DRUG WITHDRAWN",
      "Serious AE leading to withdrawal from treatment"
    ),
    SERDSM = dtlg::with_label(
      AESER == "Y" &
        AEACN %in% c("DRUG INTERRUPTED", "DOSE INCREASED", "DOSE REDUCED"),
      "Serious AE leading to dose modification/interruption"
    ),
    RELSER = dtlg::with_label(AESER == "Y" &
                          AEREL == "Y", "Related Serious AE"),
    WD = dtlg::with_label(
      AEACN == "DRUG WITHDRAWN",
      "AE leading to withdrawal from treatment"
    ),
    DSM = dtlg::with_label(
      AEACN %in% c("DRUG INTERRUPTED", "DOSE INCREASED", "DOSE REDUCED"),
      "AE leading to dose modification/interruption"
    ),
    REL = dtlg::with_label(AEREL == "Y", "Related AE"),
    RELWD = dtlg::with_label(
      AEREL == "Y" &
        AEACN == "DRUG WITHDRAWN",
      "Related AE leading to withdrawal from treatment"
    ),
    RELDSM = dtlg::with_label(
      AEREL == "Y" &
        AEACN %in% c("DRUG INTERRUPTED", "DOSE INCREASED", "DOSE REDUCED"),
      "Related AE leading to dose modification/interruption"
    )
  ) |>
  dplyr::filter(ANL01FL == "Y")

usethis::use_data(aesi, overwrite = TRUE, compress = "xz")
