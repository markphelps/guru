module SidebarHelper
  def members_controller?
    controller?('members', 'payments', 'memberships', 'members/imports', 'members/notes')
  end

  def settings_controller?
    controller?('settings/studios', 'settings/users', 'settings/members')
  end

  def reports_controller?
    controller?('reports/members/birthdays', 'reports/members/recent', 'reports/payments', 'reports/attendance/absent', 'reports/attendance/present', 'reports/accounts')
  end
end
