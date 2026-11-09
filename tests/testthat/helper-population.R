#
# Small subject- and event-level fixtures for denominator tests.
#
# Six subjects, three per arm; B2 died. A1 has three adverse events, so the
# event-level data repeats A1. Each function returns a fresh data frame so
# that reference copy semantics cannot leak changes between tests.
#

adsl6 <- function() {
  data.frame(
    USUBJID = c("A1", "A2", "A3", "B1", "B2", "B3"),
    ARM = rep(c("Drug A", "Placebo"), each = 3L),
    DTHFL = c("N", "N", "N", "N", "Y", "N")
  )
}

adae6 <- function() {
  data.frame(
    USUBJID = c("A1", "A1", "A1", "A2", "B1", "B2"),
    ARM = rep(c("Drug A", "Placebo"), times = c(4L, 2L)),
    AEBODSYS = c("Nervous", "Nervous", "GI", "Nervous", "Nervous", "GI"),
    AEDECOD = c(
      "Headache", "Dizziness", "Nausea", "Headache", "Headache", "Nausea"
    ),
    SER = c(FALSE, TRUE, FALSE, FALSE, FALSE, TRUE)
  )
}

# Normal-range indicator at two visits. Baseline: Drug A High 1, Normal 2;
# Placebo Normal 3. Week 4: Drug A High 2, Normal 1; Placebo High 1, Normal 2.
labs6 <- function() {
  data.frame(
    USUBJID = rep(c("A1", "A2", "A3", "B1", "B2", "B3"), times = 2L),
    ARM = rep(rep(c("Drug A", "Placebo"), each = 3L), times = 2L),
    AVISIT = rep(c("Baseline", "Week 4"), each = 6L),
    ANRIND = c(
      "High", "Normal", "Normal", "Normal", "Normal", "Normal",
      "High", "High", "Normal", "High", "Normal", "Normal"
    )
  )
}
