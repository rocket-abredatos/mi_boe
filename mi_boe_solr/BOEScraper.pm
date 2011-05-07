package BOEScraper;
use strict;
use Carp;
use Data::Dumper;
use URI;
use LWP::UserAgent;
use HTTP::Request::Common;
use Encode;
use Encode::Encoding;
use Encode::Guess;
use HTML::Encoding;

# Parsea el HTML y devuelve un hash con los campos del SolR
sub parseHTML {
	my $html = shift @_;	
	my $document;
	if ($html =~ m/<div id=\"DOdoc\">.*?<h3>(.*?)<\/h3>/ism) {
		$document->{'seccion'} = $1;
	} 
	if ($html =~ m/<div id=\"DOdoc\">.*?<h4>(.*?)<\/h4>/ism) {
		$document->{'organo'} = $1;
	}
	if ($html =~ m/<div class=\"enlacesDoc\" id=\"barraSep\">.*?<p class=\"documento-tit\">(.*?)<\/p>/ism) {
		$document->{'titulo'} = $1;
	} 
	
	if ($html =~ m/<ul>.*?<li>.*?<span class="etiqDoc">Rango: <\/span>(.*?)<\/li>/ism) {
		$document->{'rango'} = $1;
	} 
	if ($html =~ m/<ul>.*?<li>.*?<span class="etiqDoc">.*?CVE.*?<\/span>(.*?)<\/li>/ism) {
		$document->{'codigo'} = $1;
	} 
	if ($html =~ m/<ul>.*?<li>.*?<span class="etiqDoc">.*?ginas: <\/span>(.*?)<\/li>/ism) {
		my $paginas = $1;
		my @partesPaginas = split(/ /,$paginas);
		$document->{'paginaInicial'} = $partesPaginas[0];
		$document->{'paginaFinal'} = $partesPaginas[2];
		$document->{'paginas'} = $partesPaginas[4];
	}
	if ($html =~ m/<div id=\"textoxslt\">(.*?)<\/div>/ism) {
		$document->{'texto'} = $1;
	}	
	return $document;
}

# Descarga el contenido de la pagina ya decodificada
sub getContenido {
	my $url = shift @_;
	my $response;
	my $ua = LWP::UserAgent->new;

	local $SIG{ALRM} = sub { return; };
	my $html;
	eval {
		# Timeout en 10s
		alarm(10);
		# Ejecuta descarga
		$response = $ua->get($url) or die "ERROR: $!\n";
		alarm(0);
	};
	# Si hay error
	if ($@) {
		return ($html);
	}
	$html = $response->decoded_content;
	$html = encode('utf-8',$html);
	return $html;
}

# Limpia la String de toda la basura rollo hexa
sub cleanString {
	my $string = shift @_;
	$string =~ s/&#xAA;/ª/gsm;#    Upper case A-acute
	$string =~ s/&#xC1;/Á/gsm;#    Upper case A-acute
	$string =~ s/&#xE1;/á/gsm;# 	Lowercase a-acute
	$string =~ s/&#xE2;/â/gsm;# 	Lowercase a-^
	$string =~ s/&#xC2;/â/gsm;# 	Uppercase a-^
	$string =~ s/&#xC9;/É/gsm;# 	Capital E-acute
	$string =~ s/&#xE9;/é/gsm;# 	Lowercase e-acute
	$string =~ s/&#xCD;/Í/gsm;# 	Capital I-acute
	$string =~ s/&#xED;/í/gsm;# 	Lowercase i-acute
	$string =~ s/&#xD1;/Ñ/gsm;# 	Capital N-tilde
	$string =~ s/&#xF1;/ñ/gsm;# 	Lowercase n-tilde
	$string =~ s/&#xD3;/Ó/gsm;# 	Capital O-acute
	$string =~ s/&#xF3;/ó/gsm;# 	Lowercase o-acute
	$string =~ s/&#xDA;/Ú/gsm;# 	Capital U-acute
	$string =~ s/&#xFA;/ú/gsm;# 	Lowercase u-acute
	$string =~ s/&#xDC;/Ü/gsm;# 	Capital U-umlaut
	$string =~ s/&#xFC;/ü/gsm;# 	Lowercase u-umlaut
	$string =~ s/&#xAB;/«/gsm;# 	Left angle quotes
	$string =~ s/&#xBB;/»/gsm;# 	Right angle quotes
	$string =~ s/&#xBF;/¿/gsm;# 	Inverted question mark
	$string =~ s/&#xA1;/¡/gsm;# 	Inverted exclamation point
	$string =~ s/&#x80;/€/gsm;# 	Euro
	$string =~ s/&#x20A7;/₧/gsm;# 	Peseta
	return $string;
}

1;