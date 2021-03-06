#' A function for input validation
#'
#' @param obj The object that undergoes validation
#' @param argument_name A string indicating the name of the object
#'   This name is used when an error is thrown so the user
#'   is informed on the cause of the error.
#' @param class_string A character vector of legal classes. If
#'   \code{class_string} is "numeric", it will be expanded to
#'   c("numeric", "integer", "double"). The class is tested via the
#'   function \code{class}. This means that if \code{obj} is a matrix,
#'   it is necessary to pass \code{class_string = "matrix"}; you cannot
#'   refer to the "mode" of the matrix. A special case is the
#'   \code{class_string} "groupvar" that is expanded to
#'   c("factor", "character", "numeric", "integer", "double").
#' @param len Optional numeric vector for objects having a length
#'   (mostly for vectors).
#' @param gt0 Optional logical vector indicating if numeric input has
#'   to be greater than 0.
#' @param must_be_integer Optional logical vector indicating if numeric
#'   input has to be integer.
#' @param groupsize Optional argument how many groups a grouping variable
#'   consist of.
#' @param input_set Optional argument specifying a set of values an
#'   argument can take.
#'
#' @details
#' Taken from the package \code{\link{prmisc}} by Martin Papenberg.
#' Git: https://github.com/m-Py/prmisc
#'
#' @return NULL
#'
#' @noRd

validate_input <- function(obj, argument_name, class_string = NULL, len = NULL,
                           gt0 = FALSE, must_be_integer = FALSE, groupsize = NULL,
                           input_set = NULL) {

  self_validation(argument_name, class_string, len, gt0,
                  must_be_integer, groupsize, input_set)

  ## - Check class of object
  if (argument_exists(class_string))  {
    # Allow for all numeric types:
    if ("numeric" %in% class_string) {
      class_string <- c(class_string, "integer", "double")
    }
    # Case - grouping variable: Allow for numeric, character or factor
    if ("groupvariable" %in% class_string) {
      class_string <- setdiff(c(class_string, "factor", "character",
                                "numeric", "integer", "double"),
                              "groupvariable")
    }
    correct_class <- class(obj) %in% class_string
    if (!correct_class) {
      stop(argument_name, " must be of class '",
           paste(class_string, collapse = "' or '"), "'")
    }
  }

  ## - Check length of input
  if (argument_exists(len)) {
    if (length(obj) != len) {
      stop(argument_name, " must have length ", len)
    }
  }

  ## - Check if input has to be greater than 0
  if (gt0 == TRUE && any(obj <= 0)) {
    stop(argument_name, " must be greater than 0")
  }

  ## - Check if input has to be integer
  if (must_be_integer == TRUE && any(obj %% 1 != 0)) {
    stop(argument_name, " must be integer")
  }
  ## - Check if correct number of groups is provided
  if (argument_exists(groupsize)) {
    if (length(table(obj)[table(obj) != 0]) != groupsize) {
      stop(argument_name, " must consist of exactly ", groupsize,
           " groups with more than 0 observations.")
    }
  }

  ## - Check if argument matches a predefined input set
  if (argument_exists(input_set)) {
    if (!obj %in% input_set) {
      stop(argument_name, " can either be set to '",
           paste(input_set, collapse = "' or '"), "'")
    }
  }

  return(invisible(NULL))
}

## Validate input for the `validate_input` function (these errors are
## not for users, but only for developers)
self_validation <- function(argument_name, class_string, len, gt0,
                            must_be_integer, groupsize,
                            input_set) {
  if (argument_exists(class_string)) {
    stopifnot(class(class_string) == "character")
    stopifnot(class(argument_name) == "character")
  }
  if (argument_exists(len)) {
    stopifnot(class(len) %in% c("numeric", "integer"))
    stopifnot(length(len) == 1)
    stopifnot(len >= 0)
    stopifnot(len %% 1 == 0)
  }
  stopifnot(class(gt0) == "logical")
  stopifnot(length(gt0) == 1)
  stopifnot(class(must_be_integer) == "logical")
  stopifnot(length(must_be_integer) == 1)

  if (argument_exists(groupsize)) {
    stopifnot(mode(groupsize) == "numeric")
    stopifnot(length(groupsize) == 1)
  }

  if (argument_exists(input_set) && len != 1) {
    stop("If an input set is passed, argument len must be 1 ",
         "(this message should not be seen by users of the package prmisc).")
  }

  return(invisible(NULL))
}

argument_exists <- function(arg) {
  !is.null(arg)
}
