<!--#include file="..\lib\asp\conexao_bd.asp"-->
<!--#include file="..\lib\asp\funcoes.asp"-->


<%
 'Formata data DD/MM/AAAA
    SESSION.LCID = 1046 'Português (Brasileiro) 

  'Abre concexão com SQL Server'
    Call abre_conexao_SQL(conexao)

  'Se ocorrer erro prossegue carregamento da página
    on error resume next  

  'Atribui Variaveis 
    CO_TRANSACAO = "781277" 'request.querystring("CO_TRANSACAO")

  'Executa instrução SQL
   SQL = "SELECT * FROM [Hackaixa].[IBC].[Extrato_Detalhes] WHERE [CO_TRANSACAO] = " & CO_TRANSACAO
   set rsDetalheLancamento=conexao.execute(SQL)
%>



  <head>
      <meta charset="UTF-8">
     
      <link href="lib/css/bootstrap.min.css" rel="stylesheet" media="all">
      <link href="lib/css/estilos.css" rel="stylesheet">
      <link href="lib/css/font-awesome.min.css" rel="stylesheet">

    <script src="lib/js/mascara_formatacao.js"></script>
  </head>


      <br>  
      <div class="container-fluid"  id="page_content">
          <div class="row">
            <div class="col-xs-12">
              <span class="logo">
                <img src="lib/img/logo_caixa.gif" alt="Logo Caixa">
              </span>
              
              <h4>Comprovante de <%=rsDetalheLancamento("DE_OPERACAO")%></h4>

              <h6>Via Internet Banking CAIXA</h6>
            </div>
          </div>            
          <br>
          <div class="row LinhaBorda" >
            <div class="col-xs-12">
               <table cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="200" class="TituloImpressao">Nome:</td>
                    <td class="dados"><%=rsDetalheLancamento("NO_EMITENTE")%></td>
                  </tr>
                  <tr>
                    <td class="TituloImpressao">Conta de débito:</td>
                    <td><%=rsDetalheLancamento("NU_AG_ORIGEM") & " / " &  rsDetalheLancamento("NU_OP_ORIGEM") & " / " &  rsDetalheLancamento("NU_CONTA_ORIGEM") & "-" &  rsDetalheLancamento("NU_DV_ORIGEM") %></td>
                  </tr>
              </table>
            </div>       
          </div>
          
          <br>

          <div class="row LinhaBorda">
            <div class="col-xs-12">
              <table cellpadding="0" cellspacing="0">
                <tr>
                  <td width="200" class="TituloImpressao">Código de barras:</td>
                  <td><%=rsDetalheLancamento("CO_BARRAS")%></td>
                </tr>
              </table>
            </div>       
          </div>

          <br>

           <div class="row LinhaBorda">
            <div class="col-xs-12">
               <table cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="200" class="TituloImpressao">Empresa: </td>
                    <td><%=rsDetalheLancamento("NO_EMPRESA")%></td>
                  </tr>
                  <tr>
                    <td class="TituloImpressao"> Valor: </td>
                    <td><%=FormatCurrency(rsDetalheLancamento("VR_LANCAMENTO"),2)%></td>
                  </tr>
                  <tr>
                    <td class="TituloImpressao"> Identificação da operação: </td>
                    <td><%=rsDetalheLancamento("DE_IDENTIFICACAO_OPERACAO")%></td>
                  </tr>
                </table>
            </div>       
          </div>

          <br>

          <div class="row LinhaBorda">
            <div class="col-xs-12">
               <table cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="200" class="TituloImpressao">Data de débito: </td>
                    <td><%=rsDetalheLancamento("DT_TRANSACAO")%></td>
                  </tr>
                  <tr>
                    <td class="TituloImpressao">Data/hora da operação: </td>
                    <td><%=rsDetalheLancamento("DT_TRANSACAO")%></td>
                  </tr>
                </table>
            </div>       
          </div>

          <br>

          <div class="row LinhaBorda">
            <div class="col-xs-12">
              <table align="center" cellpadding="0" cellspacing="0" class="tabelaCentro">
                <tr>
                  <td class="chaveSeguranca"><strong>Código da operação: </strong> </td>
                  <td class="chaveSeguranca"> <%=rsDetalheLancamento("CO_TRANSACAO")%></td>
                </tr>
                
                <tr>
                  <td class="chaveSeguranca"><strong>Chave de segurança: </strong> </td>
                  <td class="chaveSeguranca"> <%=rsDetalheLancamento("DE_CHAVE_SEGURANCA")%></td>
                </tr>
              </table>
            </div>       
          </div>

          <br>

          <div class="row">
            <div class="col-xs-12">
                <h6>
                 SAC CAIXA: 0800 726 0101<br>Pessoas com defici&ecirc;ncia auditiva: 0800 726 2492<br>Ouvidoria: 0800 725 7474<br>Help Desk CAIXA: 0800 726 0104
               </h6>
            </div>       
          </div>
          <br>
       
      </div>  


<%
  'Fecha concexão com SQL Server'
    Call fecha_conexao_SQL(conexao)
%>

