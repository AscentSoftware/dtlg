substitute_q <- function(x, env = parent.frame()) {
  call <- substitute(substitute(y, env), list(y = x))
  eval(call)
}
