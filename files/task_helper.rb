require 'json'

class TaskHelper
  attr_accessor :context

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

  # Accepts a Data object and returns a copy with all hash keys
  # symbolized.
  def self.walk_keys(data)
    if data.is_a? Hash
      data.each_with_object({}) do |(k, v), acc|
        v = walk_keys(v)
        acc[k.to_sym] = v
      end
    elsif data.is_a? Array
      data.map { |v| walk_keys(v) }
    else
      data
    end
  end

  def self.run
    input = STDIN.read
    params = walk_keys(JSON.parse(input))

    # This method accepts a hash of parameters to run the task, then executes
    # the task. Unhandled errors are caught and turned into an error result.
    # @param [Hash] params A hash of params for the task
    # @return [Hash] The result of the task

    tsk = new
    tsk.context = RemoteContext.new(params) if params.key? :_target
    result = tsk.task(params)

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

  class RemoteContext
    attr_reader :params

    def initialize(params)
      @transport = {}
      @params = params

      return unless params.key? :_installdir
      add_plugin_paths(params[:_installdir])
    end

    def transport
      require 'puppet/resource_api/transport'

      @transport[target[:'remote-transport']] ||= Puppet::ResourceApi::Transport
                                                  .connect(
                                                    target[:'remote-transport'],
                                                    target
                                                  )
    end

    def target
      @target ||= params[:_target]
    end

    private

    # Syncs across anything from the module lib
    def add_plugin_paths(install_dir)
      Dir.glob(File.join([install_dir, '*'])).each do |mod|
        $LOAD_PATH << File.join([mod, 'lib'])
      end
    end
  end
end
