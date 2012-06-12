var Manager;

(function($) {
  $(function() {
    Manager = new AjaxSolr.Manager({
      solrUrl: 'http://sds6.itc.virginia.edu/solr/bsuva/'
    });

    Manager.init();
  });
})(jQuery);
