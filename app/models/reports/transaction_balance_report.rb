class TransactionBalanceReport < Report
  def build_pdf
    WickedPdf.new.pdf_from_string(
      ApplicationController.render(
        template: "mypage/reports/transaction_balance_v#{version}",
        page_size: 'A4',
        encoding: 'UTF-8',
        assigns: {
          transaction_balance_report: self
        }
      ),
      viewport_size: '800x600',
      dpi: 96,
      orientation: 'Landscape'
    )
  end
end