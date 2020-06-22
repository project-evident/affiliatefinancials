imports = read_rds("imports.rds")

all_hits = map(imports, pluck, "hits") %>%
  set_names(names(imports)) %>%
  bind_rows(.id = "file") %>% 
  unnest(emp_hit) %>%
  unnest(date_hit) %>%
  filter(!is.na(emp_hit) | !is.na(date_hit) | !is.na(emp) | !is.na(date))

all_hits = all_hits %>%
  mutate(
    affiliate = str_replace(file, pattern = "_.*", ""),
    state = substr(affiliate, start = nchar(affiliate) - 1, stop = nchar(affiliate)),
    year = as.integer(str_extract(file, "20[12][0-9]")),
    emp = as.numeric(as.character(emp))
  ) %>%
  select(file, affiliate, state, year, everything())

all_hits = all_hits %>%
  group_by(file) %>%
  mutate(status = case_when(
    n() > 1 & (n_distinct(emp) > 1 | n_distinct(date) > 1) ~ "Multiple matches differing INSPECT",
    n() > 1 ~ "Multiple matches look the same - COLLAPSE",
    !is.na(emp) & !is.na(date) ~ "Good match",
    !is.na(emp) ~ "Employment only match",
    !is.na(date) ~ "Date only match",
    TRUE ~ "Page found no match"
  ))

all_hits = all_hits %>%
  full_join(tibble(file = names(imports))) %>%
  mutate(status = case_when(
    is.na(status) ~ "No match",
    TRUE ~ status
  ))

write_csv(all_hits, path = "imported_results.csv")
