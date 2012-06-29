MerchantCategory.data_miner do
  process "Start from scratch" do
    delete_all
  end
  
  import "the IRS Merchant Category Code table",
         :url => 'http://www.irs.gov/irb/2004-31_IRB/ar17.html',
         :headers => %w{mcc description ignore},
         :row_css => 'div.informaltable tbody tr',
         :column_css => 'td' do
    key 'mcc'
    store 'description'
  end
end
