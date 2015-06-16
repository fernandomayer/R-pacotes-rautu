##' @title Faz a Soma de Dois Números
##' @name soma
##'
##' @description Uma (incrível) função que pega dois números e faz a
##'     soma. Utilize este campo para descrever melhor o propósito de
##'     sua função e o que ela é capaz de fazer.
##'
##' @param x Um número
##' @param y Outro número
##'
##' @details Utilize este campo para escrever detalhes mais técnicos da
##'     sua função (se necessário), ou para detalhar melhor como
##'     utilizar determinados argumentos.
##'
##' @return A soma dos números \code{x} e \code{y}.
##'
##' @author Fernando Mayer
##'
##' @seealso \code{\link[base]{sum}}, \code{\link[base]{"+"}}
##'
##' @examples
##' soma(2, 2)
##'
##' x <- 3
##' y <- 4
##' soma(x = x, y = y)
##'
##' ## Erro
##' z <- "a"
##' soma(x = x, y = z)
##'
##' @export
soma <- function(x, y){
    x + y
}
