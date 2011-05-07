package SendToSolr;
use strict;
use Carp;
use Data::Dumper;
use Encode;
use DBI;
use URI;
use LWP::UserAgent;
use HTTP::Request::Common;
use HTTP::Lite;
use BOEScraper;
use Digest::MD5 qw(md5 md5_hex md5_base64);

my $solrURL = 'http://mcdemo01:8090/solr/update?';

my $url = 'http://www.boe.es/diario_boe/txt.php?id=BOE-A-2011-8016';
my $date = '2011-05-07T00:00:00Z';

my $html = BOEScraper::getContenido($url);
$html = BOEScraper::cleanString($html);
my $document = BOEScraper::parseHTML($html);


my $xml = createDocument($document);
#sendToSolR('<delete><query>*:*</query></delete>');
sendToSolR($xml);
sendToSolR('<commit></commit>');

sub sendToSolR {
	my $message             = shift @_;
	my $response;
	my $userAgent = LWP::UserAgent->new( agent => 'perl post' );

	$response = $userAgent->request( POST $solrURL, Content_Type => 'text/xml', Content => $message );

	if ( defined $response && $response->is_success ) {
		print "Indexado!\n";
	}
	else {
		print "ERROR: " . $response->as_string . "\n";
	}
	return $response;
}

# Crea el XML listo para enviar a SolR de un documento del BOE
sub createDocument {
	# Hash con el contenido de cada campo
	my $document = shift @_;
	my $message = "<add>\n<doc>\n";

	my @fields = keys( %{$document} );

	foreach my $field (@fields) {
		$message .= "<field name=\"" . $field . "\"><![CDATA[" . $document->{$field} . "]]></field>\n";
	}
	$message .= "</doc>\n</add>\n";
	return $message;
}

# Crea el XML listo para enviar a SolR de un documento del BOE
sub createMockupDocument {
	# Hash con el contenido de cada campo
	my $document;
	
	# Aqui crear el documento
	$document->{'id'} = 'untextodemed5deberiatenerunapintarara2';
	$document->{'url'} = 'http://boe.es/boe/dias/2011/05/07/pdfs/BOE-A-2011-8015.pdf';
	$document->{'seccion'} = 'Disposiciones no generales';
	$document->{'organo'} = 'Ministerio de la Presidencia';
	$document->{'rango'} = 'Irreal Decreto';
	$document->{'titulo'} = 'Real Decreto 558/2011, de 20 de abril, por el que se complementa el Catálogo Nacional de Cualificaciones Profesionales, mediante el establecimiento de dos cualificaciones profesionales correspondientes a la familia profesional administración y gestión';
	$document->{'codigo'} = 'BOE-A-2011-8015';
	$document->{'paginaInicial'} = '45358';
	$document->{'paginaFinal'} = '45463';
	$document->{'paginas'} = '106';
	$document->{'texto'} = 'La Ley Orgánica 5/2002, de 19 de junio, de las Cualificaciones y de la Formación Profesional tiene por objeto la ordenación de un sistema integral de formación profesional, cualificaciones y acreditación, que responda con eficacia y transparencia a las demandas sociales y económicas a través de las diversas modalidades formativas. Para ello, crea el Sistema Nacional de Cualificaciones y Formación Profesional, definiéndolo en el artículo 2.1 como el conjunto de instrumentos y acciones necesarios para promover y desarrollar la integración de las ofertas de la formación profesional, a través del Catálogo Nacional de Cualificaciones Profesionales, así como la evaluación y acreditación de las correspondientes competencias profesionales, de forma que se favorezca el desarrollo profesional y social de las personas y se cubran las necesidades del sistema productivo.';
	$document->{'fecha'} = '2011-05-07T00:00:00Z';

	my $message = "<add>\n<doc>\n";

	my @fields = keys( %{$document} );

	foreach my $field (@fields) {
		$message .= "<field name=\"" . $field . "\"><![CDATA[" . $document->{$field} . "]]></field>\n";
	}
	$message .= "</doc>\n</add>\n";
	return $message;
}

