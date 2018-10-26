require 'json'

class TaskHelper
  class Error < RuntimeError
    attr_reader :kind, :details, :issue_code

    def initialize(msg, kind, details = nil)
      super(msg)
      @kind = kind
      @issue_code = issue_code
      @details = details || {}
    end

    def to_h
      { 'kind' =>  kind,
        'msg' => message,
        'details' => details }
    end
  end

  def task(params = {})
    msg = 'The task author must implement the `task` method in the task'
    raise TaskHelper::Error.new(msg, 'tasklib/not-implemented')
  end

  def self.run
    input = STDIN.read
    # Line is too long for rubocop :P
    params = JSON.parse(input).each_with_object({}) do |(k, v), acc|
      acc[k.to_sym] = v
    end

    # This method accepts a hash of parameters to run the task, then executes
    # the task. Unhandled errors are caught and turned into an error result.
    # @param [Hash] params A hash of params for the task
    # @return [Hash] The result of the task
    result = new.task(params)

    if result.class == Hash
      STDOUT.print JSON.generate(result)
    else
      STDOUT.print result.to_s
    end
  rescue TaskHelper::Error => e
    STDOUT.print(e.to_h.to_json)
    exit 1
  rescue StandardError => e
    error = TaskHelper::Error.new(e.message, e.class.to_s, e.backtrace)
    STDOUT.print(error.to_h.to_json)
    exit 1
  end
end
