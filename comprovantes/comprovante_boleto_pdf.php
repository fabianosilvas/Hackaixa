<?php		
	//define variável com resultado da página ASP
	$CO_TRANSACAO = $_REQUEST['CO_TRANSACAO'];
	$TIPO_DOCUMENTO = $_REQUEST['TIPO_DOCUMENTO'];

	$html = file_get_contents('http://hackaixa.c115765/IBC/comprovantes/comprovante_boleto_pdf_pesquisa.asp?CO_TRANSACAO='.$CO_TRANSACAO.'' );
	
	//Referencia DomPDF 
	use Dompdf\Dompdf;

	//Include autoloader
	require_once("../lib/php/dompdf/autoload.inc.php");

	//Cria instancia
	$dompdf = new DOMPDF();
	
	//Carrega HTML
	$dompdf->load_html($html);

	//Renderiza HTML
	$dompdf->render();

	//Exibi página
	$dompdf->stream(
		$TIPO_DOCUMENTO.'_'.$CO_TRANSACAO, 
		array(
			'Attachment' => true //Para realizar o download somente alterar para true
		)
	);
?>