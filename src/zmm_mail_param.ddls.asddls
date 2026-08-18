@EndUserText.label: 'Mail Parameters'
@Search.searchable: true
    define abstract entity ZMM_MAIL_PARAM
     {
      @Search: { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
      @EndUserText.label: 'CC Email'  
      CcEmail : abap.char(241);
        
    }
