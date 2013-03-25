namespace :accounts do
  desc 'Update up_to_date account payment_due_dates'
  task :update_due_dates => :environment do
    Studio.find_each do |studio|
      studio.accounts.up_to_date.find_each do |account|
        if account.due_date_passed?
          account.payment_due_date = account.next_payment_due_date
          if account.changed?
            Rails.logger.info "Updating payment_due_date for account=#{account.id}, studio=#{studio.id}"
            account.update_status
            account.save!
          end
        end
      end
    end
  end

  desc 'Update now due accounts'
  task :update_due => :environment do
    Studio.find_each do |studio|
      studio.accounts.due_today.find_each do |account|
        Rails.logger.info "Marking account=#{account.id} as due, studio=#{studio.id}"
        account.payment_is_due!
        account.save!
      end
    end
  end

  desc 'Update now past_due accounts'
  task :update_past_due => :environment do
    Studio.find_each do |studio|
      studio.accounts.past_due_today.find_each do |account|
        Rails.logger.info "Marking account=#{account.id} as past_due, studio=#{studio.id}"
        account.payment_is_past_due!
        account.save!
      end
    end
  end

  desc "Sync all accounts"
  task :sync => :environment do
    Studio.find_each do |studio|
      studio.accounts.find_each do |account|
        Rails.logger.info "Synching account=#{account.id}, studio=#{studio.id}"
        account.update_status
        account.save!
      end
    end
  end
end
