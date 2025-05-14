#### Operations on stratigraphic sections ####

split_sections <- function(df) {
  sections <- list()
  sections$time_Myr <- df$time..Myr.
  sections$sc1 <- data.frame(df[,2:4])
  sections$sc2 <- data.frame(df[,5:7])
  sections$sc3 <- data.frame(df[,8:10])
  return(sections)
}

collapse_section <- function(df) {
  section <- data.frame(
    thickness = apply(df, 1, max),
    facies = apply(df, 1, function(row) names(df)[which.max(row)])
  )
  section <- section[section$thickness != 0, ]
  # turn into numbers
  section$facies <- as.numeric(gsub(".*_f(.).*", "\\1", section$facies))
  # cumulative thickness
  section$thickness <- cumsum(section$thickness)
  # reverse the order of rows so oldest are at the bottom
  section <- section[seq(dim(section)[1],1),]
  return(section)
}

calculate_p_value <- function(bootstrap_samples, observed_value) {
  p_value <- mean(bootstrap_samples >= observed_value)
  return(p_value)
}
