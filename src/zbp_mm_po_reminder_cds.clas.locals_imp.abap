CLASS lhc_remindermail DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR remindermail RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ remindermail RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK remindermail.

    METHODS mail FOR MODIFY
      IMPORTING keys FOR ACTION remindermail~mail.
    METHODS linemail FOR MODIFY
      IMPORTING keys FOR ACTION remindermail~linemail.
      TYPES : BEGIN OF it_solisti1 ,
              line TYPE c LENGTH 255,
            END OF it_solisti1.
    DATA : i_objtx            TYPE STANDARD TABLE OF it_solisti1,
           i_objtxt           TYPE it_solisti1,
           lv_date            TYPE sy-datum,
           quantity           TYPE string,
           Net_quality        TYPE string,
           lx_bcs_mail TYPE REF TO cx_bcs_mail,
           xml_file           TYPE string,
           Pendingqty         TYPE string,
           del_date           TYPE string,
           text               TYPE string,
           lv_cc_email        TYPE c LENGTH 512 ,
           po_date            TYPE string.

ENDCLASS.

CLASS lhc_remindermail IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  SELECT a~* FROM ZMM_PO_REMINDER_CDS WITH PRIVILEGED ACCESS as a
inner join @Keys as b on ( b~PurchaseOrder = A~PurchaseOrder AND B~PurchaseOrderItem = A~PurchaseOrderItem )
INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD mail.

READ ENTITIES OF ZMM_PO_REMINDER_CDS IN LOCAL MODE
ENTITY ReminderMail
ALL FIELDS WITH
CORRESPONDING #( keys )
RESULT DATA(lv_documents)
FAILED failed.

 lv_cc_email = keys[ 1 ]-%param-CcEmail.

DATA: lv_sl TYPE i VALUE 0.
DATA: lv_sl_str TYPE string.
DATA(IT1) = lv_documents[].
DATA(IT2) = lv_documents[].
SORT IT1 BY Supplier.
SORT IT2 BY Supplier PurchaseOrder PurchaseOrderItem.

DELETE ADJACENT DUPLICATES FROM it1 COMPARING Supplier.
LOOP AT it1 INTO DATA(wa_po).   "< your internal table


i_objtxt-line = '<HTML><BODY>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.


i_objtxt-line = '<p>Dear Sir,</p>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<p> Greatings From Gallantt Ispat Limited.</p>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<p>Upon verification of our records, we observe that the following Purchase Orders are pending for receipt at our end:</p>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

* =============================================
* HORIZONTAL TABLE - Column Headers Row
* =============================================
i_objtxt-line = '<table border="1" cellpadding="4" cellspacing="0" style="width:100%;border-collapse:collapse;">'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

* Header Row
i_objtxt-line = '<tr>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<th bgcolor="#a3d4ba" align="center"><b>Sl. No.</b></th>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<th bgcolor="#a3d4ba" align="center"><b>PO No.</b></th>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<th bgcolor="#a3d4ba" align="center"><b>PO Item </b></th>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<th bgcolor="#a3d4ba" align="center"><b>PO Date</b></th>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<th bgcolor="#a3d4ba" align="center"><b>Item Description</b></th>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<th bgcolor="#a3d4ba" align="center"><b>UOM</b></th>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<th bgcolor="#a3d4ba" align="center"><b>PO Qty</b></th>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<th bgcolor="#a3d4ba" align="center"><b>Pending Qty</b></th>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<th bgcolor="#a3d4ba" align="center"><b>Price</b></th>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<th bgcolor="#a3d4ba" align="center"><b>Delivery Date</b></th>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '</tr>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.


*  table

LOOP AT it2 INTO DATA(wa_po1) WHERE Supplier = wa_po-Supplier.   "< your internal table

    lv_sl = lv_sl + 1.
    lv_sl_str = lv_sl.

 quantity = wa_po1-OrderQuantity.
 net_quality = wa_po1-NetPriceAmount.
 pendingqty = wa_po1-pendingqty.
 po_date = wa_po1-PurgDocPriceDate+6(2) && '.' &&
           wa_po1-PurgDocPriceDate+4(2) && '.' &&
           wa_po1-PurgDocPriceDate+0(4).
 del_date = wa_po1-ScheduleLineDeliveryDate+6(2) && '.' &&
           wa_po1-ScheduleLineDeliveryDate+4(2) && '.' &&
           wa_po1-ScheduleLineDeliveryDate+0(4).

  i_objtxt-line = '<tr>'.
  APPEND i_objtxt TO i_objtx.
  CLEAR: i_objtxt.

  CONCATENATE '<td align="center">' lv_sl_str '</td>' INTO i_objtxt-line.
  APPEND i_objtxt TO i_objtx.
  CLEAR: i_objtxt.

  CONCATENATE '<td align="center">' wa_po1-PurchaseOrder '</td>' INTO i_objtxt-line.
  APPEND i_objtxt TO i_objtx.
  CLEAR: i_objtxt.

  CONCATENATE '<td align="center">' wa_po1-PurchaseOrderItem '</td>' INTO i_objtxt-line.
  APPEND i_objtxt TO i_objtx.
  CLEAR: i_objtxt.

  CONCATENATE '<td align="center">' po_date '</td>' INTO i_objtxt-line.
  APPEND i_objtxt TO i_objtx.
  CLEAR: i_objtxt.

  CONCATENATE '<td align="center">' wa_po1-PurchaseOrderItemText '</td>' INTO i_objtxt-line.
  APPEND i_objtxt TO i_objtx.
  CLEAR: i_objtxt.

  CONCATENATE '<td align="center">' wa_po1-BaseUnit '</td>' INTO i_objtxt-line.
  APPEND i_objtxt TO i_objtx.
  CLEAR: i_objtxt.

  CONCATENATE '<td align="center">' quantity '</td>' INTO i_objtxt-line.
  APPEND i_objtxt TO i_objtx.
  CLEAR: i_objtxt.

  CONCATENATE '<td align="center">' pendingqty '</td>' INTO i_objtxt-line.
  APPEND i_objtxt TO i_objtx.
  CLEAR: i_objtxt.

  CONCATENATE '<td align="center">' net_quality '</td>' INTO i_objtxt-line.
  APPEND i_objtxt TO i_objtx.
  CLEAR: i_objtxt.

  CONCATENATE '<td align="center">' del_date '</td>' INTO i_objtxt-line.
  APPEND i_objtxt TO i_objtx.
  CLEAR: i_objtxt.

  i_objtxt-line = '</tr>'.
  APPEND i_objtxt TO i_objtx.
  CLEAR: i_objtxt,wa_po1,lv_sl_str.

ENDLOOP.

* End Table
i_objtxt-line = '</table>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

* =============================================
* FOOTER CONTENT
* =============================================
i_objtxt-line = '<p><b>Delivery Address:</b><br>Sector 23, GIDA, Sahjanwa,<br>Gorakhpur - 273209, Uttar Pradesh</p>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<p>You are requested to please arrange immediate delivery of the pending materials and confirm the same to us at the earliest. Kindly share a copy of the dispatch documents for our records.</p>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<p>In case the material has already been dispatched, please provide the dispatch details (LR No., Invoice No., and date) to enable us to update our records accordingly.</p>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<p>Your prompt cooperation in this matter will be highly appreciated.</p>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<p>Thanking you,<br>Yours faithfully,<br>For Gallantt Ispat Limited</p>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '<hr><i>This is a system-generated reminder and does not require a physical signature.</i>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.

i_objtxt-line = '</BODY></HTML>'.
APPEND i_objtxt TO i_objtx.
CLEAR: i_objtxt.




   DATA :
      v_lines_txt TYPE i,
      v_lines_bin TYPE i.
 DATA lv TYPE string .
    v_lines_txt = lines( i_objtx ).

    LOOP  AT i_objtx INTO i_objtxt .
      IF lv = ''.
        lv = i_objtxt.
      ELSE.
        CONCATENATE lv i_objtxt INTO lv.
        CONDENSE lv .
      ENDIF.

    ENDLOOP.
   CLEAR: i_objtx.



   data: cc_emails TYPE TABLE OF string,
         lv_cc TYPE c LENGTH 512,
         lv_to TYPE c LENGTH 512,
         mail type c LENGTH 512.

if wa_po-EmailAddress is NOT INITIAL.
lv_to = wa_po-EmailAddress.
endif.
   IF lv_cc_email IS NOT INITIAL.
  SPLIT lv_cc_email AT ';' INTO TABLE cc_emails.
ENDIF.
SELECT SINGLE FROM zcontact_user WITH PRIVILEGED ACCESS
FIELDS
EmailAddress
WHERE UserID = @sy-uname
into @mail.

       TRY.
        DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
        lo_mail->set_sender( mail ).
        lo_mail->add_recipient( lv_to ).
        IF lv_cc_email IS NOT INITIAL.

        LOOP AT cc_emails INTO DATA(cc_mail).
        lv_cc = cc_mail.
        lo_mail->add_recipient( iv_address = lv_cc iv_copy = cl_bcs_mail_message=>cc ).
        ENDLOOP.
      ENDIF.
        lo_mail->set_subject( | Reminder For Pending Purchase Order | ).
        lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
        iv_content      = lv
        iv_content_type = 'text/html'
        ) ).

        lo_mail->send( IMPORTING et_status = DATA(lt_status) ).

     CATCH cx_bcs_mail INTO lx_bcs_mail.
    ENDTRY.
    if lx_bcs_mail is INITIAL.
  APPEND VALUE #( %tky = keys[ 1 ]-%tky
    %msg = new_message_with_text(
    severity = if_abap_behv_message=>severity-success
    text = 'Mail Send SuccessFully'
    ) ) TO reported-remindermail .
    endif.

CLEAR : wa_po, lv,i_objtx.
ENDLOOP.
  ENDMETHOD.

  METHOD lineMail.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmm_po_reminder_cds DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_po_reminder_cds IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
