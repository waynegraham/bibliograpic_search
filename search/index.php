<?php

header('Content-Type: text/html; charset=utf-8');

$start = 0;
$rows = 10;
$query = isset($_REQUEST['q']) ? $_REQUEST['q'] : false;
$results = false;

// TODO|localhost
// $server = 'sds6.itc.virginia.edu';
// $port = 8080;
// $path = '/solr/bsuva';

$server = 'localhost';
$port = 8983;
$path = '/solr';

if ($query) {

    include_once 'lib/Service.php';
    $solr = new Apache_Solr_Service($server, $port, $path);

    $additionalParameters = array(
        'facet'             => 'true',
        'facet.mincount'    => 1,
        'facet.limit'       => $rows,
        'facet.field'       => 'project_s',
        'hl'                => 'true',
        'hl.fl'             => 'fulltext_t',
        'hl.fragsize'       => '500',
        'hl.snippets'       => 1
    );

    if (isset($_REQUEST['fq'])) {
        $additionalParameters['fq'] = 'facet_title:"' . $_REQUEST['fq'] .'"';
    }

    if (isset($_REQUEST['start'])) {
        $start = $_REQUEST['start'];
    }

    try {
        $results = $solr->search($query, $start, $rows, $additionalParameters);
    } catch (Exception $e) {
        die("<html><head><title>SEARCH EXCEPTION</title><body><pre>{$e->__toString()}</pre></body></html>");
    }
}

function displayResults($results, $start, $rows)
{

    $html = '';

    if ($results) {
        $total = (int) $results->response->numFound;
        $start = min($start+1, $total);
        $end = min($start+$rows-1, $total);

        $html = "<div>Results {$start} - {$end} of {$total}</div>";
        $html .= "<div id='results'>";

        foreach ($results->response->docs as $doc) {
            $title = htmlspecialchars($doc->__get('title_s'), ENT_NOQUOTES, 'utf-8');
            $id = $doc->__get('id');
            $snippet = $results->highlighting->$id->fulltext_t[0];
            $url = $doc->__get('file_s').'.html#'.$doc->__get('section_s');

            $html .= "<div class='result'>";
            $html .= "<h3><a href='{$url}'>{$title}</a></h3>";
            $html .= "<p class='snippet'>{$snippet}</p>";
            $html .= "</div>";
        }

        $html .= '</div>';

    }

    return $html;

}

function displayFacets($results, $query)
{

    $html = '<ul class="page-nav">';

    foreach ((array)$results->facet_counts->facet_fields as $facet => $values) {
        foreach ($values as $label => $count) {
            $html .= '<li><a href="' . buildFacetString($label) . '">' . $label . '</a> ('.$count.')</li>';
        }
    }

    $html .= '</ul>';

    if (isset($_REQUEST['fq'])) {
        $html .= '<a href="'. removeFacet() .'" class="clear-facet">Reset</a>';
    }

    return $html;

}

function buildFacetString($facet)
{
    parse_str($_SERVER['QUERY_STRING'], $query_string);
    $query_string['fq'] = $facet;
    unset($query_string['start']);
    return '?' . http_build_query($query_string);
}

function removeFacet($facet)
{
    parse_str($_SERVER['QUERY_STRING'], $query_string);
    unset($query_string['fq']);
    return '?' . http_build_query($query_string);
}

function nextLink($start, $rows)
{
    parse_str($_SERVER['QUERY_STRING'], $query_string);
    $query_string['start'] = $start + $rows;
    return '?' . http_build_query($query_string);
}

function previousLink($start, $rows)
{
    parse_str($_SERVER['QUERY_STRING'], $query_string);
    $query_string['start'] = $start - $rows;
    return '?' . http_build_query($query_string);
}

?>
<!doctype html>
<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
<head>
    <meta charset="utf-8" />
    <title>The Bibliographical Society of the University of Virginia</title>
    <meta name="description" content="The Bibliographical Society of the University of Virginia Digital Publication Search"/>
    <meta name="viewport" content="width=device-width">
    <link rel="stylesheet" href="stylesheets/screen.css">
    <link rel="stylesheet" href="http://bsuva-epubs.org/wordpress/wp-content/themes/bsuva/style.css">
    <script src="js/vendor/modernizr-2.5.3.min.js"></script>
</head>
<body>

    <div id="content">

        <div id="masthead">
            <img alt="masthead" src="http://bsuva-epubs.org/wordpress/wp-content/themes/bsuva/images/type.jpg">
        </div>

        <article>
            <header><h1>Search Digital Publicaions</h1></header>

            <div class="entry-content">

                <form accept-charset="utf-8" method="get" class="well form-search">
                    <input type="text" name="q" class="input-xlarge search-query" id="q" placeholder="Search..." value="<?php echo htmlspecialchars($query, ENT_QUOTES, 'utf-8'); ?>" />
                    <button class="btn" type="submit">Search</button>
                </form>

                <?php echo displayResults($results, $start, $rows); ?>
                <?php if (!$results): ?>
                    <p class="welcome">Enter a term or phrase to search the corpus.</p>
                <?php endif; ?>

                <div class="pager">
                    <ul>
                        <?php if ($start > 0): ?>
                            <li class="previous"><a href="<?php echo previousLink($start, $rows); ?>">&larr; Prev</a></li>
                        <?php endif; ?>
                        <?php if ($start + $rows < (int) $results->response->numFound): ?>
                            <li class="next"><a href="<?php echo nextLink($start, $rows); ?>">Next &rarr;</a></li>
                        <?php endif; ?>
                    </ul>
                </div>

            </div>


        </article>
        <div id="sidebar">
            <?php if ($results): ?>
                <h3>Limit by Title</h3>
            <?php endif; ?>
            <?php echo displayFacets($results, $query); ?>
        </div>
    </div>
</body>
</html>
