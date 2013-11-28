# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController  

  include Blacklight::Catalog

  configure_blacklight do |config|
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = { 
      :qt => 'search',
      :rows => 10,
    }

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or 
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    #config.default_document_solr_params = {
    #  :qt => 'document',
    #  ## These are hard-coded in the blacklight 'document' requestHandler
    #  # :fl => '*',
    #  # :rows => 1
    #  # :q => '{!raw f=id v=$id}' 
    #}

    # solr field configuration for search results/index views
    config.index.show_link = 'ua_title'

    # solr field configuration for document/show views
    config.show.html_title = 'ua_title'
    config.show.heading = 'ua_title'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.    
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or 
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.  
    #
    # :show may be set to false if you don't want the facet to be drawn in the 
    # facet bar

    #config.add_facet_field 'example_pivot_field', :label => 'Pivot Field', :pivot => ['format', 'language_facet']

    #config.add_facet_field 'example_query_facet_field', :label => 'Publish Date', :query => {
     #  :years_5 => { :label => 'within 5 Years', :fq => "pub_date:[#{Time.now.year - 5 } TO *]" },
     #  :years_10 => { :label => 'within 10 Years', :fq => "pub_date:[#{Time.now.year - 10 } TO *]" },
     #  :years_25 => { :label => 'within 25 Years', :fq => "pub_date:[#{Time.now.year - 25 } TO *]" }
    #}

    config.add_facet_field 'ua_updated', :label=>'Successful Match'
    config.add_facet_field 'ua_singleTarget', :label=>'Single Target'
    config.add_facet_field 'ua_language', :label=>'Language'
    config.add_facet_field 'ua_freeJournal', :label=>'Free'
    config.add_facet_field 'ua_target', :label=>'Targets', :limit => 10
    config.add_facet_field 'ua_sirsiPubDateNotes', :label=>'Sirsi Date Notes'
    config.add_facet_field 'ua_inSirsi', :label=>'In Sirsi Only'
    config.add_facet_field 'ua_noIssn', :label=>'Title Only (No ISSN)'


    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    #config.add_index_field 'ua_title', :label=>'Title: '
    config.add_index_field 'ua_object_id', :label=>'SFX Object ID: '
    config.add_index_field 'ua_catkey', :label=>'Catkey: '
    config.add_index_field 'ua_issnPrint', :label=>'ISSN: '



    # solr fields to be displayed in the show (single result) view
    config.add_show_field 'ua_object_id', :label=>'SFX Object ID: '
    config.add_show_field 'ua_catkey', :label=>'Catkey: '
    config.add_show_field 'ua_issnPrint', :label=>'Print ISSN: '
    config.add_show_field 'ua_issnElectronic', :label=>'Electronic ISSN: '
    config.add_show_field 'ua_issnINCORRECT', :label=>'Incorrect ISSN: '
    config.add_show_field 'ua_target', :label=>'Targets: '
    config.add_show_field 'ua_inSirsi', :label=>'In Sirsi Only? '
    config.add_show_field 'ua_singleTarget', :label=>'Single Target? '
    config.add_show_field 'ua_updated', :label=>'Updated? '
    config.add_show_field 'ua_sirsiPubDateNotes', :label=>'Notes: '
    config.add_show_field 'ua_link_text', :label=>'Link Text (856z): '
    config.add_show_field 'ua_language', :label=>'Language: '
    config.add_show_field 'ua_freeJournal', :label=>'Free? '
    config.add_show_field 'ua_dateStatement', :label=>'Summary of Holdings: '
    config.add_show_field 'ua_alternateCatKey', :label=>'Alternate Catkey: '
    config.add_show_field 'ua_lastUpdated', :label=>'Last Updated: ' # for incremental updates
    config.add_show_field 'ua_noIssn', :label=>'Title Only (No ISSN): '

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different. 

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise. 
    
    #config.add_search_field 'all_fields', :label => 'All Fields'
    

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields. 
    
    #config.add_search_field('title') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params. 
    #  field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
    #  field.solr_local_parameters = { 
    #    :qf => '$title_qf',
    #    :pf => '$title_pf'
    #  }
    #end
    
    config.add_search_field('catkey') do |field|
      field.solr_local_parameters = { 
        :qf => '$catkey_qf',
        :pf => '$catkey_pf'
      }
    end

    config.add_search_field('Object ID') do |field|
      field.solr_local_parameters = {
        :qf => '$object_qf',
        :pf => '$object_pf'
      }
    end

   config.add_search_field('issn') do |field|
      field.solr_local_parameters = {
        :qf => '$issn_qf',
        :pf => '$issn_pf'
      }  
    end

    config.add_search_field('title') do |field|
      field.solr_local_parameters = {
       :qf => '$title_qf',
       :pf => '$title_pf'
      }
    end


    
    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as 
    # config[:default_solr_parameters][:qt], so isn't actually neccesary. 
    #config.add_search_field('subject') do |field|
    #  field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
    #  field.qt = 'search'
    #  field.solr_local_parameters = { 
    #    :qf => '$subject_qf',
    #    :pf => '$subject_pf'
    #  }
    #end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, pub_date_sort desc, title_sort asc', :label => 'relevance'
    config.add_sort_field 'pub_date_sort desc, title_sort asc', :label => 'year'
    config.add_sort_field 'author_sort asc, title_sort asc', :label => 'author'
    config.add_sort_field 'title_sort asc, pub_date_sort desc', :label => 'title'

    # If there are more than this many search results, no spelling ("did you 
    # mean") suggestion is offered.
    config.spell_max = 5
  end

end 
