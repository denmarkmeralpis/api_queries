require "api_queries/version"

module ApiQueries
   extend ActiveSupport::Concern
   module ClassMethods

      def api_q opts={}

         # last updated at q
         if opts[:q] == 'last_updated_at'
            if self.count > 0
               return { last_updated_at: self.order('updated_at DESC').limit(1).first.updated_at.strftime('%Y-%m-%dT%H:%M:%SZ') }
            else
               return { last_updated_at: nil }
            end
         end

         # condition hash
         conditions = {}

         # AFTER: updated_at > given_date
         if opts[:after].present?
            conditions = { updated_at: ((fdate(opts[:after]) + 1.second)..Time.now.utc) }

         # BEFORE: updated_at < given_date
         elsif opts[:before].present?
            conditions = { updated_at: (Time.at(0)..(fdate(opts[:before]) - 1.second)) }

         # FROM & TO: between "from date" to "to date"
         elsif opts[:from].present? && opts[:to].present?
            conditions = { updated_at: (fdate(opts[:from])..fdate(opts[:to])) }

         # FROM: updated_at >= given_date
         elsif opts[:from].present?
            conditions = { updated_at: (fdate(opts[:from])..Time.now.utc) }

         # TO: updated_at <= given_date
         elsif opts[:to].present?
            conditions = { updated_at: (Time.at(0)..fdate(opts[:to])) }
         end

         # get by status
         if opts[:active_only].to_s == '1'
            conditions = conditions.merge(status: 'active')
         end

         # return hash
         q = self.where(conditions)

         # count
         if opts[:q] == 'count'
            q = { count: q.count }
         else
            q.paginate(page: opts[:page], per_page: 50)
         end
      end

      private

      def fdate date_string
         # YYYY-MM-DDTHH:MM:SSZ
         DateTime.strptime(date_string, '%Y-%m-%dT%H:%M:%SZ')
      end

   end
   extend ClassMethods
end
