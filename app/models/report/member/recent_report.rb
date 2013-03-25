module Report
  module Member
    class RecentReport
      def initialize(studio)
        @studio = studio
      end

      def members
        @studio.members.recent
      end

      def name
        'New Members'
      end

      def to_csv
        CSV.generate do |csv|
          csv << %w(First\ Name Last\ Name Phone Email Date\ Added)
          members.each do |member|
            csv << [member.first_name, member.last_name, member.try(:phone), member.try(:email), member.created_at.strftime('%m/%d/%Y')]
          end
        end
      end

      def filename
        'recent_members.csv'
      end
    end
  end
end
