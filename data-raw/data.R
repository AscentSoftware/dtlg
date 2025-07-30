library(random.cdisc.data)

adsl <- random.cdisc.data::cadsl
adlb <- random.cdisc.data::cadlb
adae <- random.cdisc.data::cadae

usethis::use_data(adsl, overwrite = TRUE, compress = "xz")
usethis::use_data(adlb, overwrite = TRUE, compress = "xz")
usethis::use_data(adae, overwrite = TRUE, compress = "xz")
