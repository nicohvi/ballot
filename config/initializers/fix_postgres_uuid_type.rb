class ActiveRecord::ConnectionAdapters::AbstractAdapter
  def translate_exception(exception, message)
    if exception.is_a?(PG::InvalidTextRepresentation)
      raise ActiveRecord::RecordNotFound
    else
      # override in derived class
      ActiveRecord::StatementInvalid.new(message, exception)
    end
  end
end
