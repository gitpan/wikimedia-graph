<?php
# Graph WikiMedia extension

# (c) by Tels http://bloodgate.com 2004-2005

# Takes text between <graph> </graph> tags, and runs it through the
# external script "graphcnv", which generates an ASCII, HTML or SVG
# graph from it.

$wgExtensionFunctions[] = "wfGraphExtension";
 
function wfGraphExtension() {
    global $wgParser;

    # register the extension with the WikiText parser
    # the second parameter is the callback function for processing the text between the tags

    $wgParser->setHook( "graph", "renderGraph" );
}

# for Special::Version:

$wgExtensionCredits[parserhook][] = array(
	'name' => 'graph extension',
	'author' => 'Tels',
	'url' => 'http://wwww.bloodgate.com/perl/graph/',
	'version' => 'v0.15 using Graph::Easy v' . `perl -MGraph::Easy -e 'print \$Graph::Easy::VERSION'`,
);
 
# The callback function for converting the input text to HTML output
function renderGraph( $input ) {
    global $wgInputEncoding;

    if( !is_executable( "graph/graphcnv" ) ) {
	return "<strong class='error'><code>graph/graphcnv</code> is not executable</strong>";
    }

    $cmd = "graph/graphcnv ".
                 escapeshellarg($input)." ".
                 escapeshellarg($wgInputEncoding);
    $output = `$cmd`;

    if (strlen($output) == 0) {
	return "<strong class='error'>Couldn't execute <code>graph/graphcnv</code></strong>";
    }

    return $output;
}
?>
