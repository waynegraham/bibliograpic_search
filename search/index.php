<?php
/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */
header('Content-Type: text/html; charset=utf-8');

$limit = 100;
$query = isset($_REQUEST['q']) ? $_REQUEST['q'] : false;
$results = false;

$server = 'sds6.itc.virginia.edu';
$port = 8080;
$path = '/solr/bsuva';

if ($query) {
    include_once 'lib/Service.php';

    $solr = new Apache_Solr_Service($server, $port, $path);

    $fq = '';

    if (isset($_GET['fq'])) {
        $fq = htmlspecialchars($_GET['fq']);
    }

    $additionalParameters = array(
        'facet' => 'true',
        'facet.mincount' => 1,
        'facet.limit' => 10,
        'facet.field' => 'project_s',
        'hl' => 'true',
        'hl.snippets' => 1,
        'hl.fragsize' => '300',
        'hl.fl' => 'fulltext_t',
        'fq' => $fq
    );

    try {
        $results = $solr->search($query, 0, $limit, $additionalParameters);
    } catch (Exception $e) {
        die("<html><head><title>SEARCH EXCEPTION</title><body><pre>{$e->__toString()}</pre></body></html>");
    }
}

function displayResults($results)
{
    $html = '';

    if ($results) {
        $total = (int) $results->response->numFound;
        $start = min(1, $total);
        $end = min($limit, $total);

        //$html = "<div>Results {$start} - {$end} of {$total}</div>";
        $html .= "<div id='results'>";

        foreach ($results->response->docs as $doc) {
            $title = htmlspecialchars($doc->__get('title_s'), ENT_NOQUOTES, 'utf-8');
            $snippet = substr(htmlspecialchars($doc->__get('fulltext_t'), ENT_NOQUOTES, 'utf-8'), 0, 300);

            $url = $doc->__get('slug_s');
            $url .= $doc->__get('file_s') . '.html#' . $doc->__get('section_s');

            $html .= "<div class='result'>";
            $html .= "<h3><a href='{$url}'>{$title}</a></h3>";
            $html .= "<p class='snippet'>{$snippet}</p>";
            $html .= "</div>";
        }

        $html .= '</div>';

    }

    return $html;

}

function displayFacets($results)
{
    $html = '<ul class="page-nav">';

    foreach ((array)$results->facet_counts->facet_fields as $facet => $values) {

        foreach ($values as $label => $count) {
            $facet = $_GET['q'] . '&fq=' . htmlspecialchars($label);
            $html .= '<li><a href="?q='. $facet .'">' . $label . ' (' . $count . ')</a></li>';
        }

    }

    $html .= '</ul>';

    return $html;
}

function getParams(
        $req=null, $qParam='q', $facetParam='solrfacet', $other=null
    ) {
        if ($req === null) {
            $req = $_REQUEST;
        }
        $params = array();

        if (isset($req[$qParam])) {
            $params['q'] = $req[$qParam];
        }

        if (isset($req[$facetParam])) {
            $params['facet'] = $req[$facetParam];
        }

        if ($other !== null) {
            foreach ($other as $key) {
                if (array_key_exists($key, $req)) {
                    $params[$key] = $req[$key];
                }
            }
        }

        return $params;
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
    <header role="banner">
        <h1><a href=""><img src="http://bsuva-epubs.org/wordpress/wp-content/themes/bsuva/images/bsuva-logo.png" alt="Bibliographical Society" /></a></h1>
    </header>
    <div id="content">

        <div id="masthead">
            <img alt="masthead" src="http://bsuva-epubs.org/wordpress/wp-content/themes/bsuva/images/type.jpg">
        </div>

        <article>
            <header><h1>Search Digital Publications</h1></header>

            <div class="entry-content">
                <form accept-charset="utf-8" method="get" class="well form-search">
                    <input type="text" name="q" class="input-xlarge search-query" id="q" placeholder="Search..." value="<?php echo htmlspecialchars($query, ENT_QUOTES, 'utf-8'); ?>" />
                    <button class="btn" type="submit">Search</button>
                </form>
                 <?php
                    echo displayResults($results);
                ?>
                <div class="pager">
                    <ul>
                        <li class="previous"><a href="#">&larr; Prev</a></li>
                        <li class="next"><a href="#">Next &rarr;</a></li>
                    </ul>
                </div>

            </div>


        </article>
        <div id="sidebar">
            <h3>Limit Search</h3>
            <?php echo displayFacets($results); ?>
        </div>
    </div>
</body>
</html>
