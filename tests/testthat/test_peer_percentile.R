context("assessment peer percentiles")

parcc_grade <- fetch_all_parcc()

parcc_years <- c(2018, 2017, 2016, 2015)

math_k11_agg <- map_df(
  parcc_years,
  function(x) calculate_agg_parcc_prof(
    end_year = x, 
    subj = 'math'
  )
)

ela_k11_agg <- map_df(
  parcc_years,
  function(x) calculate_agg_parcc_prof(
    end_year = x, 
    subj = 'ela'
  )
)

math_k8_agg <- map_df(
  parcc_years,
  function(x) calculate_agg_parcc_prof(
    end_year = x, 
    subj = 'math',
    k8 = TRUE
  )
)

ela_k8_agg <- map_df(
  parcc_years,
  function(x) calculate_agg_parcc_prof(
    end_year = x, 
    subj = 'ela',
    k8 = TRUE
  )
)

parcc_agg_all <- bind_rows(parcc_grade, math_k11_agg, ela_k11_agg, math_k8_agg, ela_k8_agg) %>%
  ungroup()


test_that("parcc peer percentile works with 2017 math data", {
  p <- fetch_parcc(2017, 4, 'math', tidy = TRUE)
  
  p_sch <- p %>% filter(is_school)
  p_sch_ile <- assessment_peer_percentile(p_sch)
  
  expect_is(p_sch_ile, 'data.frame')
  expect_is(p_sch_ile, 'tbl_df')
  
  p_sch_ile %>%
    filter(subgroup == 'total_population') -> foo3
})


test_that("parcc statewide percentiles make sense", {

  parcc_statewide_percentile <- statewide_peer_percentile(parcc_agg_all)
  
  sped_k11_dist_math <- parcc_statewide_percentile %>% 
    filter(test_name == 'math' & subgroup=='special_education') %>% 
    filter(grade=='K-11') %>% 
    filter(testing_year==2018) %>% 
    filter(is_district) %>%
    select(-districts, -schools)
  
  expect_is(sped_k11_dist_math, 'data.frame')
  expect_is(sped_k11_dist_math, 'tbl_df')
  
  expect_equal(nrow(sped_k11_dist_math), 654)
  expect_equal(max(sped_k11_dist_math$statewide_scale_n, na.rm=TRUE), 515)
  
  sped_k11_dist_ela <- parcc_statewide_percentile %>% 
    filter(test_name == 'ela' & subgroup=='special_education') %>% 
    filter(grade=='K-11') %>% 
    filter(testing_year==2018) %>% 
    filter(is_district) %>%
    select(-districts, -schools)
  
  expect_is(sped_k11_dist_ela, 'data.frame')
  expect_is(sped_k11_dist_ela, 'tbl_df')
  
  expect_equal(nrow(sped_k11_dist_ela), 654)
  expect_equal(max(sped_k11_dist_ela$statewide_scale_n, na.rm=TRUE), 517)
  
  worst_math <- sped_k11_dist_math %>% 
    filter(!is.na(statewide_scale_percentile)) %>% 
    arrange(statewide_scale_percentile) %>% 
    pull(district_name) %>% head()
  
  best_math <- sped_k11_dist %>% 
    filter(!is.na(statewide_scale_percentile)) %>% 
    arrange(-statewide_scale_percentile) %>% 
    pull(district_name) %>% head()
  
  expect_equal(
    worst_math,
    c("Somerset Co Vocational", "Hope Community Cs", "Asbury Park City", 
      "Camden City", "Prospect Park Boro", "University Heights Cs")
  )
  
  expect_equal(
    best_math,
    c("Mendham Twp", "Hatikvah International Cs", "Allendale Boro", 
      "Upper Saddle River Boro", "River Edge Boro", "Ho Ho Kus Boro"
    )
  )
})