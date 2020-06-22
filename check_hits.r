check_hits = function(hits) {
  # basic check - if matches in both, return TRUE
  any(!is.na(hits$emp)) & any(!is.na(hits$date_hit))
}
