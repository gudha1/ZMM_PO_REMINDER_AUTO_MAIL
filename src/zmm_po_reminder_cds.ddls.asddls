@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO REMINDER AUTO MAIL CDS'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define  root view entity ZMM_PO_REMINDER_CDS as  select distinct from I_PurchaseOrderItemAPI01 as a
left outer join I_PurchaseOrderAPI01 as d on d.PurchaseOrder = a.PurchaseOrder
left outer join I_Supplier as e on e.Supplier = d.Supplier 
left outer join I_Product as j on j.Product = a.Material
left outer join I_Address_2 as G on G.AddressID = e.AddressID
left outer join I_AddressEmailAddress_2 as K on K.AddressID = G.AddressID
left outer join I_PurOrdScheduleLineAPI01 as b on b.PurchaseOrder = a.PurchaseOrder and b.PurchaseOrderItem = a.PurchaseOrderItem
left outer join I_BusinessUserBasic as p on p.UserID = d.CreatedByUser
left outer join I_AddressEmailAddress_2 as h on h.AddressID = p.FormOfAddress

 {
 key a.PurchaseOrder,
 key a.PurchaseOrderItem,
 a.Material,
 j.ProductGroup,
 j.ProductType,
 d.CreatedByUser,
 d.Supplier,
 e.SupplierName,
 a.PurgDocPriceDate,
 a.PurchaseOrderItemText,
 a.BaseUnit,
 p.PersonFullName as Username,
 h.EmailAddress as useremail,
 K.EmailAddress,
 a.DocumentCurrency,
  @Semantics.amount.currencyCode: 'DocumentCurrency'
 a.NetPriceAmount,
 a.PurchaseOrderQuantityUnit,
 @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'  
 a.OrderQuantity,
 b.ScheduleLineDeliveryDate,
 cast(b.ScheduleLineOrderQuantity as abap.dec( 13, 3 )) as ScheduleLineOrderQuantity,
 coalesce( cast(b.ScheduleLineOrderQuantity as abap.dec( 13, 3 )),0) - 
 coalesce( cast(b.RoughGoodsReceiptQty as abap.dec( 13, 3 )),0)  as pendingqty
 
 
 }
 where 
 a.IsCompletelyDelivered = '' and
 a.PurchasingDocumentDeletionCode = ''
 and d.YY1_PO_ReleaseStat_PDH <> '08'
 and b.ScheduleLineDeliveryDate < $session.user_date
