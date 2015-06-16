#' @title Faz a Soma de Dois Numeros
#' @name soma
#'
#' @description Uma (incrivel) funcao que pega dois numeros e faz a
#'     soma. Utilize este campo para descrever melhor o proposito de
#'     sua funcao e o que ela e capaz de fazer.
#'
#' @param x Um numero
#' @param y Outro numero
#'
#' @details Utilize este campo para escrever detalhes mais tecnicos da
#'     sua funcao (se necessario), ou para detalhar melhor como
#'     utilizar determinados argumentos.
#'
#' @return A soma dos numeros \code{x} e \code{y}.
#'
#' @author Fernando Mayer
#'
#' @seealso \code{\link[base]{sum}}, \code{\link[base]{+}}
#'
#' @examples
#' soma(2, 2)
#'
#' x <- 3
#' y <- 4
#' soma(x = x, y = y)
#'
#' @export
soma <- function(x, y){
    x + y
}
