class AccountsCell < Cell::Rails
  def past_due(studio)
    @count = studio.accounts.past_due.count
    render
  end

  def due(studio)
    @count = studio.accounts.due.count
    render
  end

  def up_to_date(studio)
    @count = studio.accounts.up_to_date.count
    render
  end
end
