@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contact user'
@Metadata.ignorePropagatedAnnotations: true
define view entity zcontact_user as select from I_User as _user
{
      @ObjectModel.text.element : [ 'UserDescription' ]
  key _user.UserID,
      _BusinessPartner.PersonNumber as Person,
      _user.BusinessPartnerUUID,
      @Semantics.text: true
      @Search: { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.7 }
      _user.UserDescription,
      @Semantics.name.givenName: true
      _BusinessPartner.FirstName,
      @Semantics.name.familyName: true
      _BusinessPartner.LastName,
       @Semantics.name.fullName: true
      _BusinessPartner.PersonFullName,
      _user.AddressID,
      @Semantics.eMail.type:  [ #WORK ]
      @Semantics.eMail.address: true
      _AddrCurDefaultEmailAddress.EmailAddress,
      @Semantics.telephone.type:  [ #WORK ]
      _BusinessPartner._BPAddressIndependentPhone.InternationalPhoneNumber,
      @Semantics.telephone.type:  [ #CELL ]
      _BusinessPartner._BPAddressIndependentMobile.MobilePhoneNumber,
      @UI.hidden:true
      'Creator'                                                                                   as ContactCardRole,
      @UI.hidden:true
      'User'                                                                                      as ContactCardType,

      @UI.hidden:true
      'User'                                                                                      as ContactCardNavLinkSemanticObj,
      @UI.hidden:true
      concat('User=', _user.UserDescription)                                                                as ContactCardNavLinkQueryPart
}
where _user.UserID like 'CB%'
