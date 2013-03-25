class MembersCell < Cell::Rails
  def total_count(studio)
    @count = studio.members.count
    render
  end

  def recent_count(studio)
    @count = studio.members.recent.count
    render
  end

  def birthdays(studio)
    @count = studio.members.birthdays.count
    render
  end

  def active(studio)
    @count = studio.members.active.count
    render
  end

  def inactive(studio)
    @count = studio.members.inactive.count
    render
  end
end
