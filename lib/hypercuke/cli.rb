require 'hypercuke/cli/parser'
require 'hypercuke/cli/builder'

module Hypercuke
  class CLI
    def self.exec(argv, opts = {})
      cli = new(argv)

      if out = opts[:output_to]
        out.puts cli.cucumber_command_with_env_var
      end

      ENV['HYPERCUKE_LAYER'] = cli.layer_name
      Kernel.exec cli.cucumber_command
    end

    def initialize(argv)
      @argv = argv
    end

    def layer_name
      parser.layer_name
    end

    def cucumber_command
      builder.cucumber_command_line
    end

    def cucumber_command_with_env_var
      "HYPERCUKE_LAYER=#{layer_name} #{cucumber_command}"
    end

    private
    attr_reader :argv

    def parser
      @parser ||= Hypercuke::CLI::Parser.new(argv)
    end

    def builder
      @builder ||= Hypercuke::CLI::Builder.new(parser.options)
    end
  end
end
