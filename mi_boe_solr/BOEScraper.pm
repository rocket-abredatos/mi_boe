#!/usr/bin/env perl

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
 use Digest::MD5 qw(md5_hex);

# Constants used to build URLs
my $boe_base_url = 'http://boe.es';
my $dias_base_url = $boe_base_url.'/boe/dias';
my $patterns={'&#x0;'=>'NUL' , '&#x1;'=>'SOH' , '&#x2;'=>'STX' , '&#x3;'=>'ETX' , '&#x4;'=>'EOT' , '&#x5;'=>'ENQ' , '&#x6;'=>'ACK' , '&#x7;'=>'BEL' , '&#x8;'=>'BS' , '&#x9;'=>'HT' , '&#x0A;'=>'LF' , '&#x0B;'=>'VT' , '&#x0C;'=>'FF' , '&#x0D;'=>'CR' , '&#x0E;'=>'SO' , '&#x0F;'=>'SI' , '&#x10;'=>'DLE' , '&#x11;'=>'DC1' , '&#x12;'=>'DC2' , '&#x13;'=>'DC3' , '&#x14;'=>'DC4' , '&#x15;'=>'NAK' , '&#x16;'=>'SYN' , '&#x17;'=>'ETB' , '&#x18;'=>'CAN' , '&#x19;'=>'EM' , '&#x1A;'=>'SUB' , '&#x1B;'=>'ESC' , '&#x1C;'=>'FS' , '&#x1D;'=>'GS' , '&#x1E;'=>'RS' , '&#x1F;'=>'US' , '&#x20;'=>' ' , '&#x21;'=>'!' , '&#x22;'=>'"' , '&#x23;'=>'#' , '&#x24;'=>'$' , '&#x25;'=>'%' , '&#x26;'=>'&' , '&#x27;'=>'\'' , '&#x28;'=>'(' , '&#x29;'=>')' , '&#x2A;'=>'*' , '&#x2B;'=>'+' , '&#x2C;'=>',' , '&#x2D;'=>'-' , '&#x2E;'=>'.' , '&#x2F;'=>'/' , '&#x30;'=>'0' , '&#x31;'=>'1' , '&#x32;'=>'2' , '&#x33;'=>'3' , '&#x34;'=>'4' , '&#x35;'=>'5' , '&#x36;'=>'6' , '&#x37;'=>'7' , '&#x38;'=>'8' , '&#x39;'=>'9' , '&#x3A;'=>':' , '&#x3B;'=>';' , '&#x3C;'=>'<' , '&#x3D;'=>'=' , '&#x3E;'=>'>' , '&#x3F;'=>'?' , '&#x40;'=>'@' , '&#x41;'=>'A' , '&#x42;'=>'B' , '&#x43;'=>'C' , '&#x44;'=>'D' , '&#x45;'=>'E' , '&#x46;'=>'F' , '&#x47;'=>'G' , '&#x48;'=>'H' , '&#x49;'=>'I' , '&#x4A;'=>'J' , '&#x4B;'=>'K' , '&#x4C;'=>'L' , '&#x4D;'=>'M' , '&#x4E;'=>'N' , '&#x4F;'=>'O' , '&#x50;'=>'P' , '&#x51;'=>'Q' , '&#x52;'=>'R' , '&#x53;'=>'S' , '&#x54;'=>'T' , '&#x55;'=>'U' , '&#x56;'=>'V' , '&#x57;'=>'W' , '&#x58;'=>'X' , '&#x59;'=>'Y' , '&#x5A;'=>'Z' , '&#x5B;'=>'[' , '&#x5C;'=>'\\' , '&#x5D;'=>']' , '&#x5E;'=>'^' , '&#x5F;'=>'_' , '&#x60;'=>'`' , '&#x61;'=>'a' , '&#x62;'=>'b' , '&#x63;'=>'c' , '&#x64;'=>'d' , '&#x65;'=>'e' , '&#x66;'=>'f' , '&#x67;'=>'g' , '&#x68;'=>'h' , '&#x69;'=>'i' , '&#x6A;'=>'j' , '&#x6B;'=>'k' , '&#x6C;'=>'l' , '&#x6D;'=>'m' , '&#x6E;'=>'n' , '&#x6F;'=>'o' , '&#x70;'=>'p' , '&#x71;'=>'q' , '&#x72;'=>'r' , '&#x73;'=>'s' , '&#x74;'=>'t' , '&#x75;'=>'u' , '&#x76;'=>'v' , '&#x77;'=>'w' , '&#x78;'=>'x' , '&#x79;'=>'y' , '&#x7A;'=>'z' , '&#x7B;'=>'{' , '&#x7C;'=>'|' , '&#x7D;'=>'}' , '&#x7E;'=>'~' , '&#x7F;'=>'' , '&#x80;'=>'€' , '&#x81;'=>' ' , '&#x82;'=>'‚' , '&#x83;'=>'ƒ' , '&#x84;'=>'„' , '&#x85;'=>'…' , '&#x86;'=>'†' , '&#x87;'=>'‡' , '&#x88;'=>'ˆ' , '&#x89;'=>'‰' , '&#x8A;'=>'Š' , '&#x8B;'=>'‹' , '&#x8C;'=>'Œ' , '&#x8D;'=>' ' , '&#x8E;'=>'Ž' , '&#x8F;'=>' ' , '&#x90;'=>' ' , '&#x91;'=>'‘' , '&#x92;'=>'’' , '&#x93;'=>'“' , '&#x94;'=>'”' , '&#x95;'=>'•' , '&#x96;'=>'–' , '&#x97;'=>'—' , '&#x98;'=>'˜' , '&#x99;'=>'™' , '&#x9A;'=>'š' , '&#x9B;'=>'›' , '&#x9C;'=>'œ' , '&#x9D;'=>' ' , '&#x9E;'=>'ž' , '&#x9F;'=>'Ÿ' , '&#xA0;'=>' ' , '&#xA1;'=>'¡' , '&#xA2;'=>'¢' , '&#xA3;'=>'£' , '&#xA4;'=>'¤' , '&#xA5;'=>'¥' , '&#xA6;'=>'¦' , '&#xA7;'=>'§' , '&#xA8;'=>'¨' , '&#xA9;'=>'©' , '&#xAA;'=>'ª' , '&#xAB;'=>'«' , '&#xAC;'=>'¬' , '&#xAD;'=>'­' , '&#xAE;'=>'®' , '&#xAF;'=>'¯' , '&#xB0;'=>'°' , '&#xB1;'=>'±' , '&#xB2;'=>'²' , '&#xB3;'=>'³' , '&#xB4;'=>'´' , '&#xB5;'=>'µ' , '&#xB6;'=>'¶' , '&#xB7;'=>'·' , '&#xB8;'=>'¸' , '&#xB9;'=>'¹' , '&#xBA;'=>'º' , '&#xBB;'=>'»' , '&#xBC;'=>'¼' , '&#xBD;'=>'½' , '&#xBE;'=>'¾' , '&#xBF;'=>'¿' , '&#xC0;'=>'À' , '&#xC1;'=>'Á' , '&#xC2;'=>'Â' , '&#xC3;'=>'Ã' , '&#xC4;'=>'Ä' , '&#xC5;'=>'Å' , '&#xC6;'=>'Æ' , '&#xC7;'=>'Ç' , '&#xC8;'=>'È' , '&#xC9;'=>'É' , '&#xCA;'=>'Ê' , '&#xCB;'=>'Ë' , '&#xCC;'=>'Ì' , '&#xCD;'=>'Í' , '&#xCE;'=>'Î' , '&#xCF;'=>'Ï' , '&#xD0;'=>'Ð' , '&#xD1;'=>'Ñ' , '&#xD2;'=>'Ò' , '&#xD3;'=>'Ó' , '&#xD4;'=>'Ô' , '&#xD5;'=>'Õ' , '&#xD6;'=>'Ö' , '&#xD7;'=>'×' , '&#xD8;'=>'Ø' , '&#xD9;'=>'Ù' , '&#xDA;'=>'Ú' , '&#xDB;'=>'Û' , '&#xDC;'=>'Ü' , '&#xDD;'=>'Ý' , '&#xDE;'=>'Þ' , '&#xDF;'=>'ß' , '&#xE0;'=>'à' , '&#xE1;'=>'á' , '&#xE2;'=>'â' , '&#xE3;'=>'ã' , '&#xE4;'=>'ä' , '&#xE5;'=>'å' , '&#xE6;'=>'æ' , '&#xE7;'=>'ç' , '&#xE8;'=>'è' , '&#xE9;'=>'é' , '&#xEA;'=>'ê' , '&#xEB;'=>'ë' , '&#xEC;'=>'ì' , '&#xED;'=>'í' , '&#xEE;'=>'î' , '&#xEF;'=>'ï' , '&#xF0;'=>'ð' , '&#xF1;'=>'ñ' , '&#xF2;'=>'ò' , '&#xF3;'=>'ó' , '&#xF4;'=>'ô' , '&#xF5;'=>'õ' , '&#xF6;'=>'ö' , '&#xF7;'=>'÷' , '&#xF8;'=>'ø' , '&#xF9;'=>'ù' , '&#xFA;'=>'ú' , '&#xFB;'=>'û' , '&#xFC;'=>'ü' , '&#xFD;'=>'ý' , '&#xFE;'=>'þ' , '&#xFF;'=>'ÿ'};


# Parsea el HTML y devuelve un hash con los campos del SolR
sub parseHTML {
	my $html = shift @_;	
	my $document;
	if ($html =~ m/<div id=\"DOdoc\">.*?<h3>(.*?)<\/h3>/ism) {
		my $seccion = $1;
		if ($seccion =~ m/<span>(.*?)<\/span>/ism) {
			$seccion = $1;
		}
		if ($seccion =~ m/\./) {
			my $dotIndex = index($seccion,'.');
			$seccion = substr($seccion,$dotIndex + 2);
		}
		$document->{'seccion'} = $seccion;
	} 
	if ($html =~ m/<div id=\"DOdoc\">.*?<h4>(.*?)<\/h4>/ism) {
		$document->{'organo'} = $1;
	}
	if ($html =~ m/<div class=\"enlacesDoc\" id=\"barraSep\">.*?<p class=\"documento-tit\">(.*?)<\/p>/ism) {
		$document->{'titulo'} = $1;
	} 
	
	if ($html =~ m/<li class=\"puntoPDF\">.*?href="(.*?)\"/ism) {
		$document->{'urlPDF'} = 'http://boe.es'. $1;
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
	foreach my $pattern (keys(%{$patterns}))
  {
    $string=~s/$pattern/$patterns->{$pattern}/gi
  }
	return $string;
}

# Gets the URLs of the day articles
sub getUrls {
  my $html = shift @_;
  my $urls = ();
  
  # We search the document for links to articles
  while ($html =~ m/<a href=\"(\/diario_boe\/txt.php\?id=.*?)\" title=\"Versi.*? HTML .*?\">Otros formatos<\/a>/ig) {
    my $url = $boe_base_url.$1;
    push(@{$urls}, $url);
  }
  return $urls;
}

# Returns an array with all the articles of the day
sub getBOEOfTheDay {
  my $day = shift @_;
  my $month = shift @_;
  my $year = shift @_;
  
  my $fecha = $year.'-'.$month.'-'.$day.'T00:00:00Z';
  # We build the day's URL
  my $url = $dias_base_url.'/'.$year.'/'.$month.'/'.$day.'/';
  my $html = getContenido($url);
  my $urls = getUrls($html);
  
  # We download each article
  my $documents = ();
  for my $url_art (@{$urls}) {
    my $html_article = getContenido($url_art);
	$html_article = cleanString($html_article);
    my $document = parseHTML($html_article);
    $document->{'fecha'} = $fecha;
    $document->{'id'} = 'A'.md5_hex($url_art);
    $document->{'url'} = $url_art;
    push(@{$documents}, $document);
  }
  return $documents;
}

1;