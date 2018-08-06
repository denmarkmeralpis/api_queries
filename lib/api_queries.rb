require 'active_support/core_ext/string/conversions'
require 'api_queries/version'
require 'api_queries/errors/unknown_column'

# ApiQueries
module ApiQueries
  extend ActiveSupport::Concern
  # class method
  module ClassMethods
    def api_q(opts={})
      # add default value
      opts[:column_date] = 'updated_at' unless opts[:column_date].present?

      # check if specified column exists
      raise Errors::UnknownColumn, 'Invalid value for column_date.' if column_names.exclude?(opts[:column_date])

      # last updated at q
      if opts[:q] == 'last_updated_at'
        return { last_updated_at: (begin
                                     order(opts[:column_date] => :desc).limit(1).first.updated_at.strftime('%Y-%m-%dT%H:%M:%SZ')
                                   rescue StandardError
                                     nil
                                   end) }
      end

      # condition hash
      conditions = {}

      # AFTER: updated_at > given_date
      if opts[:after].present?
        conditions = ["#{opts[:column_date]} > ?", fdate(opts[:after])]
      # BEFORE: updated_at < given_date
      elsif opts[:before].present?
        conditions = ["#{opts[:column_date]} < ?", fdate(opts[:before])]
      # FROM & TO: between "from date" to "to date"
      elsif opts[:from].present? && opts[:to].present?
        conditions[opts[:column_date].to_sym] = (fdate(opts[:from])..fdate(opts[:to]))
      # FROM: updated_at >= given_date
      elsif opts[:from].present?
        conditions = ["#{opts[:column_date]} >= ?", fdate(opts[:from])]
      # TO: updated_at <= given_date
      elsif opts[:to].present?
        conditions = ["#{opts[:column_date]} <= ?", fdate(opts[:to])]
      end

      # get by status
      conditions[:status] = 'active' if opts[:active_only].to_s == '1' && conditions.is_a?(Hash)
      # return hash
      records = where(conditions)
      # get by status
      records = records.where(status: 'active') if opts[:active_only].to_s == '1' && conditions.is_a?(Array)

      if opts[:q] == 'count'
        { count: records.count }
      else
        records.order(id: :asc).paginate(page: opts[:page], per_page: 50)
      end
    end

    private

    def fdate(date_string)
      # Date.strptime(date_string, '%Y-%m-%dT%H:%M:%SZ') # YYYY-MM-DDTHH:MM:SSZ
      date_string.to_datetime
    end
  end
  extend ClassMethods
end
