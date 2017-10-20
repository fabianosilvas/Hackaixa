<!--#include file="lib\asp\conexao_bd.asp"-->
<!--#include file="lib\asp\funcoes.asp"-->

<%
'Abre concexão com SQL Server'
    Call abre_conexao_SQL(conexao)

'Se ocorrer erro prossegue carregamento da página
    on error resume next  

'Atribui Variaveis 
   IC_PERIODO = "D-7" 'request.form("IC_PERIODO")
   DT_INICIO = request.form("DT_INICIO")
   DT_TERMINO = request.form("DT_TERMINO")
   IC_TIPO_LANCAMENTO = "F" 'request.form("IC_TIPO_LANCAMENTO")
   MM_ATUAL = month(now())
   AA_ATUAL = year(now())
  
'Monta conulta SQL 
  Select Case IC_PERIODO
      Case "D-7"
            SQL = "SELECT * FROM [HACKAIXA].[IBC].[EXTRATO] WHERE DT_REF BETWEEN DATEADD(DAY, -7, GETDATE()) AND GETDATE()"
      Case "MesAtual"
            SQL = "SELECT * FROM [HACKAIXA].[IBC].[EXTRATO] WHERE MONTH(DT_REF) = " & MM_ATUAL & " AND YEAR(DT_REF) = " & AA_ATUAL
      Case "Ultimos3Meses"
            SQL = "SELECT * FROM [HACKAIXA].[IBC].[EXTRATO] WHERE [DT_REF] BETWEEN DATEADD(M, -3,  GETDATE() )  AND GETDATE()"
      Case "EspecificarPeriodo"
            if len(DT_INICIO) = 7 and len(DT_TERMINO) = 7 then
                SQL = "SELECT * FROM [HACKAIXA].[IBC].[EXTRATO] WHERE CAST(YEAR(DT_REF) AS VARCHAR) + RIGHT('00' + CAST(MONTH(DT_REF) AS VARCHAR), 2)  BETWEEN " & CSTR(YEAR(DT_INICIO)) & RIGHT(00 & CSTR(MONTH(DT_INICIO)),2)  &" AND " & CSTR(YEAR(DT_TERMINO)) & RIGHT(00 & CSTR(MONTH(DT_TERMINO)),2)
            else
                response.end
            end if 
  End Select

 'Complementa consulta SQL
  Select Case IC_TIPO_LANCAMENTO
      Case "T"
            SQL = SQL & " AND IC_TIPO_LANCAMENTO <> 'F' "
            SQL_LancamentosFuturos = "SELECT * FROM [HACKAIXA].[IBC].[EXTRATO] WHERE IC_TIPO_LANCAMENTO = 'F'"
            set rsLancamentosFuturos = conexao.execute(SQL_LancamentosFuturos)
      Case "F"
            SQL_LancamentosFuturos = "SELECT * FROM [HACKAIXA].[IBC].[EXTRATO] WHERE IC_TIPO_LANCAMENTO = 'F'"
            set rsLancamentosFuturos = conexao.execute(SQL_LancamentosFuturos)
      Case else 
            SQL = SQL & " AND IC_TIPO_LANCAMENTO = '" & IC_TIPO_LANCAMENTO & "'"
  End Select
   
   'Executa consulta SQL
   Set rsExtrato = Server.CreateObject("ADODB.recordset") 
       rsExtrato.Open SQL, conexao, 3,3
  'set rsExtrato=conexao.execute(SQL)
%>


<html lang="pt-br">

  <head>
      <meta charset="UTF-8">
     
      <link href="lib/css/bootstrap.min.css" rel="stylesheet">
      <link href="lib/css/estilos.css" rel="stylesheet">
      <link href="lib/css/font-awesome.min.css" rel="stylesheet">
      <link href="lib/css/impressao.css" rel="stylesheet">
      <link href="lib/css/impressao-pdf.css" rel="stylesheet">

      <script src="lib/js/mascara_formatacao.js"></script>
  </head>

  <body>
      <div class="row">
         <div class="col-md-12">
             <%IF IC_TIPO_LANCAMENTO <> "F" THEN 'Se tipo do lançamento for diferente de futuro %>  
                 <table id="tabelaExtrato" class="table table-responsive table-striped table-condensed">
                      
                      <thead>
                        <tr>
                          <th style="cursor:pointer;">Lançamentos</th>
                          <th style="cursor:pointer;" class="text-right">Valor <span class="text-muted"> (R$) </span> </th>
                          <th style="cursor:pointer;" class="text-right">Saldo <span class="text-muted"> (R$) </span> </th>
                        </tr>
                      </thead>
                      
                      <tbody>
                          <% IF rsExtrato.EOF THEN %>
                                <tr>
                                  <td colspan="3">
                                        <bloked>Não existem lançamentos para o período selecionado.</bloked>
                                  </td>
                                </tr>

                          <% END IF %>

                          <% While NOT rsExtrato.EOF 'Escreve linhas dos lançamentos %>
                                <tr>
                                    <td>
                                        <!--Span oculto para auxílio na ordenação das linhas -->
                                        <span class="Oculto"> 
                                            <%= rsExtrato("IC_ICONE_LANCAMENTO") & rsExtrato("DE_LANCAMENTO")  & YEAR(rsExtrato("DT_REF")) & RIGHT("00" & MONTH(rsExtrato("DT_REF")), 2)  & RIGHT("00" & DAY(rsExtrato("DT_REF")), 2) %>
                                        </span>

                                        <div class="conteinerIconeLancamento"> 
                                          <span class="<%=rsExtrato("IC_ICONE_LANCAMENTO")%> "></span> 
                                        </div>

                                        <span class="text-muted"> <%=rsExtrato("DT_REF")%></span> <br>
                                        
                                        <!--Descrição do lançamento + chamada da função para modal com 2ª via comprovantes -->
                                        <strong  <%if rsExtrato("IC_DETALHES")=True then %> OnClick="carregaDetalheLancamento(<%=rsExtrato("NU_DOCUMENTO")%>, <%=" '" & rsExtrato("DE_LANCAMENTO") & "' " %> )" class="linkModalDetalheLancamento"  <%end if%> >  
                                            <%=rsExtrato("DE_LANCAMENTO") %> 
                                        </strong><br>

                                        <span class="text-muted"> <%=rsExtrato("DE_IDENTIFICACAO_OPERACAO")%>  </span> 
                                    </td>

                                    <td class="text-right alinhamentoVertical <%=verificaCor(rsExtrato("VR_LANCAMENTO"))%>"> 
                                        <%=verificaSinal(rsExtrato("VR_LANCAMENTO"))%>
                                    </td>

                                    <td class="text-right alinhamentoVertical <%=verificaCor(rsExtrato("VR_SALDO"))%>"> 
                                        <%=verificaSinal(rsExtrato("VR_SALDO"))%>
                                    </td>
                                </tr>
                          <% 
                                rsExtrato.MoveNext
                             Wend

                              'Volta ao último registro para escrever próxima linha, com o saldo final do período selecionado
                              rsExtrato.MoveLast
                          %> 


                           <% IF IC_TIPO_LANCAMENTO = "T" AND NOT rsExtrato.EOF THEN %>
                                <tr>
                                    <td>
                                        <div class="conteinerIconeLancamento"> 
                                          <span class="fa fa-align-justify"></span> 
                                        </div>

                                        <span class="text-muted"><%=rsExtrato("DT_REF")%> </span> <br>
                                        
                                        <strong>Saldo Disponível em Conta</strong><br>
                                        
                                        <span class="text-muted"> </span> 
                                    </td>

                                    <td class="text-right alinhamentoVertical " ></td>
                                    
                                    <td class="text-right alinhamentoVertical <%=verificaCor(rsExtrato("VR_SALDO"))%> "> 
                                        <strong> <%=verificaSinal(rsExtrato("VR_SALDO"))%> </strong> 
                                    </td>
                                </tr>
                          <% END IF %> 

                      </tbody>

                  </table>

                  <br> <br>

               <%END IF%>  

           
              <%IF IC_TIPO_LANCAMENTO = "F" OR IC_TIPO_LANCAMENTO = "T" THEN %>   
                   <table class="table table-responsive table-striped table-condensed">
                      
                      <thead>
                        <tr>
                          <th>Lançamentos Futuros</th>
                          <th class="text-right">Valor <span class="text-muted"> (R$) </span> </th>
                          <th class="text-right">Saldo <span class="text-muted"> (R$) </span> </th>
                        </tr>
                      </thead>
                      
                      <tbody>
                          <% While NOT rsLancamentosFuturos.EOF%>
                                <tr>
                                    <td>
                                        <div class="conteinerIconeLancamento"> 
                                          <span class="<%=rsLancamentosFuturos("IC_ICONE_LANCAMENTO")%> "></span> 
                                        </div>

                                        <span class="text-muted"> <%=rsLancamentosFuturos("DT_REF")%> </span><br> 
                                        
                                        <strong><%=rsLancamentosFuturos("DE_LANCAMENTO")%> </strong><br>
                                        
                                        <span class="text-muted"> <%=rsLancamentosFuturos("DE_IDENTIFICACAO_OPERACAO")%>  </span> 
                                    </td>

                                    <td class="text-right alinhamentoVertical <%=verificaCor(rsLancamentosFuturos("VR_LANCAMENTO"))%> " >
                                        <%=verificaSinal(rsLancamentosFuturos("VR_LANCAMENTO"))%>
                                    </td>

                                    <td class="text-right alinhamentoVertical <%=verificaCor(rsLancamentosFuturos("VR_SALDO"))%> "> 
                                      <%=verificaSinal(rsLancamentosFuturos("VR_SALDO"))%>
                                    </td>
                                </tr>
                          <% 
                                rsLancamentosFuturos.MoveNext()
                             Wend
                          %>   
                      </tbody>

                  </table>
              <%END IF%>   

          </div>
      </div>

<%
  'Fecha concexão com SQL Server'
    Call fecha_conexao_SQL(conexao)
%>


      <script>
            //PARA ORDENAR COLUNA TIPO DATA
                jQuery.extend( jQuery.fn.dataTableExt.oSort, {
                   "date-br-pre": function ( a ) {
                    if (a == null || a == "") {
                     return 0;
                    }
                    var brDatea = a.split('/');
                    return (brDatea[2] + brDatea[1] + brDatea[0]) * 1;
                   },

                   "date-br-asc": function ( a, b ) {
                    return ((a < b) ? -1 : ((a > b) ? 1 : 0));
                   },

                   "date-br-desc": function ( a, b ) {
                    return ((a < b) ? 1 : ((a > b) ? -1 : 0));
                   }
                } );

            //HABILITA CLASSIFICACAO E FILTRO NA TABELA EXTRATO
                $(document).ready(function(){
                     $('#tabelaExtrato').DataTable( {
                          "aaSorting": [], //ORDEM PADRÃO DA TABELA
                          "iDisplayLength": 3000,
                          "language": {
                            "decimal": ",",
                            "thousands": ".",
                            "sEmptyTable": "Nenhum registro encontrado",
                            "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ registros",
                            "sInfoEmpty": "Mostrando 0 até 0 de 0 registros",
                            "sInfoFiltered": "(Filtrados de _MAX_ registros)",
                            "sInfoPostFix": "",
                            "sInfoThousands": ".",
                            "sLengthMenu": "_MENU_ resultados por página",
                            "sLoadingRecords": "Carregando...",
                            "sProcessing": "Processando...",
                            "sZeroRecords": "Nenhum registro encontrado",
                            "sSearch": "_INPUT_",
                            "sSearchPlaceholder": "Digite texto para filtrar...",
                            "oPaginate": {
                              "sNext": "Próximo",
                              "sPrevious": "Anterior",
                              "sFirst": "Primeiro",
                              "sLast": "Último"
                            },
                            "oAria": {
                              "sSortAscending": ": Ordenar colunas de forma ascendente",
                              "sSortDescending": ": Ordenar colunas de forma descendente"
                            }
                          }
                      } );
                      
                      $('#tabelaExtrato_filter label input').addClass("form-control");
                      $('#tabelaExtrato_filter label input').addClass("NaoImprimi");

                      //OCULTA OBJETOS
                      //$('#tabelaExtrato_filter').hide(); 
                      $('#tabelaExtrato_length').hide(); 
                      $('#tabelaExtrato_info').hide(); 
                      $('#tabelaExtrato_paginate').hide(); 
                });
      </script>

   </body>
   
</html>
