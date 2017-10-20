<!--#include file="lib\asp\conexao_bd.asp"-->
<!--#include file="lib\asp\funcoes.asp"-->

<%
  'Formata data DD/MM/AAAA
    SESSION.LCID = 1046 'Português (Brasileiro) 

  'Se ocorrer erro prossegue carregamento da página
    on error resume next  
%>

<!DOCTYPE html>
<html lang="pt-br">

  <head>
      <meta charset="UTF-8">
      <meta name="author" content="c115765 - Fabiano Souza Silva">
      <link rel="icon" href="lib/img/icone.png">

      <title>Internet Banking Caixa - Extrato</title>
      <!-- Bootstrap -->
      <link href="lib/css/bootstrap.min.css" rel="stylesheet"  >
      <meta name="viewport" content="width=device-width, initial-scale=1.0">

      <link href="lib/css/estilos.css" rel="stylesheet">
      <link href="lib/css/impressao.css" rel="stylesheet">
      <link href="lib/css/font-awesome.min.css" rel="stylesheet">
      <link href="lib/css/grid.css" rel="stylesheet"> 

      <script src="lib/js/jquery-3.2.1.min.js"></script>
      <script src="lib/js/bootstrap.min.js"></script>
      <script src="lib/js/jquery.mask.min.js"></script>
      <script src="lib/js/mascara_formatacao.js"></script>
      <script src="lib/js/validator.min.js"></script>
      <script src="lib/js/jquery.dataTables.min.js"></script>
      <script src="lib/js/jspdf.min.js"></script>

      <script src="lib/js/carrega_dados.js"></script>
      <script src="lib/js/extrato.js"></script>
  </head>

  <body >
      <div class="navbar  navbar-fixed-top bg_azul" role="navigation">
          <div class="container">
              <div class="navbar-header">
                  <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                      <span class="sr-only">Toggle navigation</span>
                      <span class="icon-bar"></span>
                      <span class="icon-bar"></span>
                      <span class="icon-bar"></span>
                  </button>

                <div class="navbar-brand"> 
                  <a href=# > 
                      <img id="logo_menu" src="lib/img/logo_caixa.png"> 
                  </a>
                </div>
              </div>

              <div class="navbar-collapse collapse">
                  <div class="col-sm-3 col-md-5 col-lg-5">
                      <form class="navbar-form" role="search" method="get" id="search-form" name="search-form">
                          <div class="input-group">
                              <input type="text" class="form-control" placeholder="Digite o que você procura... (Ex. extrato, saldo, etc.)" id="Pesquisa" name="Pesquisa" value="">

                              <div class="icone_pesquisa">
                                   <i class="fa fa-search " aria-hidden="true"></i>
                              </div>
                          </div>
                      </form>
                  </div>


                  <div id="InformacaoContaSelecionada" class="col-sm-5 col-md-4 col-lg-4">
                      <strong>Fabiano Souza Silva</strong><br>
                      Agência: <span class="DestaqueAzulClaro" data-toggle="tooltip" data-placement="bottom" title="Ag. Vila Virgínia, SP">3811 </span> Operação: <span class="DestaqueAzulClaro" data-toggle="tooltip" data-placement="bottom" title="Conta Corrente">001 </span> Conta: <span class="DestaqueAzulClaro">12345678-3</span>
                      &nbsp; 
                      <a href=#> 
                          <i class="fa fa-random" aria-hidden="true"  data-toggle="tooltip" data-placement="bottom" title="Trocar conta"></i>
                      </a>
                  </div>

                  <div  id="SairSistema" class="col-sm-1 col-md-1 col-lg-1 navbar-right">
                      <a href="../default.asp" data-toggle="tooltip" data-placement="bottom" title="Clique para sair com segurança"> 
                          <img src="lib/img/sair.png"><strong>Sair</strong>
                      </a>
                  </div>

              </div>
          </div>
      </div>

      <br><br><br><br>

      <div class="container">
          <div class="row">
            <div class="col-md-3">
                <div class="list-group">
                  <a href="#" class="list-group-item "><i class="fa fa-home cor_azul" aria-hidden="true"></i> Início</a>
                  <a href="#" class="list-group-item active"><i class="fa fa-bars cor_laranja" aria-hidden="true"></i > Conta Corrente</a>
                  <a href="#" class="list-group-item"> <span class="glyphicon glyphicon-piggy-bank cor_azul"></span>  Poupança</a>
                  <a href="#" class="list-group-item"><i class="fa fa-barcode cor_azul" aria-hidden="true"></i> Pagamentos</a>
                  <a href="#" class="list-group-item"><i class="fa fa-credit-card-alt cor_azul" aria-hidden="true"></i> Cartões</a>
                  <a href="#" class="list-group-item"><i class="fa fa-line-chart cor_azul" aria-hidden="true"></i> Investimentos</a>
                  <a href="#" class="list-group-item"><i class="fa fa-exchange cor_azul" aria-hidden="true"></i> Transferências <span style="color: #cccccc; font-size: 12px;">(DOC, TED, TEV)</span></a>
                  <a href="#" class="list-group-item"><i class="fa fa-money cor_azul" aria-hidden="true"></i> Cobrança Bancária</a>
                  <a href="#" class="list-group-item"><i class="fa fa-user cor_azul" aria-hidden="true"></i> Previdência</a>
                  <a href="#" class="list-group-item"><i class="fa fa-lock cor_azul" aria-hidden="true"></i> Seguros</a>
                  <a href="#" class="list-group-item"><i class="fa fa-file-text cor_azul" aria-hidden="true"></i> Consórcio</a>
                  <a href="#" class="list-group-item"><i class="fa fa-question-circle cor_azul" aria-hidden="true"></i> Ajuda</a>
                </div>
            </div>

            <div class="col-md-9">

                  <div class="row">
                      <div class="col-md-12">
                          <ol class="breadcrumb">
                            <li><a href="#">Conta Corrente</a></li>
                            <li class="active">Extrato</li>
                          </ol>
                      </div>
                  </div>

                  <div class="row">
                      <div class="col-md-12">
                          <hr>
                          <span class="cor_cinza"> Atualizado em: <%=now()%> </span>

                          <div class="text-right texto_direita_flutuante ">
                              <a href=#  onclick="imprimeDIV('#Extrato')"><i class="fa fa-print" aria-hidden="true"></i> Imprimir</a>
                              <a href=#><i class="fa fa-file-pdf-o" aria-hidden="true"></i> Salvar PDF </a>
                              <a href=#><i class="fa fa-file-excel-o" aria-hidden="true"></i> Salvar Excel </a>
                              <a href=#><i class="fa fa-cog" aria-hidden="true"></i> Outros Formatos</a>
                          </div> 

                          <hr>
                      </div>
                  </div>

                  <div id="Extrato" >
                      <div class="row">
                          <div class="col-md-12">
                              <h4>Extrato de Conta Corrente</h4>
                           </div>
                      </div>

                      <div class="row ">
                          <div class="col-md-12">
                                <form class="form-inline cor_cinza" id="formPeriodoExtrato" data-toggle="validator">
                                    <div class="form-group">
                                        <label class="control-label " for="IC_PERIODO">Período de consulta:</label> 
                                        <span id="IC_PERIODO_Imprimir"></span>
                                        <select class="form-control custom-select mb-2 mr-sm-2 mb-sm-0 NaoImprimi" name="IC_PERIODO" id="IC_PERIODO">
                                                <option value="D-7"> Últimos 7 dias </option>
                                                <option value="MesAtual"> Mês Atual </option>
                                                <option value="Ultimos3Meses" > Últimos 3 meses </option>
                                                <option value="EspecificarPeriodo" > Especificar Período </option>
                                        </select>
                                    </div>

                                      <span id="ParametrosPeriodo" class="NaoImprimi" >
                                          <div class="form-group">
                                              <label class="form-group pl-5" for="DT_INICIO"> &emsp; de </label> 
                                              <input type="text" class="form-control MA_REF" name="DT_INICIO" id="DT_INICIO" placeholder="__/____"  data-minlength="7" required>
                                          </div>

                                          <div class="form-group">
                                            <label class="form-group mr-sm-1" for="DT_TERMINO"> &emsp; até</label> 
                                            <input type="text" class="form-control MA_REF" name="DT_TERMINO" id="DT_TERMINO" placeholder="__/____" data-minlength="7" required>
                                          </div>                                        

                                          <div class="form-group">
                                             &emsp; <button type="submit" class="btn btn-primary" id="btnCarregarPeriodo">OK</button>
                                          </div>

                                      </span>

                                </form>
                          </div>
                      </div>

                      <hr>
                      
                      <div id="insereSaldosAqui"></div>
                      
                      <hr>

                      <div class="row">
                          
                           <div class="col-md-12 cor_cinza">
                               <h5>Detalhe de Lançamentos</h5>
                               <p>
                                   <form class="form-inline cor_cinza" id="formDetalheExtrato">
                                      Exibir:  &emsp;
                                      <input type="radio" name="IC_TIPO_LANCAMENTO" checked  id="detalheLancamento_Tudo" value="T">
                                      <label for="detalheLancamento_Tudo">Tudo</label>&emsp;

                                      <input type="radio" name="IC_TIPO_LANCAMENTO"  id="detalheLancamento_Entrada" value="C">
                                      <label for="detalheLancamento_Entrada">Entrada</label>&emsp;

                                      <input type="radio" name="IC_TIPO_LANCAMENTO" id="detalheLancamento_Saida" value="D">
                                      <label for="detalheLancamento_Saida">Saída</label>&emsp;

                                      <input type="radio" name="IC_TIPO_LANCAMENTO"  id="detalheLancamento_Futuro" value="F">
                                      <label for="detalheLancamento_Futuro">Futuro</label>
     
                                    </form>
                                </p>
                              <hr>
                          </div> 
                      </div>  

                      
                      <div id="carregando" class="text-center cor_cinza"></div>
                      <div id="insereTabelaExtratoAqui"></div>

                      
                      <div class="row NaoImprimi">
                          <div class="col-md-12">
                              <hr>
                             
                              <div class="text-center padding-12 " >
                                  <a href=#  onclick="imprimeDIV('#Extrato')" ><i class="fa fa-print" aria-hidden="true" ></i> </span>Imprimir</a>
                                  <a href=#><i class="fa fa-file-pdf-o" aria-hidden="true"></i> Salvar PDF </a>
                                  <a href=#><i class="fa fa-file-excel-o" aria-hidden="true"></i> Salvar Excel </a>
                                  <a href=#><i class="fa fa-cog" aria-hidden="true"></i> Outros Formatos</a>
                              </div> 

                              <hr>
                          </div>
                      </div>

                  </div>
              </div>
          </div>

          <br>
          <div class="row">
            <div class="col-md-12">
                
                <!-- Modal Detalhe do lançamento-->
                <div class="modal fade" id="modalDetalheLancamento" tabindex="-1" role="dialog" aria-labelledby="modalDetalheLancamentoLabel">
                  <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                      <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="myModalLabel">Detalhes do Lançamento</h4>
                      </div>
                      <div class="modal-body">
                          <input id="NU_DOCUMENTO" name="NU_DOCUMENTO" type="hidden" value="">
                          <input id="TIPO_DOCUMENTO" name="TIPO_DOCUMENTO" type="hidden" value="">
                          <div id="insereDetalheLancamentoAqui"></div>
                      </div>
                      <div class="modal-footer">
                        <impi>
                        <button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button>
                        <button type="button" class="btn btn-primary" id="download_pdf" onclick="salvarPDF($('#NU_DOCUMENTO').val(), $('#TIPO_DOCUMENTO').val())"> <i class="fa fa-file-pdf-o" aria-hidden="true"></i> Salvar PDF</button> <!---->
                        <button type="button" class="btn btn-primary"  id="Imprimir_Comprovante" onclick="imprimeDIV('#insereDetalheLancamentoAqui')"> <i class="fa fa-print" aria-hidden="true"></i> Imprimir</button>
                      </div>
                    </div>
                  </div>
                </div>
            </div>
          </div>  
          <br><br>   
      </div>


      <footer class="footer bg_azul cor_branca">
          <div class="container">
            <div class="row">
                <div class="col-md-3">
                     <span> Caixa Econômica Federal </span>
                </div>

                <div class="col-md-7">
                     <span> Segurança </span> &emsp; 
                      <span> Atendimento ao Cliente </span>
                </div>  

                <div class="col-md-2">
                     <span > Redes Sociais:  </span > 

                      <span style="color: #cccccc; font-size: 18px; float: right;">
                        <i class="fa fa-facebook-official" aria-hidden="true"></i>
                        <i class="fa fa-twitter-square" aria-hidden="true"></i>
                        <i class="fa fa-youtube-square" aria-hidden="true"></i>
                     </span>
                </div>
            </div>  
          </div> 

          <bottom  id="voltar-topo" class="btn btn-lg voltar-topo" role="button" title="Voltar ao topo" data-toggle="tooltip" data-placement="left">
              <span class="glyphicon glyphicon-chevron-up"></span>
          </bottom> 
      </footer>

  </body>

</html>