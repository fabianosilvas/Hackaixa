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
    CO_TRANSACAO = request.querystring("CO_TRANSACAO")

  'Executa instrução SQL
    SQL = "SELECT * FROM [Hackaixa].[IBC].[Extrato_Detalhes] WHERE [CO_TRANSACAO] = " & CO_TRANSACAO
    set rsDetalheLancamento=conexao.execute(SQL)
%>

    <head>
        <meta charset="UTF-8">
       
        <link href="../lib/css/bootstrap.min.css" rel="stylesheet" media="all">
        <link href="../lib/css/estilos.css" rel="stylesheet">
        <link href="../../lib/css/font-awesome.min.css" rel="stylesheet">

        <script src="../lib/js/jquery-3.2.1.min.js"></script>
        <script src="../lib/js/jquery.mask.min.js"></script>
        <script src="../lib/js/mascara_formatacao.js"></script>
    </head>

    <table>
        <tr>
            <td colspan="2">
               <span class="logo">
                <img src="../lib/img/logo_caixa.gif" alt="Logo Caixa">
              </span>
                <h4>Comprovante de <%=rsDetalheLancamento("DE_OPERACAO")%></h4>
                 <h6>Via Internet Banking CAIXA</h6>
            </td>
        </tr>
    </table>

    <div class="LinhaBorda" >
         <table cellpadding="0" cellspacing="0">
            <tr>
              <td width="200" class="TituloImpressao">Emitente:</td>
              <td class="dados"><%=rsDetalheLancamento("NO_EMITENTE")%></td>
            </tr>

            <tr>
              <td class="TituloImpressao">Conta origem:</td>
              <td><%=rsDetalheLancamento("NU_AG_ORIGEM") & " / " &  rsDetalheLancamento("NU_OP_ORIGEM") & " / " &  rsDetalheLancamento("NU_CONTA_ORIGEM") & "-" &  rsDetalheLancamento("NU_DV_ORIGEM") %></td>
            </tr>

            <tr>
              <td class="TituloImpressao">Conta destino:</td>
              <td><%=rsDetalheLancamento("NU_AG_DESTINO") & " / " &  rsDetalheLancamento("NU_OP_DESTINO") & " / " &  rsDetalheLancamento("NU_CONTA_DESTINO") & "-" &  rsDetalheLancamento("NU_DV_DESTINO") %></td>
            </tr>
        </table>
    </div><br>
          

    <div class="LinhaBorda">
        <table cellpadding="0" cellspacing="0">
          <tr>
            <td width="200" class="TituloImpressao">Banco:</td>
            <td><%=rsDetalheLancamento("NU_BANCO_DESTINATARIO") & " - " & rsDetalheLancamento("NO_BANCO_DESTINATARIO")%></td>
          </tr>
          <tr>
            <td class="TituloImpressao">Finalidade:</td>
            <td><%=rsDetalheLancamento("DE_FINALIDADE")%></td>
          </tr>
          <tr>
            <td class="TituloImpressao">Nome destinatário:</td>
            <td><%=rsDetalheLancamento("NO_DESTINATARIO")%></td>
          </tr>
          <tr>
            <td class="TituloImpressao">CPF/CNPJ destinatário:</td>
            <td class="CPF"><%=rsDetalheLancamento("NU_CPF_CNPJ_DESTINATARIO")%></td>
          </tr>
          <tr>
            <td class="TituloImpressao">Valor a ser transferido:</td>
            <td><%=FormatCurrency(rsDetalheLancamento("VR_LANCAMENTO"),2)%></td>
          </tr>
          <tr>
            <td class="TituloImpressao">Tarifa de emissão:</td>
            <td><%=FormatCurrency(rsDetalheLancamento("VR_TARIFA"),2)%></td>
          </tr>
          <tr>
            <td class="TituloImpressao">Valor total a ser debitado:</td>
            <td><%=FormatCurrency(rsDetalheLancamento("VR_LANCAMENTO") + rsDetalheLancamento("VR_TARIFA"),2)%></td>
          </tr>
          <tr>
            <td class="TituloImpressao">Identificação da operação: </td>
            <td><%=rsDetalheLancamento("DE_IDENTIFICACAO_OPERACAO")%></td>
          </tr>
        </table>  
    </div><br>


    <div class="LinhaBorda">
         <table cellpadding="0" cellspacing="0">
            <tr>
              <td width="200" class="TituloImpressao">Data de débito: </td>
              <td><%=rsDetalheLancamento("DT_TRANSACAO")%></td>
            </tr>
          </table> 
    </div><br>


    <div class="LinhaBorda">
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
    </div><br>


    <div class="">
        <h6>
         SAC CAIXA: 0800 726 0101<br>Pessoas com defici&ecirc;ncia auditiva: 0800 726 2492<br>Ouvidoria: 0800 725 7474<br>Help Desk CAIXA: 0800 726 0104
       </h6>
    </div><br>        

<%
  'Fecha concexão com SQL Server'
    Call fecha_conexao_SQL(conexao)
%>

