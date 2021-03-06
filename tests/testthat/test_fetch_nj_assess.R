context("functions in fetch_nj_assess.R")

test_that("valid_call correctly identifies status of years/grade pairs", {

  expect_true(valid_call(2014, 8))
  expect_false(valid_call(2014, 12))
  
  expect_true(valid_call(2007,8))
  expect_false(valid_call(2005, 5))  
})

test_that("standard_assess correctly calls data for 2014",{
  
  hspa_ex <- standard_assess(2014, 11)
  
  expect_equal(nrow(hspa_ex), 742)
  expect_equal(ncol(hspa_ex), 560)
  expect_equal(
    sum(hspa_ex$GENERAL_EDUCATION_Number_Enrolled_LAL, na.rm = TRUE), 405655
  )
  expect_equal(
    sum(hspa_ex$GENERAL_EDUCATION_LANGUAGE_ARTS_Scale_Score_Mean, na.rm = TRUE), 
    174325.5, tolerance = 0.01 
  )
  
  njask_ex <- standard_assess(2014, 7)
  expect_equal(nrow(njask_ex), 1329)
  expect_equal(ncol(njask_ex), 551)
  expect_equal(
    sum(njask_ex$GENERAL_EDUCATION_Number_Enrolled_ELA, na.rm = TRUE), 420111
  )
  expect_equal(
    sum(njask_ex$GENERAL_EDUCATION_LANGUAGE_ARTS_Scale_Score_Mean, na.rm = TRUE),
    265911.4, tolerance = 0.01 
  )
  
})


test_that("fetch_old_nj_assess returns correct output for a variety of calls", {
  
  #2014 njask
  njask_14 <- fetch_old_nj_assess(2014, 6)

  expect_equal(nrow(njask_14), 1505)
  expect_equal(ncol(njask_14), 551)
  expect_equal(
    sum(njask_14$GENERAL_EDUCATION_Number_Enrolled_ELA, na.rm = TRUE), 412827
  )
  
  #2014 hspa
  hspa_14 <- fetch_old_nj_assess(2014, 11)
  expect_equal(nrow(hspa_14), 742)
  expect_equal(ncol(hspa_14), 560)
  expect_equal(
    sum(hspa_14$GENERAL_EDUCATION_Number_Enrolled_LAL, na.rm = TRUE), 405655
  )
  
  #2007 gepa
  gepa_07 <- fetch_old_nj_assess(2007, 11)
  expect_equal(nrow(gepa_07), 681)
  expect_equal(ncol(gepa_07), 529)
  expect_equal(
    sum(gepa_07$GENERAL_EDUCATION_Number_Enrolled, na.rm = TRUE), 410704
  )
  
  #2004 gr3
  njask_04 <- fetch_old_nj_assess(2004, 3)
  expect_equal(nrow(njask_04), 1956)
  expect_equal(ncol(njask_04), 363)
  expect_equal(
    sum(njask_04$GENERAL_EDUCATION_Number_Enrolled, na.rm = TRUE), 418669
  )

})