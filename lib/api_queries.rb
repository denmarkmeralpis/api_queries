require 'active_support'
require 'api_queries/version'

# ApiQueries
module ApiQueries
  extend ActiveSupport::Concern
  # class method
  module ClassMethods
    def api_q(opts={})
      # last updated at q
      if opts[:q] == 'last_updated_at'
        if count > 0
          return { last_updated_at: order('updated_at DESC').limit(1).first.updated_at.strftime('%Y-%m-%dT%H:%M:%SZ') }
        else
          return { last_updated_at: nil }
        end
      end

      # condition hash
      conditions = {}

      # AFTER: updated_at > given_date
      if opts[:after].present?
        conditions = ['updated_at > ?', fdate(opts[:after])]

      # BEFORE: updated_at < given_date
      elsif opts[:before].present?
        conditions = ['updated_at < ?', fdate(opts[:before])]

      # FROM & TO: between "from date" to "to date"
      elsif opts[:from].present? && opts[:to].present?
        conditions[:updated_at] = (fdate(opts[:from])..fdate(opts[:to]))

      # FROM: updated_at >= given_date
      elsif opts[:from].present?
        conditions = ['updated_at >= ?', fdate(opts[:from])]

      # TO: updated_at <= given_date
      elsif opts[:to].present?
        conditions = ['updated_at <= ?', fdate(opts[:to])]
      end

      # get by status
      conditions[:status] = 'active' if opts[:active_only].to_s == '1' && conditions.is_a?(Hash)

      # return hash
      records = where(conditions)

      # get by status
      records = records.where(status: 'active') if opts[:active_only].to_s == '1' && conditions.is_a?(Array)

      # count
      if opts[:q] == 'count'
        { count: records.count }
      else
        records.order(id: :asc).paginate(page: opts[:page], per_page: 50)
      end
    end

    private

    def fdate(date_string)
      Date.strptime(date_string, '%Y-%m-%dT%H:%M:%SZ') # YYYY-MM-DDTHH:MM:SSZ
    end
  end

  extend ClassMethods
end
