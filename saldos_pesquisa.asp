<!--#include file="lib\asp\conexao_bd.asp"-->
<!--#include file="lib\asp\funcoes.asp"-->


<%
'Abre concexão com SQL Server'
    Call abre_conexao_SQL(conexao)

'Se ocorrer erro prossegue carregamento da página
    on error resume next  

'Atribui Variaveis 
   IC_PERIODO = request.form("IC_PERIODO")
   DT_INICIO = request.form("DT_INICIO")
   DT_TERMINO = request.form("DT_TERMINO")
   MM_ATUAL = month(now())
   AA_ATUAL = year(now())
  
'Monta consultas SQL 
  Select Case IC_PERIODO
    Case "D-7"
        SQL_creditos = "SELECT ISNULL(SUM(VR_LANCAMENTO),0) AS VR_LANCAMENTO FROM [HACKAIXA].[IBC].[EXTRATO] WHERE DT_REF BETWEEN DATEADD(DAY, -7, GETDATE()) AND GETDATE() and IC_TIPO_LANCAMENTO = 'C'"
        SQL_debitos = "SELECT ISNULL(SUM(VR_LANCAMENTO),0) AS VR_LANCAMENTO FROM [HACKAIXA].[IBC].[EXTRATO] WHERE DT_REF BETWEEN DATEADD(DAY, -7, GETDATE()) AND GETDATE() and IC_TIPO_LANCAMENTO = 'D'"
        rotuloPeriodoCredito = "Créditos nos últimos 7 dias"
        rotuloPeriodoDebito = "Débitos nos últimos 7 dias"
    Case "MesAtual"
        SQL_creditos = "SELECT ISNULL(SUM(VR_LANCAMENTO),0) AS VR_LANCAMENTO FROM [HACKAIXA].[IBC].[EXTRATO] WHERE MONTH(DT_REF) = " & MM_ATUAL & " AND YEAR(DT_REF) = " & AA_ATUAL & " AND IC_TIPO_LANCAMENTO = 'C'"
        SQL_debitos = "SELECT ISNULL(SUM(VR_LANCAMENTO),0) AS VR_LANCAMENTO FROM [HACKAIXA].[IBC].[EXTRATO] WHERE MONTH(DT_REF) = " & MM_ATUAL & " AND YEAR(DT_REF) = " & AA_ATUAL & " AND IC_TIPO_LANCAMENTO = 'D'"
        rotuloPeriodoCredito = "Créditos no mês atual"
        rotuloPeriodoDebito = "Débitos no mês atual"
    Case "Ultimos3Meses"
        SQL_creditos = "SELECT ISNULL(SUM(VR_LANCAMENTO),0) AS VR_LANCAMENTO FROM [HACKAIXA].[IBC].[EXTRATO] WHERE [DT_REF] BETWEEN DATEADD(M, -3,  GETDATE() )  AND GETDATE() AND IC_TIPO_LANCAMENTO = 'C'"
        SQL_debitos = "SELECT ISNULL(SUM(VR_LANCAMENTO),0) AS VR_LANCAMENTO FROM [HACKAIXA].[IBC].[EXTRATO] WHERE [DT_REF] BETWEEN DATEADD(M, -3,  GETDATE() )  AND GETDATE() AND IC_TIPO_LANCAMENTO = 'D'"
        rotuloPeriodoCredito = "Créditos nos últimos 3 meses"
        rotuloPeriodoDebito = "Débitos nos últimos 3 meses"
    Case "EspecificarPeriodo"
        if len(DT_INICIO) = 7 and len(DT_TERMINO) = 7 then
            SQL_creditos = "SELECT ISNULL(SUM(VR_LANCAMENTO),0) AS VR_LANCAMENTO FROM [HACKAIXA].[IBC].[EXTRATO] WHERE CAST(YEAR(DT_REF) AS VARCHAR) + RIGHT('00' + CAST(MONTH(DT_REF) AS VARCHAR), 2)  BETWEEN '" & CSTR(YEAR(DT_INICIO)) & RIGHT(00 & CSTR(MONTH(DT_INICIO)),2)  &"' AND '" & CSTR(YEAR(DT_TERMINO)) & RIGHT(00 & CSTR(MONTH(DT_TERMINO)),2) & "' AND IC_TIPO_LANCAMENTO = 'C'"
            SQL_debitos = "SELECT ISNULL(SUM(VR_LANCAMENTO),0) AS VR_LANCAMENTO FROM [HACKAIXA].[IBC].[EXTRATO] WHERE CAST(YEAR(DT_REF) AS VARCHAR) + RIGHT('00' + CAST(MONTH(DT_REF) AS VARCHAR), 2)  BETWEEN '" & CSTR(YEAR(DT_INICIO)) & RIGHT(00 & CSTR(MONTH(DT_INICIO)),2)  &"' AND '" & CSTR(YEAR(DT_TERMINO)) & RIGHT(00 & CSTR(MONTH(DT_TERMINO)),2) & "' AND IC_TIPO_LANCAMENTO = 'D'"
            rotuloPeriodoCredito = "Créditos no período especificado"
            rotuloPeriodoDebito = "Débitos no período especificado"
        else
            response.end
        end if 
  End Select

  SQL_disponivelHoje = "SELECT VR_SALDO FROM [HACKAIXA].[IBC].[EXTRATO] WHERE IC_TIPO_LANCAMENTO <> 'F' AND CO_REGISTRO = (SELECT MAX(CO_REGISTRO) FROM [HACKAIXA].[IBC].[EXTRATO] WHERE IC_TIPO_LANCAMENTO <> 'F')"
  
  SQL_debitosFuturos = "SELECT ISNULL(SUM(VR_LANCAMENTO),0) AS VR_LANCAMENTO FROM [HACKAIXA].[IBC].[EXTRATO] WHERE DT_REF BETWEEN GETDATE() AND DATEADD(DAY, 30, GETDATE()) AND IC_TIPO_LANCAMENTO = 'F' AND  VR_LANCAMENTO <0"


  'Executa instruções SQL
    set rsDisponivelHoje=conexao.execute(SQL_disponivelHoje)
    set rsCreditos=conexao.execute(SQL_creditos)
    set rsDebitos=conexao.execute(SQL_debitos)
    set rsDebitosFuturos=conexao.execute(SQL_debitosFuturos)
%>

    <div class="row">
        <div class="col-xs-3">
             <h5 class="text-center cor_cinza">Disponível para saque hoje</h5>
             <p class="text-center disponivelHoje"> <%=FormatCurrency(rsDisponivelHoje("VR_SALDO"),2)%> </p>
        </div> 

        <div class="col-xs-3">
             <h6 class="text-center cor_cinza"><%=rotuloPeriodoCredito%></h6>
             <p class="text-center creditosUltimos"> <%=FormatCurrency(rsCreditos("VR_LANCAMENTO"),2)%> </p>
        </div> 

        <div class="col-xs-3">
             <h6 class="text-center cor_cinza"><%=rotuloPeriodoDebito%></h6>
             <p class="text-center debitosUltimos"> <%=FormatCurrency(rsDebitos("VR_LANCAMENTO"),2)%> </p>
        </div> 

        <div class="col-xs-3">
              <h6 class="text-center cor_cinza">Débitos nos próximos 7 dias</h6>
             <p class="text-center debitosFuturos"> <%=FormatCurrency(rsDebitosFuturos("VR_LANCAMENTO"),2)%> </p>
        </div> 
    </div>  

<%
  'Fecha concexão com SQL Server
    Call fecha_conexao_SQL(conexao)
%>
