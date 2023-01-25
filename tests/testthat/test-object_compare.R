# tests for comparison of data objects
context("test-git_object_compare")

test_that("Use full pdata name. Expect Warning for Differences.", {
   
expect_warning(with_tempdir({
  ## Create directories and initialize repositories
  path_bare <- tempfile(pattern = "example")
  path_repo_1 <- tempfile(pattern = "example")
  
  dir.create(path_bare)
  dir.create(path_repo_1)
  repo_bare <- init(path_bare, bare = TRUE)
  ## Clone to repo 1 and config user
  repo_1 <- clone(path_bare, path_repo_1)
  config(repo_1, user.name = "User", user.email = "User@example.org")
  
  
  ## Add changes to repo 1 and push to bare
  df <- data.frame(x = c(1:10), y = c(11:20))
  save(df, file = file.path(path_repo_1, "df.rda"))
  
  add(repo_1, "df.rda")
  commit(repo_1, "data object v1")
  push(repo_1, "origin", "refs/heads/master")
  SHA1 <- last_commit(repo_1)$sha
  
  df <- data.frame(x = c(1:10), y = c(1:10))
  save(df, file = file.path(path_repo_1, "df.rda"))
  
  add(repo_1, "df.rda")
  commit(repo_1, "data object v2")
  push(repo_1, "origin", "refs/heads/master")
  SHA2 <- last_commit(repo_1)$sha
  with_dir(path_repo_1, {
    git_object_compare(data_object = "df",
                       SHA1 = SHA1,
                       SHA2 = SHA2)
  })
}),
"Not all Values Compared Equal")
})

test_that("Use suffix pdata name. Expect Warning for Differences.", {
   
expect_warning(with_tempdir({
  ## Create directories and initialize repositories
  path_bare <- tempfile(pattern = "example")
  path_repo_1 <- tempfile(pattern = "example")
  
  dir.create(path_bare)
  dir.create(path_repo_1)
  repo_bare <- init(path_bare, bare = TRUE)
  ## Clone to repo 1 and config user
  repo_1 <- clone(path_bare, path_repo_1)
  config(repo_1, user.name = "User", user.email = "User@example.org")
  
  
  ## Add changes to repo 1 and push to bare
  df <- data.frame(x = c(1:10), y = c(11:20))
  save(df, file = file.path(path_repo_1, "df.rda"))
  
  add(repo_1, "df.rda")
  commit(repo_1, "data object v1")
  push(repo_1, "origin", "refs/heads/master")
  SHA1 <- last_commit(repo_1)$sha
  
  df <- data.frame(x = c(1:10), y = c(1:10))
  save(df, file = file.path(path_repo_1, "df.rda"))
  
  add(repo_1, "df.rda")
  commit(repo_1, "data object v2")
  push(repo_1, "origin", "refs/heads/master")
  SHA2 <- last_commit(repo_1)$sha
  with_dir(path_repo_1, {
    git_object_compare(data_object = "f",
                       SHA1 = SHA1,
                       SHA2 = SHA2)
  })
}),
"Not all Values Compared Equal")
})

test_that("Use pdata object. Expect Text Indicating No Differences.", {
  
  expect_equal(with_tempdir({
    ## Create directories and initialize repositories
    path_bare <- tempfile(pattern = "example")
    path_repo_1 <- tempfile(pattern = "example")
    
    dir.create(path_bare)
    dir.create(path_repo_1)
    repo_bare <- init(path_bare, bare = TRUE)
    ## Clone to repo 1 and config user
    repo_1 <- clone(path_bare, path_repo_1)
    config(repo_1, user.name = "User", user.email = "User@example.org")
    
    
    ## Add changes to repo 1 and push to bare
    df <- data.frame(x = c(1:10), y = c(11:20))
    save(df, file = file.path(path_repo_1, "df.rda"))
    
    add(repo_1, "df.rda")
    commit(repo_1, "data object v1")
    push(repo_1, "origin", "refs/heads/master")
    SHA1 <- last_commit(repo_1)$sha
    
    df <- data.frame(x = c(1:10), y = c(1:10))
    save(df, file = file.path(path_repo_1, "df.rda"))
    
    add(repo_1, "df.rda")
    commit(repo_1, "data object v2")
    push(repo_1, "origin", "refs/heads/master")
    SHA2 <- last_commit(repo_1)$sha
    with_dir(path_repo_1, {
      git_object_compare(data_object = df)$differences
    })
  }),
  "No issues were found!")
})

test_that("Warning Message is Shown When Differences Are Detected",{
  df<-data.frame(x=c(1:10),y=c(6:15))
  df2<-data.frame(x=c(1:10), y=c(15:24))
  expect_warning(
    obj_compare(df,df2),
    "Not all Values Compared Equal"
  )
})


test_that("Character String Outputed When No Differences Detected",{
  df<-data.frame(x=c(1:10),y=c(6:15))
 expect_equal(
    obj_compare(df,df),
   "No issues were found!"
  )
})
