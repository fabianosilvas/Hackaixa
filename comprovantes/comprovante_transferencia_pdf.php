<?php	
	//define variável com resultado da página ASP
	$CO_TRANSACAO = $_REQUEST['CO_TRANSACAO'];
	$TIPO_DOCUMENTO = $_REQUEST['TIPO_DOCUMENTO'];
	$html = file_get_contents('http://hackaixa.c115765/IBC/comprovantes/comprovante_transferencia_pdf_pesquisa.asp?CO_TRANSACAO='.$CO_TRANSACAO.'' );
	
	//referenciar o DomPDF com namespace
	use Dompdf\Dompdf;

	//include autoloader
	require_once("../lib/php/dompdf/autoload.inc.php");

	//Criando a Instancia
	$dompdf = new DOMPDF();
	
	//Carrega HTML
	$dompdf->load_html($html);

	//Renderizar HTML
	$dompdf->render();

	//Exibir a página
	$dompdf->stream(
		$TIPO_DOCUMENTO.'_'.$CO_TRANSACAO, 
		array(
			'Attachment' => true //Para realizar o download somente alterar para true
		)
	);
?>