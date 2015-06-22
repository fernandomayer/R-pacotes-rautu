#' @title Faz um Grafico Personalizado
#' @name meuxy
#'
#' @description Uma (incrivel) funcao para fazer um xyplot
#'     personalizado. Usando o pacote lattice.
#'
#' @param x Uma formula do lattice
#' @param ... Outros argumentos passados para a funcao
#'     \code{\link[lattice]{xyplot}}
#'
#' @details Utilize este campo para escrever detalhes mais tecnicos da
#'     sua funcao (se necessario), ou para detalhar melhor como
#'     utilizar determinados argumentos.
#'
#' @return Um grafico xyplot do lattice com \code{pch = 4} e \code{col =
#'     1}.
#'
#' @author Fernando Mayer
#'
#' @seealso \code{\link[lattice]{xyplot}}
#'
#' @examples
#' meuxy(1:10 ~ 1:10)
#'
#' @importFrom lattice xyplot
#'
#' @export
meuxy <- function(x, ...){
    xyplot(x, pch = 4, col = 1, ...)
}
