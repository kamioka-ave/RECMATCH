FactoryBot.define do
  factory :jnb_transfer do
    order_id 1
    jnb_account_id 1
    hd_vl "MyString"
    hd_msg_class "MyString"
    hd_comp_code "MyString"
    hd_detail_code "MyString"
    hd_req_date_time "MyString"
    hd_rsp_date_time "MyString"
    hd_tran_id "MyString"
    hd_hash_value "MyString"
    data_kbn 1
    shokai_no "MyString"
    kanjo_date "2018-07-23"
    kisan_date "2018-07-23"
    amount "MyString"
    another_amount "MyString"
    output_code "MyString"
    output_name "MyString"
    rmt_bank_name "MyString"
    rmt_br_name "MyString"
    cancel_kind 1
    edi_info "MyString"
    dummy "MyString"
    status 1
  end
end
